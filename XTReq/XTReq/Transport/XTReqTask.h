//
//  XTReqTask.h
//  XTReq
//
//  Created by teason23 on 2020/4/1.
//  Copyright © 2020 teaason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

// Request Info
@property (copy, nonatomic)   NSString         *strURL;
@property (copy, nonatomic)   NSDictionary     *header;
@property (copy, nonatomic)   NSDictionary     *param;
@property (copy, nonatomic)   NSDictionary     *body;

@end






NS_ASSUME_NONNULL_END
