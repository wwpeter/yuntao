//
//  CMyHbDetailViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HbDetailModel;
@interface CMyHbDetailViewController : UIViewController

typedef NS_ENUM(NSInteger, HbDetailType) {
    /**< 店铺红包*/
    HbDetailTypeShopHb,
    /**< 我的红包*/
    HbDetailTypeMyHb
};

@property(strong, nonatomic) NSNumber *hbId;
@property(assign, nonatomic) HbDetailType hbtype;
@property (strong, nonatomic) HbDetailModel *detailModel;
@end
