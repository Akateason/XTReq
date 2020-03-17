//
//  XTDownloader.h
//  XTReq
//
//  Created by teason23 on 2020/3/15.
//  Copyright © 2020 teaason. All rights reserved.
//
// TODO: 未完

#import <Foundation/Foundation.h>
#import "XTDownloadTask.h"


@interface XTDownloader : NSObject

+ (XTDownloader *)sharedInstance;

@property(nonatomic, assign) NSInteger maxActiveDownloadCount;
@property(nonatomic, strong, readonly) NSArray *downloadingArray;



- (BOOL)addTask:(XTDownloadTask *)task;

- (void)pauseTask:(XTDownloadTask *)task;

- (void)resumeTask:(XTDownloadTask *)task;

- (void)removeTask:(XTDownloadTask *)task;

- (void)pauseAll;

- (void)resumeAll;

@end
