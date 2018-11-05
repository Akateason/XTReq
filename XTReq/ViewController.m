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


@interface ViewController ()

@end


@implementation ViewController

#define kURLstr [NSString stringWithFormat:@"https://api.douban.com/v2/book/%@", @(1220562)]
#define kURLstr2 [NSString stringWithFormat:@"https://api.douban.com/v2/book/%@", @(1220563)]

- (IBAction)cancelReqAction:(id)sender {
    NSURLSessionDataTask *task1 =
        [XTRequest reqWithUrl:kURLstr mode:XTRequestMode_GET_MODE header:nil parameters:nil rawBody:nil hud:NO success:^(id json, NSURLResponse *response) {

        } fail:^(NSError *error){

        }];


    NSURLSessionDataTask *task2 =
        [XTRequest reqWithUrl:kURLstr2 mode:XTRequestMode_GET_MODE header:nil parameters:nil rawBody:nil hud:NO success:^(id json, NSURLResponse *response) {

        } fail:^(NSError *error){

        }];

    //    cancel 1
    //    [task1 cancel] ;

    //    cancel all
    [XTRequest cancelAllRequest];
}


- (IBAction)asyncAction:(id)sender {
    [XTRequest reqWithUrl:kURLstr mode:XTRequestMode_GET_MODE header:nil parameters:nil rawBody:nil hud:NO success:^(id json, NSURLResponse *response) {

        [self showInfoInAlert:[json yy_modelToJSONString]];

    } fail:^(NSError *error){

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

- (void)viewDidLoad {
    [super viewDidLoad];

    [XTRequest startMonitor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
