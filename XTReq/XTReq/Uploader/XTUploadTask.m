//
//  XTUploadTask.m
//  XTReq
//
//  Created by teason23 on 2020/3/30.
//  Copyright © 2020 teaason. All rights reserved.
//

#import "XTUploadTask.h"
#import "XTRequest.h"

@implementation XTUploadTask

+ (XTUploadTask *)uploadFileWithData:(NSData *)fileData
                              urlStr:(NSString *)urlString
                              header:(NSDictionary *)header
                            progress:(nullable void (^)(float progressVal))progressValueBlock
                             success:(void (^)(NSURLResponse *response, id responseObject))success
                             failure:(void (^)(NSError *error))fail {

    XTUploadTask *uTask = [XTUploadTask new];
    uTask.uploadState = XTUploadTaskStateWaiting;
    
    uTask.sessionUploadTask =
    [XTRequest uploadFileWithData:fileData urlStr:urlString header:header progress:progressValueBlock success:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject) {
        
        uTask.uploadState = XTUploadTaskStateUploaded;
        if (success) success(response, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        uTask.uploadState = XTUploadTaskStateFailed;
        if (fail) fail(error);
        
    }];
    
    [uTask resume];
    
    return uTask;
}

+ (XTUploadTask *)multipartFormDataUploadPath:(NSString *)path
                                       urlStr:(NSString *)urlStr
                                       header:(NSDictionary *)header
                                      bodyDic:(NSDictionary *)body
                                     progress:(nullable void (^)(float progressVal))progressValueBlock
                                      success:(void (^)(NSURLResponse *response, id responseObject))success
                                      failure:(void (^)(NSError *error))fail {
    
    XTUploadTask *uTask = [XTUploadTask new];
    uTask.uploadState = XTUploadTaskStateWaiting;
    
    [XTRequest multipartFormDataUploadPath:path urlStr:urlStr header:header bodyDic:body progress:progressValueBlock success:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject) {
        
        uTask.uploadState = XTUploadTaskStateUploaded;
        if (success) success(response, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        uTask.uploadState = XTUploadTaskStateFailed;
        if (fail) fail(error);
        
    }];
    
    [uTask resume];
    
    return uTask;
}


- (void)pause {
    self.uploadState = XTUploadTaskStatePaused;
    [self.sessionUploadTask suspend];
}

- (void)resume {
    self.uploadState = XTUploadTaskStateUploading;
    [self.sessionUploadTask resume];
}

@end
