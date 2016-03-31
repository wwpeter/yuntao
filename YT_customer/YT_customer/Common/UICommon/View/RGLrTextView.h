//
//  RGLrTextView.h
//  YT_customer
//
//  Created by chun.chen on 15/8/2.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGLrTextView : UIView

@property (strong, nonatomic)UILabel *leftLabel;
@property (strong, nonatomic)UILabel *rightLabel;

@property (assign, nonatomic) CGFloat leftMargin;
// defines NO
@property (assign, nonatomic) BOOL displayTopLine;

@property (assign, nonatomic) BOOL hideAllLine;

@end
