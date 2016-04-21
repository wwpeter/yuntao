//
//  RGLrTextView.h
//  YT_business
//
//  Created by chun.chen on 15/7/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGLrTextView : UIView

@property (strong, nonatomic)UILabel *leftLabel;
@property (strong, nonatomic)UILabel *rightLabel;

@property (assign, nonatomic) CGFloat leftMargin;
// defines NO
@property (assign, nonatomic) BOOL displayTopLine;

@end
