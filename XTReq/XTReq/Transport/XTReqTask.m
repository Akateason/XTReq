//
//  XTReqTask.m
//  XTReq
//
//  Created by teason23 on 2020/4/1.
//  Copyright © 2020 teaason. All rights reserved.
//

#import "XTReqTask.h"
#import <YYModel/YYModel.h>

@implementation XTReqTask
@synthesize header = _header, param = _param, body = _body;

- (void)setHeader:(NSDictionary *)header {
    self.strHeader = [header yy_modelToJSONString];
}

- (void)setParam:(NSDictionary *)param {
    self.strParam = [param yy_modelToJSONString];
}

- (void)setBody:(NSDictionary *)body {
    self.strBody = [body yy_modelToJSONString];
}

- (NSDictionary *)header {
    if (!_header) {
        _header = [self.strHeader yy_modelToJSONObject];
    }
    return _header;
}

- (NSDictionary *)param {
    if (!_param) {
        _param = [self.strParam yy_modelToJSONObject];
    }
    return _param;
}

- (NSDictionary *)body {
    if (!_body) {
        _body = [self.strBody yy_modelToJSONObject];
    }
    return _body;
}




@end
