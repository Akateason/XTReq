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

+ (NSURLSessionDataTask *)POSTWithUrl:(NSString *)url
                               header:(NSDictionary *)header
                           parameters:(NSDictionary *)param
                              rawBody:(NSString *)rawBody
                                  hud:(BOOL)hud
                              success:(void (^)(id json))success
                                 fail:(void (^)())fail {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    if (hud) [SVProgressHUD show] ;
    // url , param
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST"
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

+ (void)uploadImageWithParam:(NSDictionary *)param
                  imageArray:(NSArray *)imageArray
                      urlStr:(NSString *)urlString
                    progress:(nullable void (^)(float))progressValueBlock
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [[XTReqSessionManager shareInstance] POST:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSUInteger i = 0 ;
        for (UIImage * image in imageArray) {
            NSData *imgData = UIImageJPEGRepresentation(image, 1) ;
            [formData appendPartWithFileData:imgData
                                        name:[NSString stringWithFormat:@"picflie%ld",(long)i]
                                    fileName:@"image.png"
                                    mimeType:@" image/jpeg"] ; // filename todo
            i++ ;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        float rProgress = (float)uploadProgress.completedUnitCount / (float)uploadProgress.totalUnitCount ;
        NSLog(@"上传进度 %lf", rProgress) ;
        progressValueBlock(rProgress) ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task,responseObject) ;
            NSLog(@"images upload all success %@",kFLEX_IN_LOG_TAIL) ;
            NSLog(@"resp : %@",[responseObject yy_modelToJSONString]) ;
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error) ;
            NSLog(@"images upload fail %@",kFLEX_IN_LOG_TAIL) ;
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
    }] ;
}

+ (void)downLoadFileWithSavePath:(NSString *)savePath
                   fromUrlString:(NSString *)urlString
                         success:(void (^)(id response))success
                            fail:(void (^)(NSError *error))fail
                downLoadProgress:(void (^)(float))progress {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] ;
    
    NSURL *url = [NSURL URLWithString:urlString] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100) ;
        progress(downloadProgress.fractionCompleted) ;
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:savePath] ;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"images download fail error:%@ %@",error,kFLEX_IN_LOG_TAIL) ;
            fail(error) ;
        }
        else {
            NSLog(@"images download success %@",kFLEX_IN_LOG_TAIL) ;
            NSLog(@"resp : %@",[response yy_modelToJSONString]) ;
            success(response) ;
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
