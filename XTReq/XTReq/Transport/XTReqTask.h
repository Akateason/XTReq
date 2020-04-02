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

@property (nonatomic)         XTReqTaskState   state;
@property (nonatomic)         float            pgs;
@property (strong, nonatomic) id               userInfo; // anyObject
@property (strong, nonatomic) NSDictionary     *requestInfo;


@end






NS_ASSUME_NONNULL_END
