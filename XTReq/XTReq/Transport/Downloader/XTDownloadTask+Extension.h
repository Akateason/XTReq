//
//  XTDownloadTask+Extension.h
//  XTReq
//
//  Created by teason23 on 2020/3/16.
//  Copyright © 2020 teaason. All rights reserved.
//




#import "XTDownloadTask.h"



@interface XTDownloadTask (Extension)

- (NSString *)destinationPath ;

+ (NSString *)createDefaultPath ;

+ (void)createDownloadFolderIfNotExist:(NSString *)folder ;

- (NSInteger)fileLengthForPath:(NSString *)path ;

@end


