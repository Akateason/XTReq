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
new
*/
+ (XTDownloadTask *)downloadTask:(NSString *)downloadUrl
                          header:(NSDictionary *)header
                        fileName:(NSString *)fileName;

+ (XTDownloadTask *)downloadTask:(NSString *)downloadUrl
                          header:(NSDictionary *)header
                        fileName:(NSString *)fileName
                      targetPath:(NSString *)targetPath;


/**
 info
 */
@property (nonatomic, copy)   NSString   *filename;
@property (nonatomic, copy)   NSString   *fileType;
@property (nonatomic, copy)   NSString   *folderPath;


/**
 state
 */
@property (nonatomic, strong) NSURLSessionDataTask *sessionDownloadTask;
@property (nonatomic, strong) AFURLSessionManager *manager;
@property (nonatomic, assign) NSInteger fileLength;
@property (nonatomic, assign) NSInteger currentLength;
@property (nonatomic, assign) NSInteger curTmpLength;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, assign) CGFloat downloadSpeed; // TODO. speed

/**
 offline download (Resume From Break Points)
*/
- (void)offlineResume ;
- (void)offlinePause ;

/**
 observe progress and completion
*/
- (void)observeDownloadProgress:(void (^)(XTDownloadTask *task, float progress))progressBlock
             downloadCompletion:(void (^)(XTDownloadTask *task, BOOL isComplete))completionBlock;


@end


