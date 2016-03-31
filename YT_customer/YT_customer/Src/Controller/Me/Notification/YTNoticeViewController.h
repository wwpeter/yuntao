//
//  YTNoticeViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/12/7.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseViewController.h"

typedef NS_ENUM(NSInteger, YTNoticeViewControllerType) {
    YTNoticeViewControllerTypeSystem = 0,
    YTNoticeViewControllerTypeShop = 1,
};

@class YTXjswHb;

@interface YTNoticeViewController : YTBaseViewController
@property (nonatomic, assign) YTNoticeViewControllerType noticeType;
@property (nonatomic, strong) YTXjswHb *xjswHb;
@end
