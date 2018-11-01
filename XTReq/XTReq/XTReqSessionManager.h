//
//  XTReqSessionManager.h
//  XTlib
//
//  Created by teason23 on 2017/5/12.
//  Copyright © 2017年 teason. All rights reserved.
//
// Singleton of AFHTTPSessionManager
//

// Global contentTypes
#define ACCEPTABLE_CONTENT_TYPES                    @"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain"
#define XTReq_isDebug                               [XTReqSessionManager shareInstance].isDebug

// Global timeout
static const float kTIMEOUT = 15.f ;

@import AFNetworking ;

@interface XTReqSessionManager : AFHTTPSessionManager

+ (instancetype)shareInstance ;

@property (nonatomic) BOOL isDebug ;

// clear session Mannager responseSerializer.acceptableContentTypes and http headers
- (void)reset ;

@end
