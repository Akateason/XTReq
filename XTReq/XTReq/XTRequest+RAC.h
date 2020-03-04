//
//  XTRequest+RAC.h
//  XTReq
//
//  Created by teason23 on 2020/3/4.
//  Copyright © 2020 teaason. All rights reserved.
//

#import "XTRequest.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface XTRequest (RAC)

/// XTRequest wrapped in RAC
//  @return RACSignal
//           - sendNext  RACTuplePack( id json, NSURLResponse *response)
//           - sendError error
+ (RACSignal *)rac_reqWithUrl:(NSString *)url
                         mode:(XTRequestMode)mode
                       header:(NSDictionary *)header
                   parameters:(NSDictionary *)param
                      rawBody:(NSString *)rawBody
                          hud:(BOOL)hud ;

@end

