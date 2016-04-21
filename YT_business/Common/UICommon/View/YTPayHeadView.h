//
//  YTPayHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/6/11.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTPayHeadView : UIView

@property (assign, nonatomic) YTPayType payType;

// 标题
@property (strong, nonatomic) UILabel *titleLabel;
// 说明
@property (strong, nonatomic) UILabel *messageLabel;
// 价格
@property (strong, nonatomic) UILabel *costLabel;

@end