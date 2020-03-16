//
//  XTDownloader.h
//  XTReq
//
//  Created by teason23 on 2020/3/15.
//  Copyright © 2020 teaason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTDownloadTask.h"






@interface XTDownloader : NSObject
+ (XTDownloader *)sharedInstance;

/**
 最大下载数
 */
@property(nonatomic, assign) NSInteger maxActiveDownloadCount;

#pragma mark - 相关数组

/**
 正在下载的数组
 */
@property(nonatomic, strong, readonly) NSArray *downloadingArray;

#pragma mark - 下载管理

/**
 添加下载任务

 @param task 下载任务
 @return 是否成功
 */
- (BOOL)addTask:(XTDownloadTask *)task;



/**
 暂停下载任务

 @param task 下载任务
 */
- (void)pauseTask:(XTDownloadTask *)task;

/**
 继续下载任务

 @param task 下载任务
 */
- (void)resumeTask:(XTDownloadTask *)task;

/**
 移除下载任务

 @param task 下载任务
 */
- (void)removeTask:(XTDownloadTask *)task;


- (void)pauseAll;
- (void)resumeAll;



@end
