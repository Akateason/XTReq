//
//  XTUploadOperation.h
//  XTReq
//
//  Created by teason23 on 2020/8/26.
//  Copyright © 2020 teaason. All rights reserved.
// 此operation用来控制线程池 最大并发数. [可选]
//XTUploadOperation *operation = [XTUploadOperation operationWithURLSessionTask:task];
//[[XTUploadSessionManager shareInstance].uploadQueue addOperation:operation];

#import <Foundation/Foundation.h>
#import "XTUploadTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface XTUploadOperation : NSOperation
+ (instancetype)operationWithURLSessionTask:(XTUploadTask *)task; // 进入线程池, 自动resume
@end

NS_ASSUME_NONNULL_END
