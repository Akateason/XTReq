//
//  DownloadVC.m
//  XTReq
//
//  Created by teason23 on 2020/3/15.
//  Copyright © 2020 teaason. All rights reserved.
//

#import "DownloadVC.h"
#import "XTDownloader.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface DownloadVC ()
@property (nonatomic, strong) XTDownloadTask *task;

@end

@implementation DownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @weakify(self)
    [self.task observeDownloadProgress:^(XTDownloadTask *task, float progress) {
        @strongify(self)
        self.lb.text = [NSString stringWithFormat:@"下载中: %.2f%%", progress * 100];
    } downloadCompletion:^(XTDownloadTask *task, BOOL isComplete) {
        NSLog(@"%@", isComplete?@"成功":@"失败");
    }];
}

- (IBAction)start:(id)sender {
    
}

- (IBAction)pause:(id)sender {
    [[XTDownloader sharedInstance] pauseTask:self.task];
}

- (IBAction)resume:(id)sender {
    [[XTDownloader sharedInstance] resumeTask:self.task];
}

- (XTDownloadTask *)task {
    if (!_task) {
        _task = [XTDownloadTask downloadTask:[NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"]];
    }
    return _task;
}

@end
