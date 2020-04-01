//
//  XTUploadTask.h
//  XTReq
//
//  Created by teason23 on 2020/3/30.
//  Copyright © 2020 teaason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTReqTask.h"



@interface XTUploadTask : XTReqTask

+ (XTUploadTask *)uploadFileWithData:(NSData *)fileData
                              urlStr:(NSString *)urlString
                              header:(NSDictionary *)header
                            progress:(void (^)(float progressVal))progressValueBlock
                             success:(void (^)(NSURLResponse *response, id responseObject))success
                             failure:(void (^)(NSError *error))fail ;

+ (XTUploadTask *)multipartFormDataUploadPath:(NSString *)path
                                       urlStr:(NSString *)urlStr
                                       header:(NSDictionary *)header
                                      bodyDic:(NSDictionary *)body
                                     progress:(void (^)(float progressVal))progressValueBlock
                                      success:(void (^)(NSURLResponse *response, id responseObject))success
                                      failure:(void (^)(NSError *error))fail ;



@property (strong, nonatomic)  NSURLSessionUploadTask   *sessionUploadTask;
@property (nonatomic)          BOOL                     isMultipart;


- (void)pause ;
- (void)resume ;

@end


