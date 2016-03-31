//
//  HbMoreFooterView.h
//  YT_customer
//
//  Created by chun.chen on 15/8/2.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MoreFooterViewSelectBlock)(BOOL didDown);

@interface HbMoreFooterView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *arrowImageView;
@property (assign, nonatomic) BOOL didDown;
@property (copy,nonatomic) MoreFooterViewSelectBlock selectBlock;
@end
