//
//  XTReqSessionManager.h
//  XTkit
//
//  Created by teason23 on 2017/5/12.
//  Copyright © 2017年 teason. All rights reserved.
//
// Singleton of AFHTTPSessionManager
//

static const float kTIMEOUT = 15.f ;  // Global timeout

#import "AFNetworking.h"

@interface XTReqSessionManager : AFHTTPSessionManager

+ (instancetype)shareInstance ;

// reset manager for reuse next time .
- (void)reset ;


@end
