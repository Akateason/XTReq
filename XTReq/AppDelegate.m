//
//  AppDelegate.m
//  XTReq
//
//  Created by teason23 on 2017/5/17.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "AppDelegate.h"
#import "XTReq.h"
#import <YYModel.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // config cache req .
    [XTCacheRequest configXTCacheReqWhenAppDidLaunchWithDBName:@"teason"] ;
    
    
    NSDictionary *dic = @{@"app_version":@"1082",
                          @"device_info":@"iPhone7,2",
                          @"imei":@"",
                          @"os_version":@"iOS 11.4",
                          @"channel_code":@"SC000000",
                          @"os_name":@"iOS",
                          @"identifier":@"BBDCB834-09AB-4574-AE31-CF9CD08E1D0F",
                          @"app_name":@"swift.free.phone.call.wifi.chat.ios"} ;

////    Cookie = "auth_token=c1f3bbee-099d-4d6c-82f6-d4d0bcd13ab4";
//    [XTRequest POSTWithUrl:@"https://zh-cn.ime.cootek.com/statistic/active"
//                    header:@{@"Cookie" : @"auth_token=c1f3bbee-099d-4d6c-82f6-d4d0bcd13ab4"}
//                parameters:dic
//                       hud:YES
//                   success:^(id json) {
//
//                   } fail:^{
//
//                   }] ;

    [XTRequest POSTWithUrl:@"https://zh-cn.ime.cootek.com/statistic/active" header:@{@"Cookie" : @"auth_token=c1f3bbee-099d-4d6c-82f6-d4d0bcd13ab4"} parameters:dic rawBody:[dic yy_modelToJSONString] hud:YES success:^(id json) {
        
    } fail:^{
        
    }] ;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
