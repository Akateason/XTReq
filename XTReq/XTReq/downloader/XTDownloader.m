//
//  XTDownloader.m
//  XTReq
//
//  Created by teason23 on 2020/3/15.
//  Copyright © 2020 teaason. All rights reserved.
//

#import "XTDownloader.h"


@interface XTDownloader ()
@property (nonatomic, strong) NSOperationQueue   *operationQueue;
@property (nonatomic, strong) NSMutableArray     *privateDownloadingArray;
@property (nonatomic, assign) NSInteger          currentActiveTaskCount;
@end

@implementation XTDownloader

#pragma mark - Life Cycle

+ (XTDownloader *)sharedInstance {
    static dispatch_once_t onceToken;
    static XTDownloader *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认同时只能下载一个任务
        _maxActiveDownloadCount = 5;
        // 当前正在下载任务数为0
        _currentActiveTaskCount = 0;
        // 创建操作队列
        _operationQueue = [[NSOperationQueue alloc] init];
        // 创建数组
        _privateDownloadingArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

- (BOOL)addTask:(XTDownloadTask *)task {
    for (XTDownloadTask *tmpTask in self.privateDownloadingArray) {
        if ([tmpTask isEqual:task]) {
            return NO;
        }
    }
    
    task.downloadState = XTDownloadTaskStateWaiting;
    [self.privateDownloadingArray addObject:task];
    
    if (_currentActiveTaskCount < _maxActiveDownloadCount) {
        // 当前并发数小于最大并发数，直接下载
        [self startTask:task];
    }
    
    return YES;
}

- (void)startTask:(XTDownloadTask *)task {
    
}

- (void)pauseTask:(XTDownloadTask *)task {
    [task offlinePause];
}

- (void)resumeTask:(XTDownloadTask *)task {
    [task offlineResume];
}

- (void)removeTask:(XTDownloadTask *)task {
    [task offlinePause];
    [task.sessionDownloadTask cancel];
    task.sessionDownloadTask = nil ;
    task.manager = nil;
    [self.privateDownloadingArray removeObject:task];
}

- (void)pauseAll {
    for (XTDownloadTask *tmpTask in self.privateDownloadingArray) {
        [tmpTask.sessionDownloadTask suspend];
    }
}

- (void)resumeAll {
    
}

@end
