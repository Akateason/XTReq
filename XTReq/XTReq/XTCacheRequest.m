//
//  XTCacheRequest.m
//  XTlib
//
//  Created by teason23 on 2017/5/8.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "XTCacheRequest.h"
#import "XTFMDB.h"
#import "YYModel.h"
#import "NSDate+XTFMDB_Tick.h"
#import "NSString+XTReq_Extend.h"
#import "XTRequest+UrlString.h"

@implementation XTCacheRequest

#pragma mark - config

+ (void)configXTCacheReqWhenAppDidLaunchWithDBPath:(NSString *)dbPath {
    [[XTFMDBBase sharedInstance] configureDBWithPath:dbPath] ;
    [XTResponseDBModel xt_createTable] ;
}

#pragma mark - get

+ (void)cacheGET:(NSString *)url
          header:(NSDictionary *)header
      parameters:(NSDictionary *)param
      completion:(void(^)(id json))completion
{
    [self cacheGET:url
            header:header
        parameters:param
               hud:NO
            policy:XTReqPolicy_NeverCache_WaitReturn
     overTimeIfNeed:0
        completion:completion] ;
}

+ (void)cacheGET:(NSString *)url
          header:(NSDictionary *)header
      parameters:(NSDictionary *)param
     judgeResult:(XTReqSaveJudgment (^)(id json))completion
{
    [self cacheGET:url
            header:header
        parameters:param
               hud:NO
            policy:XTReqPolicy_NeverCache_WaitReturn
     overTimeIfNeed:0
       judgeResult:completion] ;
}

+ (void)cacheGET:(NSString *)url
          header:(NSDictionary *)header
      parameters:(NSDictionary *)param
             hud:(BOOL)hud
          policy:(XTReqPolicy)cachePolicy
   overTimeIfNeed:(int)overTimeIfNeed
      completion:(void(^)(id json))completion
{
    [self cacheGET:url
            header:header
        parameters:param
               hud:hud
            policy:cachePolicy
     overTimeIfNeed:overTimeIfNeed
       judgeResult:^XTReqSaveJudgment(id json) {
           if (completion) completion(json) ;
           return XTReqSaveJudgment_willSave ;
       }] ;
}

+ (void)cacheGET:(NSString *)url
          header:(NSDictionary *)header
      parameters:(NSDictionary *)param
             hud:(BOOL)hud
          policy:(XTReqPolicy)cachePolicy
   overTimeIfNeed:(int)overTimeIfNeed
     judgeResult:(XTReqSaveJudgment (^)(id json))completion
{
    [self cachedReq:XTRequestMode_GET_MODE
                url:url
                hud:hud
             header:header
              param:param
               body:nil
             policy:cachePolicy
      overTimeIfNeed:overTimeIfNeed
        judgeResult:^XTReqSaveJudgment(BOOL isNewest, id json) {
            return completion(json) ;
        }] ;
}

#pragma mark - post

+ (void)cachePOST:(NSString *)url
           header:(NSDictionary *)header
       parameters:(NSDictionary *)param
       completion:(void(^)(id json))completion
{
    [self cachePOST:url
             header:header
         parameters:param
               body:nil
                hud:NO
             policy:XTReqPolicy_NeverCache_WaitReturn
      overTimeIfNeed:0
         completion:completion] ;
}

+ (void)cachePOST:(NSString *)url
           header:(NSDictionary *)header
       parameters:(NSDictionary *)param
      judgeResult:(XTReqSaveJudgment (^)(id json))completion
{
    [self cachePOST:url
             header:header
         parameters:param
               body:nil
                hud:NO
             policy:XTReqPolicy_NeverCache_WaitReturn
      overTimeIfNeed:0
        judgeResult:completion] ;
}

+ (void)cachePOST:(NSString *)url
           header:(NSDictionary *)header
       parameters:(NSDictionary *)param
             body:(NSString *)body
              hud:(BOOL)hud
           policy:(XTReqPolicy)cachePolicy
    overTimeIfNeed:(int)overTimeIfNeed
       completion:(void(^)(id json))completion
{
    [self cachePOST:url
             header:header
         parameters:param
               body:body
                hud:YES
             policy:cachePolicy
      overTimeIfNeed:overTimeIfNeed
        judgeResult:^XTReqSaveJudgment(id json) {
            if (completion) completion(json) ;
            return XTReqSaveJudgment_willSave ;
         }] ;
}

+ (void)cachePOST:(NSString *)url
           header:(NSDictionary *)header
       parameters:(NSDictionary *)param
             body:(NSString *)body
              hud:(BOOL)hud
           policy:(XTReqPolicy)cachePolicy
    overTimeIfNeed:(int)overTimeIfNeed
      judgeResult:(XTReqSaveJudgment(^)(id json))completion
{
    [self cachedReq:XTRequestMode_POST_MODE
                url:url
                hud:hud
             header:header
              param:param
               body:body
             policy:cachePolicy
      overTimeIfNeed:overTimeIfNeed
        judgeResult:^XTReqSaveJudgment(BOOL isNewest, id json) {
            return completion(json) ;
        }] ;
}

#pragma mark - main

+ (void)cachedReq:(XTRequestMode)reqMode
              url:(NSString *)url
              hud:(BOOL)hud
           header:(NSDictionary *)header
            param:(NSDictionary *)param
             body:(NSString *)body
           policy:(XTReqPolicy)cachePolicy
    overTimeIfNeed:(int)overTimeIfNeed
      judgeResult:(XTReqSaveJudgment(^)(BOOL isNewest, id json))completion
{
    NSString *strUniqueKey = [self getUniqueKeyWithUrl:url
                                                header:header
                                                 param:param
                                                  body:body] ;
    
    XTResponseDBModel *resModel = [XTResponseDBModel xt_findFirstWhere:[NSString stringWithFormat:@"requestUrl == '%@'",strUniqueKey]] ;
    
    if (!resModel) {
        // never ever cached
        resModel = [XTResponseDBModel newDefaultModelWithKey:strUniqueKey
                                                         val:nil                         // response is nil
                                                      policy:cachePolicy
                                                    overTime:overTimeIfNeed] ;
        
        [self updateRequestWithType:reqMode
                                url:url
                                hud:hud
                             header:header
                              param:param
                               body:body
                      responseModel:resModel
                         completion:^XTReqSaveJudgment (id json) {
                             if (completion) return completion(YES, json) ; // return newest result .
                             return XTReqSaveJudgment_willSave ;
                         }] ;
    }
    else {
        // has cache
        resModel.cachePolicy = cachePolicy ;
        // completion return cache first .
        if (cachePolicy & XTResponseReturnPolicyImmediatelyReturnThenUpdate && completion) completion(NO, [self.class getJsonWithStr:resModel.response]) ;
        
        if ( cachePolicy & XTResponseCachePolicyNeverUseCache ) {
            //NeverUseCache everytime new req return .
            [self updateRequestWithType:reqMode
                                    url:url
                                    hud:hud
                                 header:header
                                  param:param
                                   body:body
                          responseModel:resModel
                             completion:^XTReqSaveJudgment (id json) {
                                 if ( completion) return completion(YES, json) ; // return newest result once or again.
                                 return XTReqSaveJudgment_willSave ;
                             }] ;
        }
        else if ( cachePolicy & XTResponseCachePolicyAlwaysCache ) {
            // always return cache
            if (cachePolicy & XTResponseReturnPolicyWaitUtilReqDone && completion)
                completion(NO,[self.class getJsonWithStr:resModel.response]) ;
        }
        else if ( cachePolicy & XTResponseCachePolicyOverTime ) {
            // overTime or not ? . needs set overTime
            if ([resModel isOverTime]) {
                // timeout . update request
                [self updateRequestWithType:reqMode
                                        url:url
                                        hud:hud
                                     header:header
                                      param:param
                                       body:body
                              responseModel:resModel
                                 completion:^XTReqSaveJudgment (id json) {
                                     if (completion) return completion(YES, json) ; // return newest result once or again.
                                     return XTReqSaveJudgment_willSave ;
                                 }] ;
            }
            else {
                // return cache
                if (cachePolicy & XTResponseReturnPolicyWaitUtilReqDone && completion)
                    completion(NO,[self.class getJsonWithStr:resModel.response]) ;
            }
        }
    }
}

+ (void)cachedReq:(XTRequestMode)reqMode
              url:(NSString *)url
              hud:(BOOL)hud
           header:(NSDictionary *)header
            param:(NSDictionary *)param
             body:(NSString *)body
           policy:(XTReqPolicy)cachePolicy
    overTimeIfNeed:(int)overTimeIfNeed
       completion:(void(^)(BOOL isNewest, id json))completion
{
    [self cachedReq:reqMode
                url:url
                hud:hud
             header:header
              param:param
               body:body
             policy:cachePolicy
      overTimeIfNeed:overTimeIfNeed
        judgeResult:^XTReqSaveJudgment(BOOL isNewest, id json) {
            if (completion) completion(isNewest, json) ;
            return XTReqSaveJudgment_willSave ;
        }] ;
}

#pragma mark - private

+ (void)updateRequestWithType:(XTRequestMode)requestType
                          url:(NSString *)url
                          hud:(BOOL)hud
                       header:(NSDictionary *)header
                        param:(NSDictionary *)param
                         body:(NSString *)body
                responseModel:(XTResponseDBModel *)resModel
                   completion:(XTReqSaveJudgment(^)(id json))completion
{
    if (requestType == XTRequestMode_GET_MODE) {
        [self GETWithUrl:url
                  header:header
              parameters:param
                     hud:hud
                 success:^(id json) {
                 
                 XTReqSaveJudgment flag = -1 ;
                 if (completion) flag = completion(json) ; // return .
                 // 请求为空 . 不做更新
                 if (!json) return ;
                 // 外部禁止了缓存
                 if (flag == XTReqSaveJudgment_NotSave) return ;
                 // db
                 if (!resModel.response) {
                     resModel.response = [json yy_modelToJSONString] ;
                     [resModel xt_insert] ; // db insert
                 }
                 else {
                     resModel.response = [json yy_modelToJSONString] ;
                     resModel.xt_updateTime = [NSDate xt_getNowTick] ;
                     [resModel xt_update] ; // db update
                 }
             }
                    fail:^{
                        if (completion) completion([self.class getJsonWithStr:resModel.response]) ;
                    }] ;
    }
    else if (requestType == XTRequestMode_POST_MODE) {
        [self POSTWithUrl:url
                   header:header
               parameters:param
                  rawBody:body
                      hud:hud
                  success:^(id json) {
                  
                  XTReqSaveJudgment flag = -1 ;
                  if (completion) flag = completion(json) ; // return .
                  // 请求为空 . 不做更新
                  if (!json) return ;
                  // 外部禁止了缓存
                  if (flag == XTReqSaveJudgment_NotSave) return ;
                  // db
                  if (!resModel.response) {
                      resModel.response = [json yy_modelToJSONString] ;
                      [resModel xt_insert] ; // db insert
                  }
                  else {
                      resModel.response = [json yy_modelToJSONString] ;                      
                      [resModel xt_update] ; // db update
                  }
              }
                     fail:^{
                         if (completion) completion([self.class getJsonWithStr:resModel.response]) ;
              }] ;
    }
}

+ (id)getJsonWithStr:(NSString *)jsonStr {
    if (!jsonStr) return nil ;
    NSError *error ;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                 options:0
                                                   error:&error] ;
    if (!jsonObj) {
        NSLog(@"xtreq json error : %@",error) ;
        return nil ;
    }
    else
        return jsonObj ;
}

@end






