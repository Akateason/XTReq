//
//  XTDownloadOperation.h
//  XTReq
//
//  Created by teason23 on 2020/8/27.
//  Copyright © 2020 teaason. All rights reserved.
// 此operation用来控制线程池 最大并发数

#import <Foundation/Foundation.h>
#import "XTDownloadTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface XTDownloadOperation : NSOperation
+ (instancetype)operationWithURLSessionTask:(XTDownloadTask *)task; // 进入线程池, 自动resume
@end

NS_ASSUME_NONNULL_END
