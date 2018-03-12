//
//  XTCacheRequest.h
//  XTlib
//
//  Created by teason23 on 2017/5/8.
//  Copyright © 2017年 teason. All rights reserved.
// XTCacheRequest
//  1. Persistent save the response of requests .
//  2. three policy for how you save requests .
//  3. can control save or not when server crashed or bug .

#import "XTRequest.h"
#import "XTResponseDBModel.h"

typedef NS_ENUM(NSUInteger, XTReqSaveJudgment) {
    XTReqSaveJudgment_willSave      = 0 ,
    XTReqSaveJudgment_NotSave       = 1 ,
} ;

@interface XTCacheRequest : XTRequest

#pragma mark - config

/**
 config when App is launching .
 
 @param dbName      yourApps DB name
 */
+ (void)configXTCacheReqWhenAppDidLaunchWithDBName:(NSString *)dbName ;


#pragma mark - main req

/**
 XTCacheRequest judgeResult designated MAIN FUNC
 
 @param reqMode         XTRequestMode               get / post mode .
 @param url             string
 @param hud             bool
 @param header          dic                         HTTP header if has .
 @param param           dic                         param if has .
 @param body            str                         post rawbody if has .
 @param cachePolicy     XTReqPolicy                 req policy .
 @param overTimeIfNeed   INT (seconds)               only in XTReqPolicyOverTime mode .
 @param completion      (XTReqSaveJudgment(^)(BOOL isNewest, id json))completion
                PARAM  isNewest          : isCacheOrNewest
                PARAM  json              : respObj
                RETURN XTReqSaveJudgment : judge If Need Cache
 */
+ (void)cachedReq:(XTRequestMode)reqMode
              url:(NSString *)url
              hud:(BOOL)hud
           header:(NSDictionary *)header
            param:(NSDictionary *)param
             body:(NSString *)body
           policy:(XTReqPolicy)cachePolicy
   overTimeIfNeed:(int)overTimeIfNeed
      judgeResult:(XTReqSaveJudgment(^)(BOOL isNewest, id json))completion ;

/**
 XTCacheRequest completion MAIN FUNC
*/
+ (void)cachedReq:(XTRequestMode)reqMode
              url:(NSString *)url
              hud:(BOOL)hud
           header:(NSDictionary *)header
            param:(NSDictionary *)param
             body:(NSString *)body
           policy:(XTReqPolicy)cachePolicy
   overTimeIfNeed:(int)overTimeIfNeed
       completion:(void(^)(BOOL isNewest, id json))completion ;

#pragma mark - get

/**
 cacheGET header + param + completion
 */
+ (void)cacheGET:(NSString *)url
          header:(NSDictionary *)header
      parameters:(NSDictionary *)param
      completion:(void(^)(id json))completion ;
/**
 cacheGET header + param + judgeResult
 */
+ (void)cacheGET:(NSString *)url
          header:(NSDictionary *)header
      parameters:(NSDictionary *)param
     judgeResult:(XTReqSaveJudgment (^)(id json))completion ;
/**
 cacheGET header + param + hud + policy + completion
 */
+ (void)cacheGET:(NSString *)url
          header:(NSDictionary *)header
      parameters:(NSDictionary *)param
             hud:(BOOL)hud
          policy:(XTReqPolicy)cachePolicy
  overTimeIfNeed:(int)overTimeIfNeed
      completion:(void(^)(id json))completion ;
/**
 cacheGET header + param + hud + policy + judgeResult
 */
+ (void)cacheGET:(NSString *)url
          header:(NSDictionary *)header
      parameters:(NSDictionary *)param
             hud:(BOOL)hud
          policy:(XTReqPolicy)cachePolicy
  overTimeIfNeed:(int)overTimeIfNeed
     judgeResult:(XTReqSaveJudgment (^)(id json))completion ;

#pragma mark - post
/**
 cachePOST header + param + completion
 */
+ (void)cachePOST:(NSString *)url
           header:(NSDictionary *)header
       parameters:(NSDictionary *)param
       completion:(void(^)(id json))completion ;
/**
 cachePOST header + param + judgeResult
 */
+ (void)cachePOST:(NSString *)url
           header:(NSDictionary *)header
       parameters:(NSDictionary *)param
      judgeResult:(XTReqSaveJudgment (^)(id json))completion ;
/**
 cachePOST header + param + body + policy + completion
 */
+ (void)cachePOST:(NSString *)url
           header:(NSDictionary *)header
       parameters:(NSDictionary *)param
             body:(NSString *)body
              hud:(BOOL)hud
           policy:(XTReqPolicy)cachePolicy
   overTimeIfNeed:(int)overTimeIfNeed
       completion:(void(^)(id json))completion ;
/**
 cachePOST header + param + body + policy + judgeResult
 */
+ (void)cachePOST:(NSString *)url
           header:(NSDictionary *)header
       parameters:(NSDictionary *)param
             body:(NSString *)body
              hud:(BOOL)hud
           policy:(XTReqPolicy)cachePolicy
   overTimeIfNeed:(int)overTimeIfNeed
      judgeResult:(XTReqSaveJudgment(^)(id json))completion ;

@end









