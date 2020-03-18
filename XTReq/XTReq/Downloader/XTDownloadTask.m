//
//  XTDownloadTask.m
//  XTReq
//
//  Created by teason23 on 2020/3/15.
//  Copyright © 2020 teaason. All rights reserved.
//

#import "XTDownloadTask.h"
#import <CommonCrypto/CommonDigest.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "XTDownloadTask+Extension.h"


typedef void(^BlkDownloadProgress)(XTDownloadTask *task, float pgs);
typedef void(^BlkDownloadTaskComplete)(XTDownloadTask *task, BOOL isComplete);

@interface XTDownloadTask ()
@property (copy, nonatomic) NSDictionary                *header;
@property (copy, nonatomic) BlkDownloadProgress         blkDownloadPgs;
@property (copy, nonatomic) BlkDownloadTaskComplete     blkCompletion;
@end

@implementation XTDownloadTask

+ (XTDownloadTask *)downloadTask:(NSURL *)downloadUrl
                          header:(NSDictionary *)header
                      targetPath:(NSString *)targetPath {
    
    if (!targetPath) targetPath = [self createDefaultPath];
    XTDownloadTask *task = [[XTDownloadTask alloc] init];
    task.header = header;
    task.downloadUrl = downloadUrl;
    task.filename = [[downloadUrl absoluteString] lastPathComponent];
    task.fileType = [task.filename pathExtension];
    task.folderPath = targetPath;
    task.downloadState = XTDownloadTaskStateWaiting;
    return task;
}

+ (XTDownloadTask *)downloadTask:(NSURL *)downloadUrl
                          header:(NSDictionary *)header {
    return [self downloadTask:downloadUrl header:header targetPath:nil];
}

- (AFURLSessionManager *)manager {
    if (!_manager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _manager;
}

- (NSURLSessionDataTask *)sessionDownloadTask {
    if (!_sessionDownloadTask) {
        NSURL *url = self.downloadUrl;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString *resumePath = [self destinationPath];
        // 设置HTTP请求头中的Range
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        if (self.header) {
            for (NSString *key in self.header) {
                [request setValue:self.header[key] forHTTPHeaderField:key];
            }
        }
        
        @weakify(self)
        _sessionDownloadTask = [self.manager dataTaskWithRequest:request
                                                  uploadProgress:nil
                                                downloadProgress:nil
                                               completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            @strongify(self)
            NSLog(@"session completionHandler");
            BOOL isComplete = self.downloadState == XTDownloadTaskStateDownloaded;
            if (isComplete) {
                // 清空长度
                self.currentLength = 0;
                self.fileLength = 0;
                // 关闭fileHandle
                [self.fileHandle closeFile];
                self.fileHandle = nil;
                self.manager = nil;
            }
            
            self.blkCompletion(self, isComplete);
            if (isComplete) {
                self.blkDownloadPgs = nil ;
                self.blkCompletion = nil ;
            }
        }];
        
        [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
            @strongify(self)
            // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
            self.fileLength = response.expectedContentLength + self.currentLength;
            // 创建一个空的文件到沙盒中
            NSFileManager *manager = [NSFileManager defaultManager];
            if (![manager fileExistsAtPath:resumePath]) {
                // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
                [manager createFileAtPath:resumePath contents:nil attributes:nil];
            }
            // 创建文件句柄
            self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:resumePath];
            return NSURLSessionResponseAllow;
        }];
        
        [self.manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
            @strongify(self)
            // 指定数据的写入位置 -- 文件内容的最后面
            [self.fileHandle seekToEndOfFile];
            [self.fileHandle writeData:data];
            self.currentLength += data.length;
            if (self.currentLength == self.fileLength) {
                self.downloadState = XTDownloadTaskStateDownloaded;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.blkDownloadPgs) self.blkDownloadPgs(self, (1.0 * self.currentLength / self.fileLength));
            });
        }];
    }
    return _sessionDownloadTask;
}


#pragma mark -

- (void)observeDownloadProgress:(void (^)(XTDownloadTask *task, float progress))progressBlock
             downloadCompletion:(void (^)(XTDownloadTask *task, BOOL isComplete))completionBlock {
    
    if (progressBlock) self.blkDownloadPgs = progressBlock;
    if (completionBlock) self.blkCompletion = completionBlock;
}

- (void)offlineResume {
    self.downloadState = XTDownloadTaskStateDownloading;
    NSInteger currentLength = [self fileLengthForPath:[self destinationPath]];
    if (currentLength > 0) self.currentLength = currentLength;
    
    [self.sessionDownloadTask resume];
}

- (void)offlinePause {
    self.downloadState = XTDownloadTaskStatePaused;
    [self.sessionDownloadTask suspend];
}


@end
