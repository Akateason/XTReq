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

typedef NS_ENUM(NSUInteger, XTDownloadTaskState) {
    XTDownloadTaskStateFailed   = -1,
    XTDownloadTaskStateWaiting  = 0,
    XTDownloadTaskStateDownloading,
    XTDownloadTaskStatePaused,
    XTDownloadTaskStateDownloaded,
};

@interface XTDownloadTask : NSObject
/**
new
*/
+ (XTDownloadTask *)downloadTask:(NSURL *)downloadUrl
                          header:(NSDictionary *)header
                        fileName:(NSString *)fileName;

+ (XTDownloadTask *)downloadTask:(NSURL *)downloadUrl
                          header:(NSDictionary *)header
                        fileName:(NSString *)fileName
                      targetPath:(NSString *)targetPath;


/**
 info
 */
@property (nonatomic, strong) NSURL      *downloadUrl;
@property (nonatomic, copy)   NSString   *filename;
@property (nonatomic, copy)   NSString   *fileType;
@property (nonatomic, copy)   NSString   *folderPath;


/**
 state
 */
@property(nonatomic)          XTDownloadTaskState downloadState;
@property (nonatomic, strong) NSURLSessionDataTask *sessionDownloadTask;
@property (nonatomic, strong) AFURLSessionManager *manager;
@property (nonatomic, assign) NSInteger fileLength;
@property (nonatomic, assign) NSInteger currentLength;
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


