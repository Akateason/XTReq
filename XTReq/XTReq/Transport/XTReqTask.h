//
//  XTReqTask.h
//  XTReq
//
//  Created by teason23 on 2020/4/1.
//  Copyright © 2020 teaason. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, XTReqTaskState) {
    XTReqTaskStateFailed   = -1,
    XTReqTaskStateWaiting  = 0,
    XTReqTaskStateDoing,
    XTReqTaskStatePaused,
    XTReqTaskStateSuccessed,
};


@interface XTReqTask : NSObject

@property (copy, nonatomic)   NSString         *identifier; //PK
@property (nonatomic)         XTReqTaskState   state;
@property (nonatomic)         float            pgs;
@property (strong, nonatomic) id               userInfo; // anyObject
@property (nonatomic)         int              isCompleted; //bool

@property (copy, nonatomic) NSString *strURL;

@property (copy, nonatomic) NSDictionary *header;
@property (copy, nonatomic) NSString *strHeader;

@property (copy, nonatomic) NSDictionary *param;
@property (copy, nonatomic) NSString *strParam;

@property (copy, nonatomic) NSDictionary *body;
@property (copy, nonatomic) NSString *strBody;

@end







