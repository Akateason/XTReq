//
//  ViewController.m
//  XTReq
//
//  Created by teason23 on 2017/5/17.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "ViewController.h"
#import "XTReq.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    int random = arc4random() % 100 ;
    NSString *urlStr = [NSString stringWithFormat:@"https://api.douban.com/v2/book/%@",@(1220562+random)] ;
    
    
    //1
    [XTRequest GETWithUrl:urlStr
               parameters:nil
                  success:^(id json) {
                      NSLog(@"async") ;
                  } fail:^{
                      
                  }] ;
    

    
    
    //3
    [XTCacheRequest cacheGET:urlStr
                  parameters:nil
                  completion:^(id json) {
                      NSLog(@"cache") ;
                  }] ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
