//
//  DownloadVC.h
//  XTReq
//
//  Created by teason23 on 2020/3/15.
//  Copyright © 2020 teaason. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btStart;
@property (weak, nonatomic) IBOutlet UIButton *btPause;
@property (weak, nonatomic) IBOutlet UIButton *btResume;
@property (weak, nonatomic) IBOutlet UILabel *lb;

@end

NS_ASSUME_NONNULL_END
