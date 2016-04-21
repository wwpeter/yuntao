//
//  YTSignTextView.h
//  YT_business
//
//  Created by chun.chen on 16/1/13.
//  Copyright © 2016年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTSignTextView : UIView
@property (nonatomic, strong) UILabel* titleLabel;

@property (nonatomic, strong) UIColor* titleColor;
@property (nonatomic, getter=isDisplayTop) BOOL displayTop;
@property (nonatomic, getter=isDisplayBottom) BOOL displayBottom;
@end
