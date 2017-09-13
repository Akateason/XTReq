//
//  ViewController.m
//  XTReq
//
//  Created by teason23 on 2017/5/17.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "ViewController.h"
#import "XTReq.h"
#import "YYModel.h"

@interface ViewController ()

@end

@implementation ViewController

#define kURLstr     [NSString stringWithFormat:@"https://api.douban.com/v2/book/%@",@(1220562)]

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
                 judgeResult:^BOOL(id json) {
                     if (!json) {
                         return YES ; // 数据格式不对! 不缓存!
                     }
                     else {
                         [self showInfoInAlert:[json yy_modelToJSONString]] ;
                         return NO ;
                     }
                 }] ;
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
    // Do any additional setup after loading the view, typically from a nib.
    [XTRequest startMonitor] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
