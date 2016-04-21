//
//  HbDetailViewController.h
//  YT_business
//
//  Created by chun.chen on 15/6/8.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"

typedef NS_ENUM(NSInteger, HbDetailViewControllerMode) {
    /**< 查看自己*/
    HbDetailViewModeStore,
    /**< 查看他人*/
    HbDetailViewModeVisitor
};

@class YTDrainageDetail;
@interface HbDetailViewController : YTBaseViewController

@property (nonatomic, strong) YTDrainageDetail* drainageDetail;
@property (nonatomic, copy) NSString* hbId;
@property (nonatomic, assign) HbDetailViewControllerMode controllerMode;

@end
