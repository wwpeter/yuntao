//
//  YTPayTextView.h
//  YT_customer
//
//  Created by chun.chen on 15/6/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YTPayTextViewDelegate;

@interface YTPayTextView : UIView

@property (strong, nonatomic) UIView *textBackView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *textField;

@property (copy, nonatomic) NSString *textTitle;
@property (copy, nonatomic) NSString *textplaceholder;
@property (weak, nonatomic) id<YTPayTextViewDelegate> delegate;

@end

@protocol YTPayTextViewDelegate <NSObject>
@optional
- (BOOL)ytPayTextView:(YTPayTextView *)view textFieldShouldBeginEditing:(UITextField *)textField;
- (void)ytPayTextView:(YTPayTextView *)view textFieldDidBeginEditing:(UITextField *)textField;
- (void)ytPayTextView:(YTPayTextView *)view textFieldWillEndEditing:(UITextField *)textField;
- (void)ytPayTextView:(YTPayTextView *)view textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)ytPayTextView:(YTPayTextView *)view textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)ytPayTextView:(YTPayTextView *)view textFieldDidClear:(UITextField *)textField;
- (void)ytPayTextView:(YTPayTextView *)view textFieldDidReturn:(UITextField *)textField;
@end
