//
//  LeftSideFootView.h
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LeftSideFootViewDelegate;

@interface LeftSideFootView : UIView

@property (strong, nonatomic)UIButton *leftButton;
@property (strong, nonatomic)UIButton *rightButton;

@property (weak, nonatomic) id<LeftSideFootViewDelegate> delegate;
@end

@protocol LeftSideFootViewDelegate <NSObject>

@optional
- (void)leftSideFootViewDidTap:(UIButton *)tapButton;
@end


