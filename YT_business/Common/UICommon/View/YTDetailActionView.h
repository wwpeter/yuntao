//
//  YTDetailActionView.h
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTDetailActionView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;

// default is YES
@property (assign, nonatomic) BOOL displayArrow;
@property (assign, nonatomic) CGFloat bottomLeftMargin;

@property (strong, nonatomic) dispatch_block_t actionBlock;

- (void)displayTopLine:(BOOL)topShow bottomLine:(BOOL)bottomShow;

//
@end
