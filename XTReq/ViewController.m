//
//  ViewController.m
//  XTReq
//
//  Created by teason23 on 2017/5/17.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "ViewController.h"
#import "XTReq.h"
#import <YYModel/YYModel.h>
#import <SVProgressHUD/SVProgressHUD.h>



@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btDownload;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@end


@implementation ViewController

#define kURLstr [NSString stringWithFormat:@"https://api.douban.com/v2/book/%@", @(1220562)]
#define kURLstr2 [NSString stringWithFormat:@"https://api.douban.com/v2/book/%@", @(1220563)]

- (IBAction)cancelReqAction:(id)sender {
    NSURLSessionDataTask *task1 =
        [XTRequest reqWithUrl:kURLstr mode:XTRequestMode_GET_MODE header:nil parameters:nil rawBody:nil hud:NO completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){

        }];


    NSURLSessionDataTask *task2 =
        [XTRequest reqWithUrl:kURLstr2 mode:XTRequestMode_GET_MODE header:nil parameters:nil rawBody:nil hud:NO completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){

        }];

    //    cancel 1
    //    [task1 cancel] ;

    //    cancel all
    [XTRequest cancelAllRequest];
}


- (IBAction)asyncAction:(id)sender {
    [XTRequest reqWithUrl:kURLstr mode:XTRequestMode_GET_MODE header:nil parameters:nil rawBody:nil hud:NO completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

        [self showInfoInAlert:[responseObject yy_modelToJSONString]];
    }];
}

- (IBAction)syncAction:(id)sender {
    id result = [XTRequest syncWithReqMode:XTRequestMode_GET_MODE timeout:0 url:kURLstr header:nil parameters:nil];
    [self showInfoInAlert:[result yy_modelToJSONString]];
}

- (IBAction)cachedAction:(id)sender {
    [XTCacheRequest cachedReq:XTRequestMode_GET_MODE
                          url:kURLstr
                          hud:YES
                       header:nil
                        param:nil
                         body:nil
                       policy:XTReqPolicy_NeverCache_IRTU
               overTimeIfNeed:0
                  judgeResult:^XTReqSaveJudgment(BOOL isNewest, id json) {

                      [self showInfoInAlert:[json yy_modelToJSONString]];
                      return XTReqSaveJudgment_willSave;
                  }];
}

- (IBAction)cacheJudgeResult:(id)sender {
    [XTCacheRequest cachedReq:XTRequestMode_GET_MODE
                          url:kURLstr2
                          hud:YES
                       header:nil
                        param:nil
                         body:nil
                       policy:XTReqPolicy_NeverCache_WaitReturn
               overTimeIfNeed:0
                  judgeResult:^XTReqSaveJudgment(BOOL isNewest, id json) {

                      if (!json) {
                          return XTReqSaveJudgment_NotSave; // 数据格式不对! 不缓存!
                      }
                      else {
                          [self showInfoInAlert:[json yy_modelToJSONString]];
                          return XTReqSaveJudgment_willSave;
                      }
                  }];
}

- (void)showInfoInAlert:(NSString *)info {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"response"
                                                                     message:info
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"ok"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    [alertVC addAction:action1];
    [self presentViewController:alertVC
                       animated:YES
                     completion:nil];
}


- (IBAction)downloadAction:(UIButton *)bt {
    bt.selected = !bt.selected;
    
    if (!bt.selected) {
        [self.task suspend];
        self.task = nil; // 有问题 , 要做断点
    } else {
        [self.task resume];
    }
}








- (void)viewDidLoad {
    [super viewDidLoad];

    [XTRequest startMonitor];
    
    RAC(self.btDownload, backgroundColor) =
    [RACObserve(self.btDownload, selected) map:^UIColor * _Nullable(id  _Nullable value) {
        return ![value intValue] ? [UIColor greenColor] : [UIColor redColor];
    }];
    
    

    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSURLSessionDownloadTask *)task {
    if (!_task) {
        NSString *url = @"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg";
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingString:@"/a.dmg"];
        
        _task =
        [XTRequest downLoadFileWithSavePath:path
                              fromUrlString:url
                                     header:nil
                                 autoResume:NO
                           downLoadProgress:^(float progressVal) {
            
            [self.btDownload setTitle:[NSString stringWithFormat:@"%@%%",@(progressVal*100)] forState:0];
            
        }
                                     success:^(NSURLResponse * _Nonnull response, id  _Nonnull dataFile) {
                        
            [SVProgressHUD showSuccessWithStatus:@"下载成功"];
            
        } failure:^(NSURLSessionDownloadTask * _Nonnull task, NSError * _Nonnull error) {
            
            [SVProgressHUD showErrorWithStatus:error.description];
            
        }];
    }
    return _task;
}



@end
