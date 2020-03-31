//
//  XTUploadTask.h
//  XTReq
//
//  Created by teason23 on 2020/3/30.
//  Copyright © 2020 teaason. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XTUploadTaskState) {
    XTUploadTaskStateFailed   = -1,
    XTUploadTaskStateWaiting  = 0,
    XTUploadTaskStateUploading,
    XTUploadTaskStatePaused,
    XTUploadTaskStateUploaded,
};

NS_ASSUME_NONNULL_BEGIN

@interface XTUploadTask : NSObject

+ (XTUploadTask *)uploadFileWithData:(NSData *)fileData
                              urlStr:(NSString *)urlString
                              header:(NSDictionary *)header
                            progress:(nullable void (^)(float progressVal))progressValueBlock
                             success:(void (^)(NSURLResponse *response, id responseObject))success
                             failure:(void (^)(NSError *error))fail ;

+ (XTUploadTask *)multipartFormDataUploadPath:(NSString *)path
                                       urlStr:(NSString *)urlStr
                                       header:(NSDictionary *)header
                                      bodyDic:(NSDictionary *)body
                                     progress:(nullable void (^)(float progressVal))progressValueBlock
                                      success:(void (^)(NSURLResponse *response, id responseObject))success
                                      failure:(void (^)(NSError *error))fail ;



@property (strong, nonatomic)  NSURLSessionUploadTask   *sessionUploadTask;
@property (nonatomic)          XTUploadTaskState        uploadState;
@property (nonatomic)          BOOL                     isMultipart;

- (void)pause ;
- (void)resume ;

@end

NS_ASSUME_NONNULL_END
