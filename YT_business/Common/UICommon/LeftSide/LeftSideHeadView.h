//
//  LeftSideHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftSideHeadViewDelegate;

@interface LeftSideHeadView : UIView

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIImageView *arrowImageView;
@property (strong, nonatomic) UILabel *nameLabel;

@property (weak, nonatomic) id<LeftSideHeadViewDelegate> delegate;

@end

@protocol LeftSideHeadViewDelegate <NSObject>
@optional
- (void)leftSideHeadViewDidTap:(LeftSideHeadView *)view;
@end