//
//  XTUploadSessionManager.h
//  XTReq
//
//  Created by teason23 on 2020/8/26.
//  Copyright © 2020 teaason. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface XTUploadSessionManager : AFURLSessionManager
+ (instancetype)shareInstance;

@property (strong, nonatomic) NSOperationQueue *uploadQueue;
@end

NS_ASSUME_NONNULL_END
