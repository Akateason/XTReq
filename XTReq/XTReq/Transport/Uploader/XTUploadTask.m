//
//  XTUploadTask.m
//  XTReq
//
//  Created by teason23 on 2020/3/30.
//  Copyright © 2020 teaason. All rights reserved.
//

#import "XTUploadTask.h"
#import "XTRequest.h"
#import <YYModel/YYModel.h>

@implementation XTUploadTask

+ (XTUploadTask *)uploadFileWithData:(NSData *)fileData
                              urlStr:(NSString *)urlString
                              header:(NSDictionary *)header
                            progress:(nullable void (^)(float progressVal))progressValueBlock
                             success:(void (^)(NSURLResponse *response, id responseObject))success
                             failure:(void (^)(NSError *error))fail {

    XTUploadTask *uTask = [XTUploadTask new];
    uTask.isMultipartFormData = NO;
    uTask.state = XTReqTaskStateWaiting;
    uTask.header = header;
    uTask.strURL = urlString;
        
    
    uTask.sessionUploadTask =
    [XTRequest uploadFileWithData:fileData
                           urlStr:urlString
                           header:header
                         progress:^(float progressVal) {

        uTask.pgs = progressVal;
        if (progressValueBlock) progressValueBlock(progressVal);
        
    } success:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject) {
        
        uTask.state = XTReqTaskStateSuccessed;
        if (success) success(response, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        if (uTask.state == XTReqTaskStateCanceled) {
            return ;
        }
        
        uTask.state = XTReqTaskStateFailed;
        if (fail) fail(error);
        
    }];
    
    
    
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
    uTask.state = XTReqTaskStateWaiting;
    uTask.isMultipartFormData = YES;
    uTask.strURL = urlStr;
    uTask.header = header;
    uTask.body = body;        
    
    uTask.sessionUploadTask =
    [XTRequest multipartFormDataUploadPath:path
                                    urlStr:urlStr
                                    header:header
                                   bodyDic:body
                                  progress:^(float progressVal) {
                                      
        uTask.pgs = progressVal;
        if (progressValueBlock) progressValueBlock(progressVal);
        
    }
                                   success:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject) {
        
        uTask.state = XTReqTaskStateSuccessed;
        if (success) success(response, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        if (uTask.state == XTReqTaskStateCanceled) {
            return ;
        }
        
        uTask.state = XTReqTaskStateFailed;
        if (fail) fail(error);
        
    }];
    
    
    
    return uTask;
}


- (void)pause {
    self.state = XTReqTaskStatePaused;
    [self.sessionUploadTask suspend];
}

- (void)resume {
    self.state = XTReqTaskStateDoing;
    [self.sessionUploadTask resume];
}

- (void)cancel {
    self.state = XTReqTaskStateCanceled;
    [self.sessionUploadTask cancel];
}

@end
