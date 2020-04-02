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
@property (copy, nonatomic) BlkDownloadProgress         blkDownloadPgs;
@property (copy, nonatomic) BlkDownloadTaskComplete     blkCompletion;
@end

@implementation XTDownloadTask

#pragma mark - life

+ (XTDownloadTask *)downloadTask:(NSString *)downloadUrl
                          header:(NSDictionary *)header
                        fileName:(NSString *)fileName
                      targetPath:(NSString *)targetPath {
    
    if (!targetPath) targetPath = [self createDefaultPath];
    XTDownloadTask *task = [[XTDownloadTask alloc] init];
    task.strURL = downloadUrl;
    task.header = header;    
    
    task.filename = fileName;
    task.fileType = [task.filename pathExtension];
    task.folderPath = targetPath;
    task.state = XTReqTaskStateWaiting;
    return task;
}

+ (XTDownloadTask *)downloadTask:(NSString *)downloadUrl
                          header:(NSDictionary *)header
                        fileName:(NSString *)fileName {
    return [self downloadTask:downloadUrl header:header fileName:fileName targetPath:nil];
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
        NSURL *url = [NSURL URLWithString:self.strURL] ;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval = 60*3;
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
            NSLog(@"download completionHandler");
            
            BOOL isComplete;
            if (error && error.code == -1005) { // 网络中断
                isComplete = NO;
                self.state = XTReqTaskStateFailed;
            }
            else {
                int statusCode = [[response valueForKey:@"statusCode"] intValue];
                if (statusCode > 400 && statusCode < 599) {
                    isComplete = NO;
                    self.state = XTReqTaskStateFailed;
                } else {
                    isComplete = self.state == XTReqTaskStateSuccessed;
                }
            }
                        
            if (isComplete) {
                // 清空长度
                self.currentLength = 0;
                self.curTmpLength = 0;
                self.fileLength = 0;
                // 关闭fileHandle
                [self.fileHandle closeFile];
                self.fileHandle = nil;
                self.manager = nil;
            }
                        
            if (self.blkCompletion) self.blkCompletion(self, isComplete);
        }];
        
        [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
            @strongify(self)
            // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
            self.fileLength = response.expectedContentLength + self.currentLength + self.curTmpLength;
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
            self.curTmpLength += data.length;
            if (self.curTmpLength + self.currentLength == self.fileLength) {
                self.state = XTReqTaskStateSuccessed;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pgs = (1.0 * (self.currentLength + self.curTmpLength) / self.fileLength);
                
                if (self.blkDownloadPgs) self.blkDownloadPgs(self, self.pgs);
            });
        }];
    }
    return _sessionDownloadTask;
}


#pragma mark - Func

- (void)observeDownloadProgress:(void (^)(XTDownloadTask *task, float progress))progressBlock
             downloadCompletion:(void (^)(XTDownloadTask *task, BOOL isComplete))completionBlock {
    
    if (progressBlock) self.blkDownloadPgs = progressBlock;
    if (completionBlock) self.blkCompletion = completionBlock;
}

- (void)offlineResume {
    self.state = XTReqTaskStateDoing;
    NSInteger currentLength = [self fileLengthForPath:[self destinationPath]];
    self.currentLength = currentLength;
    self.curTmpLength = 0;
    
    [self.sessionDownloadTask resume];
}

- (void)offlinePause { // 假暂停
    self.state = XTReqTaskStatePaused;
    [self.sessionDownloadTask cancel];
    self.sessionDownloadTask = nil;
}

#pragma mark - database 供外部做数据库持久化, 可不用.

// props Sqlite Keywords
+ (NSDictionary *)modelPropertiesSqliteKeywords {
    return @{
        @"identifier":@"UNIQUE",
    };
}

// ignore Properties . these properties will not join db CURD .
+ (NSArray *)ignoreProperties {
    return @[@"pgs",
             @"userInfo",
             @"state",
             @"sessionDownloadTask",
             @"manager",
             @"fileLength",
             @"currentLength",
             @"curTmpLength",
             @"fileHandle",
             @"downloadSpeed",
    ];
}

@end
