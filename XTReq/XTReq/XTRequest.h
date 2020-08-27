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
@class NSURLSessionDataTask;

// req mode
typedef NS_ENUM(NSInteger, XTRequestMode) {
    XTRequestMode_GET_MODE,
    XTRequestMode_POST_MODE,
    XTRequestMode_PUT_MODE,
    XTRequestMode_DELETE_MODE,
    XTRequestMode_PATCH_MODE,
};

// get PARAM
#define XT_GET_PARAM NSMutableDictionary *param = [XTRequest getParameters];

NS_ASSUME_NONNULL_BEGIN

@interface XTRequest : XTReqSessionManager
+ (NSMutableDictionary *)getParameters;
+ (void)cancelAllRequest;

#pragma mark - async
+ (NSURLSessionDataTask *)reqWithUrl:(NSString *)url
                                mode:(XTRequestMode)mode
                              header:(NSDictionary *_Nullable)header
                          parameters:(NSDictionary *_Nullable)param
                             rawBody:(NSString *_Nullable)rawBody
                                 hud:(BOOL)hud
                   completionHandler:(void (^_Nullable)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

+ (NSURLSessionDataTask *)reqWithUrl:(NSString *)url
                                mode:(XTRequestMode)mode
                              header:(NSDictionary *_Nullable)header
                          parameters:(NSDictionary *_Nullable)param
                             rawBody:(NSString *_Nullable)rawBody
                                 hud:(BOOL)hud
                             success:(void (^_Nullable)(id json, NSURLResponse *response))success
                             failure:(void (^_Nullable)(NSURLSessionDataTask *task, NSError *error))fail;

#pragma mark - sync
+ (id)syncWithReqMode:(XTRequestMode)mode
              timeout:(int)timeout
                  url:(NSString *_Nullable)url
               header:(NSDictionary *_Nullable)header
           parameters:(NSDictionary *_Nullable)dict;

+ (id)syncWithReqMode:(XTRequestMode)mode
                  url:(NSString *_Nullable)url
               header:(NSDictionary *_Nullable)header
           parameters:(NSDictionary *_Nullable)dict;

#pragma mark - upload download
// UPLOAD one File
+ (NSURLSessionUploadTask *)uploadFileWithData:(NSData *)fileData
                                        urlStr:(NSString *)urlString
                                        header:(NSDictionary *_Nullable)header
                                      progress:(void (^_Nullable)(float progressVal))progressValueBlock
                                       success:(void (^)(NSURLResponse *response, id responseObject))success
                                       failure:(void (^_Nullable)(NSURLSessionDataTask *task, NSError *error))fail;

// Creating an Upload Task for a Multi-Part Request
+ (NSURLSessionUploadTask *)multipartFormDataUploadPath:(NSString *)path
                                                 urlStr:(NSString *)urlStr
                                                 header:(NSDictionary *_Nullable)header
                                                bodyDic:(NSDictionary *_Nullable)body
                                               progress:(void (^_Nullable)(float progressVal))progressValueBlock
                                                success:(void (^)(NSURLResponse *response, id responseObject))success
                                                failure:(void (^_Nullable)(NSURLSessionDataTask *task, NSError *error))fail ;
    
    
// DOWNLOAD one File
+ (NSURLSessionDownloadTask *)downLoadFileWithSavePath:(NSString *)savePath
                                         fromUrlString:(NSString *)urlString
                                                header:(NSDictionary *_Nullable)header
                                            autoResume:(BOOL)autoResume
                                      downLoadProgress:(void (^_Nullable)(float progressVal))progress
                                               success:(void (^)(NSURLResponse *response, id dataFile))success
                                               failure:(void (^_Nullable)(NSURLSessionDownloadTask *task, NSError *error))fail;

@end


NS_ASSUME_NONNULL_END
