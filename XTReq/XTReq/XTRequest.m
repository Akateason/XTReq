//
//  XTRequest
//
//  Created by teason on 15/11/12.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "XTRequest.h"
#import "XTReqSessionManager.h"
#import "SVProgressHUD.h"
#import "YYModel.h"

NSString *const kStringBadNetwork        = @"网络请求失败" ;

#define kFLEX_IN_LOG_TAIL   @"\n🌍🌍🌍🌍 XTReq 🌍🌍🌍🌍"

@implementation XTRequest

#pragma mark --
#pragma mark - Param

+ (NSMutableDictionary *)getParameters { return [@{} mutableCopy] ; }

//  async
#pragma mark --
#pragma mark - Async
#pragma mark - get

+ (NSURLSessionDataTask *)GETWithUrl:(NSString *)url
                          parameters:(NSDictionary *)dict
                             success:(void (^)(id json))success
                                fail:(void (^)())fail {
    return
    [self GETWithUrl:url
              header:nil
          parameters:dict
                 hud:YES
             success:success
                fail:fail] ;
}

+ (NSURLSessionDataTask *)GETWithUrl:(NSString *)url
                              header:(NSDictionary *)header
                          parameters:(NSDictionary *)dict
                                 hud:(BOOL)hud
                             success:(void (^)(id json))success
                                fail:(void (^)())fail {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (hud) [SVProgressHUD show] ;
    
    if (header) {
        for (NSString *key in header) {
            NSString *value = header[key] ;
            [[XTReqSessionManager shareInstance].requestSerializer setValue:value
                                                         forHTTPHeaderField:key] ;
        }
    }
    
    return
    [[XTReqSessionManager shareInstance] GET:url
                                  parameters:dict
                                    progress:nil
                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                         [[XTReqSessionManager shareInstance] reset] ;
                                         if (success) {
                                             if (hud) [SVProgressHUD dismiss] ;
                                             NSLog(@"url : %@ \nparam : %@",url,dict) ;
                                             NSLog(@"resp\n %@ %@",[responseObject yy_modelToJSONString], kFLEX_IN_LOG_TAIL) ;
                                             success(responseObject) ;
                                         }
                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                         NSLog(@"xt_req fail Error:%@ %@", error ,kFLEX_IN_LOG_TAIL) ;
                                         [[XTReqSessionManager shareInstance] reset] ;
                                         if (fail) {
                                             if (hud) [SVProgressHUD showErrorWithStatus:kStringBadNetwork] ;
                                             fail() ;
                                         }
                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                     }] ;
}

#pragma mark - post

+ (NSURLSessionDataTask *)POSTWithUrl:(NSString *)url
                           parameters:(NSDictionary *)dict
                              success:(void (^)(id json))success
                                 fail:(void (^)())fail {
    return
    [self POSTWithUrl:url
               header:nil
           parameters:dict
                  hud:YES
              success:success
                 fail:fail] ;
}

+ (NSURLSessionDataTask *)POSTWithUrl:(NSString *)url
                               header:(NSDictionary *)header
                           parameters:(NSDictionary *)dict
                                  hud:(BOOL)hud
                              success:(void (^)(id json))success
                                 fail:(void (^)())fail {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (hud) [SVProgressHUD show] ;
    
    if (header) {
        for (NSString *key in header) {
            NSString *value = header[key] ;
            [[XTReqSessionManager shareInstance].requestSerializer setValue:value
                                                         forHTTPHeaderField:key] ;
        }
    }
    
    return
    [[XTReqSessionManager shareInstance] POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[XTReqSessionManager shareInstance] reset] ;
        if (success) {
            if (hud) [SVProgressHUD dismiss] ;
            NSLog(@"url : %@ \nparam : %@",url,dict) ;
            NSLog(@"resp\n %@ %@",[responseObject yy_modelToJSONString], kFLEX_IN_LOG_TAIL) ;
            success(responseObject) ;
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"xt_req fail Error:%@ %@", error ,kFLEX_IN_LOG_TAIL) ;
        [[XTReqSessionManager shareInstance] reset] ;
        if (fail) {
            if (hud) [SVProgressHUD showErrorWithStatus:kStringBadNetwork] ;
            fail() ;
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }] ;
}


/**
  body method
 */
+ (NSURLSessionDataTask *)reqWithUrl:(NSString *)url
                                mode:(XTRequestMode)mode
                              header:(NSDictionary *)header
                          parameters:(NSDictionary *)param
                             rawBody:(NSString *)rawBody
                                 hud:(BOOL)hud
                             success:(void (^)(id json))success
                                fail:(void (^)())fail {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (hud) [SVProgressHUD show] ;
    NSString *method = @"" ;
    switch (mode) {
        case XTRequestMode_GET_MODE: method = @"GET" ; break;
        case XTRequestMode_POST_MODE: method = @"POST" ; break;
        case XTRequestMode_PUT_MODE: method = @"PUT" ; break;
        case XTRequestMode_DELETE_MODE: method = @"DELETE" ; break;
        default:
            break;
    }
    // url , param
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method
                                                                                 URLString:url
                                                                                parameters:param
                                                                                     error:nil] ;
    request.timeoutInterval = kTIMEOUT ;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"] ;
    // header
    if (header) {
        for (NSString *key in header) {
            [request setValue:header[key] forHTTPHeaderField:key] ;
        }
    }
    // body
    if (rawBody && rawBody.length > 0) {
        NSData *dataBody = [rawBody dataUsingEncoding:NSUTF8StringEncoding] ;
        [request setHTTPBody:dataBody] ;
    }
    
    NSURLSessionDataTask *task =
    [[XTReqSessionManager shareInstance] dataTaskWithRequest:request
                                              uploadProgress:nil
                                            downloadProgress:nil
                                           completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                               if (hud) [SVProgressHUD dismiss] ;
                                               
                                               NSLog(@"url : %@ \nparam : %@",url,param) ;
                                               NSLog(@"resp\n %@ %@",[responseObject yy_modelToJSONString],kFLEX_IN_LOG_TAIL) ;
                                               [[XTReqSessionManager shareInstance] reset] ;
                                               if (!error) {
                                                   if (success) success(responseObject) ;
                                               }
                                               else {
                                                   NSLog(@"xt_req fail Error: %@ %@",error,kFLEX_IN_LOG_TAIL) ;
                                                   if (fail) fail() ;
                                                   if (hud) [SVProgressHUD showErrorWithStatus:kStringBadNetwork] ;
                                               }
                                               
                                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                               
                                           }]  ;
    [task resume] ;
    return task ;
}

+ (NSURLSessionDataTask *)POSTWithUrl:(NSString *)url
                               header:(NSDictionary *)header
                           parameters:(NSDictionary *)param
                              rawBody:(NSString *)rawBody
                                  hud:(BOOL)hud
                              success:(void (^)(id json))success
                                 fail:(void (^)())fail {
    
    return [self reqWithUrl:url mode:XTRequestMode_POST_MODE header:header parameters:param rawBody:rawBody hud:hud success:success fail:fail] ;
}

#pragma mark - put

+ (NSURLSessionDataTask *)PUTWithUrl:(NSString *)url
                              header:(NSDictionary *)header
                                 hud:(BOOL)hud
                          parameters:(NSDictionary *)dict
                             success:(void (^)(NSURLSessionDataTask * task ,id json))success
                                fail:(void (^)())fail {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (hud) [SVProgressHUD show] ;
    
    if (header) {
        for (NSString *key in header) {
            NSString *value = header[key] ;
            [[XTReqSessionManager shareInstance].requestSerializer setValue:value
                                                         forHTTPHeaderField:key] ;
        }
    }
    
    return
    [[XTReqSessionManager shareInstance] PUT:url
                                  parameters:dict
                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                         [[XTReqSessionManager shareInstance] reset] ;
                                         if (success) {
                                             if (hud) [SVProgressHUD dismiss] ;
                                             NSLog(@"url : %@ \nparam : %@",url,dict) ;
                                             NSLog(@"resp\n %@ %@",[responseObject yy_modelToJSONString],kFLEX_IN_LOG_TAIL) ;
                                             success(task , responseObject) ;
                                         }
                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                     }
                                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                         NSLog(@"xt_req fail Error: %@ %@",error,kFLEX_IN_LOG_TAIL) ;
                                         [[XTReqSessionManager shareInstance] reset] ;
                                         if (fail) {
                                             if (hud) [SVProgressHUD showErrorWithStatus:kStringBadNetwork] ;
                                             fail() ;
                                         }
                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                     }] ;
    
}




+ (void)uploadFileWithData:(NSData *)fileData
                    urlStr:(NSString *)urlString
                    header:(NSDictionary *)header
                  progress:(nullable void (^)(float))progressValueBlock
                  complete:(void (^)(id responseObject))completion {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration] ;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration] ;
    NSURL *URL = [NSURL URLWithString:urlString] ;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL] ;
    
    [request setHTTPMethod:@"POST"] ;
    if (header) {
        for (NSString *key in header) {
            [request setValue:header[key] forHTTPHeaderField:key] ;
        }
    }

    NSURLSessionUploadTask *uploadTask =
    [manager uploadTaskWithRequest:request fromData:fileData progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progressValueBlock) progressValueBlock(uploadProgress.fractionCompleted) ;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"xt upload Error: %@ %@", error, kFLEX_IN_LOG_TAIL) ;
            if (completion) completion(nil) ;
        }
        else {
            NSLog(@"xt upload Success: %@ %@", responseObject,kFLEX_IN_LOG_TAIL) ;
            if (completion) completion(responseObject) ;
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
        
    }] ;
    [uploadTask resume] ;
}

+ (void)downLoadFileWithSavePath:(NSString *)savePath
                   fromUrlString:(NSString *)urlString
                          header:(NSDictionary *)header
                downLoadProgress:(void (^)(float progressVal))progress
                         success:(void (^)(id response, id dataFile))success
                            fail:(void (^)(NSError *error))fail {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] ;
    
    NSURL *url = [NSURL URLWithString:urlString] ;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url] ;
    if (header) {
        for (NSString *key in header.allKeys) {
            NSString *value = header[key] ;
            [request setValue:value forHTTPHeaderField:key] ;
        }
    }
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100) ;
        if (progress) progress(downloadProgress.fractionCompleted) ;
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:savePath] ;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"images download fail error:%@ ",error) ;
            if (fail) fail(error) ;
        }
        else {
            NSLog(@"images download success") ;
            NSLog(@"resp : %@",[response yy_modelToJSONString]) ;
            id file = [NSData dataWithContentsOfFile:savePath] ;
            if (success) success(response, file) ;
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
        
    }] ;
    [downloadTask resume] ;
}


#pragma mark --
#pragma mark - Sync

static inline dispatch_queue_t xt_getCompletionQueue() { return dispatch_queue_create("xt_ForAFnetworkingSync", NULL) ; }

// sync
+ (id)syncWithReqMode:(XTRequestMode)mode
              timeout:(int)timeout
                  url:(NSString *)url
               header:(NSDictionary *)header
           parameters:(NSDictionary *)dict {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    __block id result = nil ;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init] ;
        manager.requestSerializer  = [AFHTTPRequestSerializer serializer] ;
        manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:ACCEPTABLE_CONTENT_TYPES,nil] ;
        manager.requestSerializer.timeoutInterval = timeout ?: kTIMEOUT ;
        manager.completionQueue = xt_getCompletionQueue() ;
        if (header) {
            for (NSString *key in header) {
                [manager.requestSerializer setValue:header[key]
                                 forHTTPHeaderField:key] ;
            }
        }
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0) ;
        switch (mode) {
            case XTRequestMode_GET_MODE:
            {
                [manager GET:url
                  parameters:dict
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"url : %@ \n header : %@\n param : %@ \n resp \n %@  %@",url,header,dict,[responseObject yy_modelToJSONString],kFLEX_IN_LOG_TAIL) ;
                         result = responseObject ;
                         dispatch_semaphore_signal(semaphore) ;
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         dispatch_semaphore_signal(semaphore) ;
                     }] ;
            }
                break ;
            case XTRequestMode_POST_MODE:
            {
                [manager POST:url
                   parameters:dict
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSLog(@"url : %@ \n header : %@\n param : %@ \n resp \n %@  %@",url,header,dict,[responseObject yy_modelToJSONString],kFLEX_IN_LOG_TAIL) ;
                          result = responseObject ;
                          dispatch_semaphore_signal(semaphore) ;
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          dispatch_semaphore_signal(semaphore) ;
                      }] ;
            }
                break ;
            case XTRequestMode_PUT_MODE:
            {
                [manager PUT:url
                  parameters:dict
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"url : %@ \n header : %@\n param : %@ \n resp \n %@  %@",url,header,dict,[responseObject yy_modelToJSONString],kFLEX_IN_LOG_TAIL) ;
                         result = responseObject ;
                         dispatch_semaphore_signal(semaphore) ;
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         dispatch_semaphore_signal(semaphore) ;
                     }] ;
            }
                break ;
        }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ;
    }] ;
    [operation start] ;
    [operation waitUntilFinished] ;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;

    return result ;
}

+ (id)syncWithReqMode:(XTRequestMode)mode
                  url:(NSString *)url
              header:(NSDictionary *)header
          parameters:(NSDictionary *)dict {
    
    return [self syncWithReqMode:mode
                         timeout:kTIMEOUT
                             url:url
                          header:header
                      parameters:dict] ;
}

#pragma mark --
#pragma mark - Cancel

+ (void)cancelAllRequest {
    NSLog(@"xtReq cancel all"kFLEX_IN_LOG_TAIL) ;
    [[XTReqSessionManager shareInstance].session
     getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks,
                                     NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks,
                                     NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        for (NSURLSessionDataTask *task in dataTasks) [task cancel] ;
    }] ;
}

@end
