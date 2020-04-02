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
    } downloadCompletion:^(XTDownloadTask *task, XTReqTaskState state) {
        NSLog(@"%@", @(state)) ;
    }];
}

- (IBAction)start:(id)sender {
    NSString *shareText = @"分享的标题";
    NSURL *shareUrl = [NSURL URLWithString:@"https://baidu.com"];
    NSArray *activityItemsArray = @[shareText,shareUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItemsArray applicationActivities:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable   activityType,
                                            BOOL completed,
                                            NSArray * _Nullable returnedItems,
                                            NSError * _Nullable activityError) {

        NSLog(@"activityType: %@,\n completed: %d,\n returnedItems:%@,\n activityError:%@",activityType,completed,returnedItems,activityError);
        
    };

    [self presentViewController:activityVC animated:YES completion:nil];
    
    

    
    
}

- (IBAction)pause:(id)sender {
    [self.task offlinePause];
}

- (IBAction)resume:(id)sender {
    [self.task offlineResume];
}

- (XTDownloadTask *)task {
    if (!_task) {
        _task = [XTDownloadTask downloadTask:[NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"] header:nil fileName:@"QQ_V5.4.0.dmg"];
    }
    return _task;
}

@end
