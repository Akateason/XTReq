//
//  XTRequest+RAC.m
//  XTReq
//
//  Created by teason23 on 2020/3/4.
//  Copyright © 2020 teaason. All rights reserved.
//

#import "XTRequest+RAC.h"

@implementation XTRequest (RAC)


/// req wrapped in RAC
//  @return sendNext  RACTuplePack( id json, NSURLResponse *response)
//          sendError NSError
+ (RACSignal *)rac_reqWithUrl:(NSString *)url
                         mode:(XTRequestMode)mode
                       header:(NSDictionary *)header
                   parameters:(NSDictionary *)param
                      rawBody:(NSString *)rawBody
                          hud:(BOOL)hud {
    
    RACSignal *signal =
    [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSURLSessionDataTask *task =
        [self reqWithUrl:url mode:mode header:header parameters:param rawBody:rawBody hud:hud success:^(id json, NSURLResponse *response) {
            [subscriber sendNext:RACTuplePack(json,response)];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    [signal replayLazily];
    return signal;
}

@end
