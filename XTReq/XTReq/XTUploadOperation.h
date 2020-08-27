//
//  XTUploadOperation.h
//  XTReq
//
//  Created by teason23 on 2020/8/26.
//  Copyright © 2020 teaason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XTUploadOperation : NSOperation
+ (instancetype)operationWithURLSessionTask:(NSURLSessionTask*)task;
@end

NS_ASSUME_NONNULL_END
