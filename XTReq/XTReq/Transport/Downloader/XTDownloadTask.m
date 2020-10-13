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
#import "XTReqConst.h"

typedef void(^BlkDownloadProgress)(XTDownloadTask *task, float pgs);
typedef void(^BlkDownloadTaskComplete)(XTDownloadTask *task, XTReqTaskState state, NSError *error);

@interface XTDownloadTask ()
@property (copy, nonatomic)   BlkDownloadProgress       blkDownloadPgs;
@property (copy, nonatomic)   BlkDownloadTaskComplete   blkCompletion;
@property (nonatomic, strong) AFHTTPSessionManager      *manager;
@property (nonatomic, assign) NSInteger                 currentLength;
@property (nonatomic, assign) NSInteger                 fileLength;
@property (nonatomic, strong) NSFileHandle              *fileHandle;
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
    
    return [self downloadTask:downloadUrl
                       header:header
                     fileName:fileName
                   targetPath:nil];
}

#pragma mark - getter

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager                                           = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        _manager.requestSerializer                         = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer                        = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = nil; // let AFN accept all content-types .  https://stackoverflow.com/questions/28983213/afnetworking-accept-all-content-types
        _manager.operationQueue.maxConcurrentOperationCount = 5;
    }
    return _manager;
}

- (NSURLSessionDataTask *)sessionDownloadTask {
    if (!_sessionDownloadTask) {
        NSURL *url = [NSURL URLWithString:self.strURL] ;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval = 60;
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
            XTREQLog(@"🌞DownloadTaskID %@ complete : %@ \n\n error.Desc : %@\n\nerror: %@",self.strURL,response,error.localizedDescription, error);
            
            BOOL isComplete;
            if (error) { 
                isComplete = NO;
                self.state = XTReqTaskStateFailed;
            }
            else {
                int statusCode = [[response valueForKey:@"statusCode"] intValue];
                if (statusCode > 400 && statusCode < 599) {
                    isComplete = NO;
                    self.state = XTReqTaskStateFailed;
                    // 出错的时候清空 resumePath的文件. 和 task !
                    [[NSFileManager defaultManager] removeItemAtPath:resumePath error:nil];
                    _sessionDownloadTask = nil;
                } else {
                    isComplete = self.state == XTReqTaskStateSuccessed;
                    if (!isComplete) {
                        isComplete = statusCode == 200 || statusCode == 206 ;
                        if (isComplete && self.state != XTReqTaskStateSuccessed) self.state = XTReqTaskStateSuccessed;
                    }                                        
                }
            }
                        
            if (isComplete) {
                // clear
                self.currentLength = 0;
                self.fileLength = 0;
                // close FileHandle
                if (self.fileHandle != nil) {
                    [self.fileHandle closeFile];
                }
                self.fileHandle = nil;
                self.manager = nil;
            }
                        
            if (self.blkCompletion) self.blkCompletion(self, self.state, isComplete ? nil : error);
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
            if (!self.fileHandle) {
                self.state = XTReqTaskStateFailed;
                return;
            }
            
            // Fatal Exception: NSFileHandleOperationException
            //*** -[NSConcreteFileHandle seekToEndOfFile]: Resource temporarily unavailable
            // __37-[XTDownloadTask sessionDownloadTask]_block_invoke.125
            [self.fileHandle seekToEndOfFile];
            [self.fileHandle writeData:data];
            
            self.currentLength += data.length;
            if ( self.currentLength == self.fileLength ) {
                self.state = XTReqTaskStateSuccessed;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pgs = (1.0 * self.currentLength / self.fileLength);
                
                if (self.blkDownloadPgs) self.blkDownloadPgs(self, self.pgs);
            });
        }];
    }
    return _sessionDownloadTask;
}


#pragma mark - Func

- (void)observeDownloadProgress:(void (^)(XTDownloadTask *task, float progress))progressBlock
             downloadCompletion:(void (^)(XTDownloadTask *task, XTReqTaskState state, NSError *error))completionBlock {
    
    if (progressBlock)   self.blkDownloadPgs = progressBlock;
    if (completionBlock) self.blkCompletion  = completionBlock;
}

- (void)offlineResume {
    if (self.state == XTReqTaskStateSuccessed) {
        XTREQLog(@"id:%@ HAS ALREADY DOWNLOADED !",self.strURL);
        return;
    }
    
    self.state = XTReqTaskStateDoing;
    NSInteger currentLength = [self fileLengthForPath:[self destinationPath]];
    self.currentLength = currentLength;
    
    [self.sessionDownloadTask resume];
    
    XTREQLog(@"downloadTask: %@ RESUME",self.strURL);
}

- (void)offlinePause {
    self.state = XTReqTaskStatePaused;
    [_sessionDownloadTask suspend];
    _sessionDownloadTask = nil; // clear
    
    XTREQLog(@"downloadTask: %@ PAUSE",self.strURL);
}

- (void)invalidTask {
    _sessionDownloadTask = nil;
    _blkCompletion = nil;
    _blkDownloadPgs = nil;
    _manager = nil;
    _fileHandle = nil;
}












#pragma mark --
#pragma mark - Database Config 供外部做数据库持久化, 可不用.

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
             @"currentLength",
             @"curTmpLength",
             @"fileLength",
             @"fileHandle",
             @"downloadSpeed",
             @"blkCompletion",
             @"blkDownloadPgs",
    ];
}

@end
