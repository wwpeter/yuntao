//
//  ApplySuccessViewController.h
//  YT_business
//
//  Created by 郑海清 on 15/6/12.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPaySuccessView.h"

@interface ApplySuccessViewController : UIViewController<YTPaySuccessViewDelegate>

@property (strong, nonatomic) YTPaySuccessView *applySuccessView;

@end
