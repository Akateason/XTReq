//
//  XTDownloadTask+Extension.m
//  XTReq
//
//  Created by teason23 on 2020/3/16.
//  Copyright © 2020 teaason. All rights reserved.
//

#import "XTDownloadTask+Extension.h"

@implementation XTDownloadTask (Extension)

#pragma mark - Private Methods

- (NSString *)destinationPath {
    return [self.folderPath stringByAppendingPathComponent:self.filename];
}

+ (NSString *)createDefaultPath {
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *downloadFolder = [documents stringByAppendingPathComponent:@"downloader"];
    [self createDownloadFolderIfNotExist:downloadFolder];
    return downloadFolder;
}

+ (void)createDownloadFolderIfNotExist:(NSString *)folder {
    BOOL isDir = NO;
    BOOL folderExist = [[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir];
    if (!folderExist || !isDir ) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
        NSURL *fileURL = [NSURL fileURLWithPath:folder];
        [fileURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
}

- (NSInteger)fileLengthForPath:(NSString *)path {
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

@end
