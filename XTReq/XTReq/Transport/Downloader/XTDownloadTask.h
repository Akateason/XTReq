//
//  XTDownloadTask.h
//  XTReq
//  Download Class : Resume From Break Points
//
//  Created by teason23 on 2020/3/15.
//  Copyright © 2020 teaason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "XTReqTask.h"



@interface XTDownloadTask : XTReqTask
/**
 info
 */
@property (nonatomic, copy)   NSString   *filename;
@property (nonatomic, copy)   NSString   *fileType;
@property (nonatomic, copy)   NSString   *folderPath;
@property (nonatomic, assign) NSInteger  finalLength; // 外部存取
@property (nonatomic, assign) CGFloat    downloadSpeed; // TODO:

/**
 task
 */
@property (nonatomic, strong) NSURLSessionDataTask *sessionDownloadTask;




/**
New a Download Task
*/
+ (XTDownloadTask *)downloadTask:(NSString *)downloadUrl
                          header:(NSDictionary *)header
                        fileName:(NSString *)fileName;

+ (XTDownloadTask *)downloadTask:(NSString *)downloadUrl
                          header:(NSDictionary *)header
                        fileName:(NSString *)fileName
                      targetPath:(NSString *)targetPath;

/**
 Offline download (Resume From Break Points)
*/
- (void)offlineResume;
- (void)offlinePause;

/**
 Callback progress and completion
*/
- (void)observeDownloadProgress:(void (^)(XTDownloadTask *task, float progress))progressBlock
             downloadCompletion:(void (^)(XTDownloadTask *task, XTReqTaskState state, NSError *error))completionBlock;


/// invalid
- (void)invalidTask;
@end


