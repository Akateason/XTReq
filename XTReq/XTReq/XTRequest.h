//
//  AppDelegate.m
//  XTRequest
//
//  Created by teason on 15/11/12.
//  Copyright © 2015年 teason. All rights reserved.
// XTRequest
// 1. share one manager .
// 2. async and sync .
// 3. Get/Post/Put , fast append HTTP header / formdata / rawbody
// 4. log success or failure
// 5. show hud
// 6. cancel req


#import "XTReqSessionManager.h"
@class NSURLSessionDataTask ;

extern NSString *const kStringBadNetwork ;

// req mode
typedef NS_ENUM(NSInteger, XTRequestMode) {
    XTRequestMode_GET_MODE  ,
    XTRequestMode_POST_MODE ,
    XTRequestMode_PUT_MODE  ,
    XTRequestMode_DELETE_MODE  ,
} ;

// get PARAM
#define XT_GET_PARAM                         NSMutableDictionary *param = [XTRequest getParameters] ;

@interface XTRequest : XTReqSessionManager

// param
+ (NSMutableDictionary *)getParameters ;

#pragma mark - async

// GET
/**
 get url + param
 */
+ (NSURLSessionDataTask *)GETWithUrl:(NSString *)url
                          parameters:(NSDictionary *)dict
                             success:(void (^)(id json))success
                                fail:(void (^)(void))fail ;
/**
 get url + header + param + hud
 */
+ (NSURLSessionDataTask *)GETWithUrl:(NSString *)url
                              header:(NSDictionary *)header
                          parameters:(NSDictionary *)dict
                                 hud:(BOOL)hud
                             success:(void (^)(id json))success
                                fail:(void (^)(void))fail ;

// POST
/**
 post url + param
 */
+ (NSURLSessionDataTask *)POSTWithUrl:(NSString *)url
                           parameters:(NSDictionary *)dict
                              success:(void (^)(id json))success
                                 fail:(void (^)(void))fail ;
/**
 post url + param + header + hud
 */
+ (NSURLSessionDataTask *)POSTWithUrl:(NSString *)url
                               header:(NSDictionary *)header
                           parameters:(NSDictionary *)dict
                                  hud:(BOOL)hud
                              success:(void (^)(id json))success
                                 fail:(void (^)(void))fail ;
/**
 post url + param + header + rawbody + hud
 */
+ (NSURLSessionDataTask *)POSTWithUrl:(NSString *)url
                               header:(NSDictionary *)header
                           parameters:(NSDictionary *)param
                              rawBody:(NSString *)rawBody
                                  hud:(BOOL)hud
                              success:(void (^)(id json))success
                                 fail:(void (^)(void))fail ;

/**
 main body method
 */
+ (NSURLSessionDataTask *)reqWithUrl:(NSString *)url
                                mode:(XTRequestMode)mode
                              header:(NSDictionary *)header
                          parameters:(NSDictionary *)param
                             rawBody:(NSString *)rawBody
                                 hud:(BOOL)hud
                             success:(void (^)(id json))success
                                fail:(void (^)(NSError *error, id response))fail ;

// PUT
/**
 put url + param + header + hud
 */
+ (NSURLSessionDataTask *)PUTWithUrl:(NSString *)url
                              header:(NSDictionary *)header
                                 hud:(BOOL)hud
                          parameters:(NSDictionary *)dict
                             success:(void (^)(NSURLSessionDataTask * task ,id json))success
                                fail:(void (^)(void))fail ;

// UPLOAD one File
+ (void)uploadFileWithData:(NSData *)fileData
                    urlStr:(NSString *)urlString
                    header:(NSDictionary *)header
                  progress:(nullable void (^)(float))progressValueBlock
                  complete:(void (^)(id responseObject))completion ;

// DOWNLOAD one File
+ (void)downLoadFileWithSavePath:(NSString *)savePath
                   fromUrlString:(NSString *)urlString
                          header:(NSDictionary *)header
                downLoadProgress:(void (^)(float progressVal))progress
                         success:(void (^)(id response, id dataFile))success
                            fail:(void (^)(NSError *error))fail ;

#pragma mark - sync

+ (id)syncWithReqMode:(XTRequestMode)mode
              timeout:(int)timeout
                  url:(NSString *)url
               header:(NSDictionary *)header
           parameters:(NSDictionary *)dict ;

+ (id)syncWithReqMode:(XTRequestMode)mode
                  url:(NSString *)url
               header:(NSDictionary *)header
           parameters:(NSDictionary *)dict ;

/**
 cancel all req
 */
+ (void)cancelAllRequest ;

@end





