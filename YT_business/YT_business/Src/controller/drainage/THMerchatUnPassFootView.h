//
//  THMerchatUnPassFootView.h
//  YT_counterman
//
//  Created by chun.chen on 15/6/21.
//  Copyright (c) 2015年 杭州赛融网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol THMerchatUnPassFootViewDelegate;
@interface THMerchatUnPassFootView : UIView

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *submitButton;
@property (nonatomic, weak) id<THMerchatUnPassFootViewDelegate> delegate;
@end


@protocol THMerchatUnPassFootViewDelegate <NSObject>
@optional
- (void)merchatUnPassFootViewDidSubmit:(THMerchatUnPassFootView *)view;
- (void)merchatUnPassFootView:(THMerchatUnPassFootView *)view textViewShouldBeginEditing:(UITextView *)textView;
- (void)merchatUnPassFootView:(THMerchatUnPassFootView *)view textViewShouldEndEditing:(UITextView *)textView;
@end