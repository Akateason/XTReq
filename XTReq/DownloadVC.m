//
//  DownloadVC.m
//  XTReq
//
//  Created by teason23 on 2020/3/15.
//  Copyright © 2020 teaason. All rights reserved.
//

#import "DownloadVC.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Social/Social.h>
#import "XTDownloadTask.h"
#import <XTBase/XTBase.h>
#import "XTReq.h"
#import "XTReqConst.h"

@interface DownloadVC ()
@property (nonatomic, strong) XTDownloadTask *task;

@end

@implementation DownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __block BOOL b = YES;
    @weakify(self)
    [self.task observeDownloadProgress:^(XTDownloadTask *task, float progress) {
        @strongify(self)
        self.lb.text = [NSString stringWithFormat:@"下载中: %.2f%%", progress * 100];
        if (b) {
            USERDEFAULT_SET_VAL(@(task.sessionDownloadTask.countOfBytesExpectedToReceive), @"len");
            b = NO;
        }
    } downloadCompletion:^(XTDownloadTask *task, XTReqTaskState state, NSError *error) {
        XTREQLog(@"%@ , %@", @(state), error.localizedDescription) ;
        if (error) {
            USERDEFAULT_DELTE_VAL(@"len");
        }
    }];
    
    
    [self render];
    
}

- (void)render {
    NSUInteger currentLength = [self.task fileLengthForPath:[self.task destinationPath]];
    NSUInteger finalLength = [USERDEFAULT_GET_VAL(@"len") integerValue];
        
    self.lb.text = XT_STR_FORMAT(@"%@ / %@",
                                 [self.class sizeToString:currentLength],
                                 [self.class sizeToString:finalLength]);
}

- (IBAction)start:(id)sender {
    [self render];
}

- (IBAction)pause:(id)sender {
    [self.task offlinePause];
}

- (IBAction)resume:(id)sender {
    [self.task offlineResume];
}

- (XTDownloadTask *)task {
    if (!_task) {
        //        NSString *url = @"https://uploader.shimo.im/f/aclPulKRX0k3rLxA.docx?download=1";
        _task = [XTDownloadTask downloadTask:@"http://ee-dev.shimowendang.com/uploader/proxy?url=http%3A%2F%2Fminio-service%3A9000%2Fshimo-assets%2Fs4zNhtgZILEzixNi%2F%25E6%2597%25A0%25E6%25A0%2587%25E9%25A2%2598.docx&download=1" header:nil fileName:@"2.doc"];
//        _task = [XTDownloadTask downloadTask:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg" header:nil fileName:@"QQ_V5.4.0.dmg"];
    }
    return _task;
}

+ (NSString *)sizeToString:(NSUInteger)size {
    if (size < 1024.0) {
        return  [NSString stringWithFormat:@"%.2fB",size * 1.0];
    }
    else if (size >= 1024.0 && size < (1024.0 * 1024.0)) {
        return  [NSString stringWithFormat:@"%.2fKB",size / 1024.0];
    }
    else if (size >= (1024.0 * 1024.0) && size < (1024.0 * 1024.0 * 1024.0)) {
        return [NSString stringWithFormat:@"%.2fMB", size / (1024.0 * 1024.0)];
    }
    else {
        return [NSString stringWithFormat:@"%.2fGB", size / (1024.0 * 1024.0 * 1024.0)];
    }
}

@end
