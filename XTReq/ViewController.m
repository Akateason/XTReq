//
//  ViewController.m
//  XTReq
//
//  Created by teason23 on 2017/5/17.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "ViewController.h"
#import "XTReq.h"
#import <YYModel.h>

@interface ViewController ()

@end

@implementation ViewController

#define kURLstr     [NSString stringWithFormat:@"https://api.douban.com/v2/book/%@",@(1220562)]
#define kURLstr2     [NSString stringWithFormat:@"https://api.douban.com/v2/book/%@",@(1220563)]

- (IBAction)cancelReqAction:(id)sender {
    
    NSURLSessionDataTask *task1 =
    [XTRequest GETWithUrl:kURLstr
                   header:nil
                      hud:YES
               parameters:nil
              taskSuccess:^(NSURLSessionDataTask *task, id json) {
                  
              } fail:^{
                  
              }] ;
    
    [XTCacheRequest cacheGET:<#(NSString *)#>
                  parameters:<#(NSDictionary *)#>
                  completion:<#^(id json)completion#>]
    
    NSURLSessionDataTask *task2 =
    [XTRequest GETWithUrl:kURLstr2
                      hud:YES
               parameters:nil
              taskSuccess:^(NSURLSessionDataTask *task, id json) {
                  
              } fail:^{
                  
              }] ;
    
//    cancel 1
//    [task1 cancel] ;
    
//    cancel all
    [XTRequest cancelAllRequest] ;
}


- (IBAction)asyncAction:(id)sender
{
    [XTRequest GETWithUrl:kURLstr
               parameters:nil
                  success:^(id json) {
                      NSLog(@"async") ;
                      [self showInfoInAlert:[json yy_modelToJSONString]] ;
                  } fail:^{
                      
                  }] ;
}

- (IBAction)syncAction:(id)sender
{
    id result = [XTRequest syncWithReqMode:XTRequestMode_GET_MODE
                                       url:kURLstr
                                    header:nil
                                parameters:nil] ;
    [self showInfoInAlert:[result yy_modelToJSONString]] ;
}

- (IBAction)cachedAction:(id)sender
{
    [XTCacheRequest cacheGET:kURLstr
                  parameters:nil
                  completion:^(id json) {
                     NSLog(@"cache") ;
                     [self showInfoInAlert:[json yy_modelToJSONString]] ;
     }] ;
}

- (IBAction)cacheJudgeResult:(id)sender {
    [XTCacheRequest cacheGET:kURLstr
                  parameters:nil
                 judgeResult:^XTReqSaveJudgment(id json) {
                     if (!json) {
                         return XTReqSaveJudgment_NotSave ; // 数据格式不对! 不缓存!
                     }
                     else {
                         [self showInfoInAlert:[json yy_modelToJSONString]] ;
                         return XTReqSaveJudgment_willSave ;
                     }
                 }] ;
    
    
//    [XTCacheRequest cacheGET:kURLstr
//                      header:nil
//                  parameters:nil
//                         hud:YES
//                      policy:XTResponseCachePolicyTimeout
//               timeoutIfNeed:10 * 60
//                  completion:^(id json) {
//
//                  }] ;
}

- (void)showInfoInAlert:(NSString *)info
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"response"
                                                                     message:info
                                                              preferredStyle:UIAlertControllerStyleAlert] ;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"ok"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil] ;
    [alertVC addAction:action1] ;
    [self presentViewController:alertVC
                       animated:YES
                     completion:nil] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [XTRequest startMonitor] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
