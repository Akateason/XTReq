//
//  XTUploadSessionManager.m
//  XTReq
//
//  Created by teason23 on 2020/8/26.
//  Copyright © 2020 teaason. All rights reserved.
//

#import "XTUploadSessionManager.h"

@implementation XTUploadSessionManager
static XTUploadSessionManager *_instance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _instance = [[XTUploadSessionManager alloc] initWithSessionConfiguration:config];
        //_instance.operationQueue.maxConcurrentOperationCount = 5; // 已失效
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 5;
        _instance.uploadQueue = queue;
    });
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
