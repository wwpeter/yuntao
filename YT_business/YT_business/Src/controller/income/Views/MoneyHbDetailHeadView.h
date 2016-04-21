//
//  MoneyHbDetailHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/12/7.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTVipManage;

@interface MoneyHbDetailHeadView : UIView
@property (nonatomic, strong) UIImageView *hbImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mesLabel;

- (void)configHbDetailWithModel:(YTVipManage *)vipManage;
@end
