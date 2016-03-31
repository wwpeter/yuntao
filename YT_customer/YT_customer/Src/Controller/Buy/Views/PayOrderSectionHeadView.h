//
//  PayOrderSectionHeadView.h
//  YT_customer
//
//  Created by chun.chen on 15/8/2.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayOrderSectionHeadView : UIView
@property (strong, nonatomic)UILabel *titleLabel;
@property (assign, nonatomic)NSInteger titleLeftOffset;
@property (assign, nonatomic)BOOL hideBottomLine;
@end
