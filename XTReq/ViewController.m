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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ;
    dispatch_async(queue, ^{

        id result = [XTRequest syncGetWithUrl:kURLstr
                                   parameters:nil] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showInfoInAlert:[result yy_modelToJSONString]] ;
        }) ;
        
    }) ;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
