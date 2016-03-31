//
//  PayNotPreferenceView.h
//  YT_customer
//
//  Created by chun.chen on 15/10/12.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPayTextView.h"
@protocol PayNotPreferenceViewDelegate;

typedef void (^PayNotPreferenceBlock)(BOOL select);

@interface PayNotPreferenceView : UIView <YTPayTextViewDelegate>
@property (nonatomic, strong) UIButton *preButton;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) YTPayTextView *payTextView;
@property (nonatomic, copy) PayNotPreferenceBlock selectBlock;
@property (weak, nonatomic) id<PayNotPreferenceViewDelegate> delegate;
@end

@protocol PayNotPreferenceViewDelegate <NSObject>
@optional
- (BOOL)payNotPreferenceView:(PayNotPreferenceView *)view textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)payNotPreferenceView:(PayNotPreferenceView *)view textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)payNotPreferenceView:(PayNotPreferenceView *)view textFieldDidBeginEditing:(UITextField *)textField;
- (void)payNotPreferenceView:(PayNotPreferenceView *)view textFieldWillEndEditing:(UITextField *)textField;
- (void)payNotPreferenceView:(PayNotPreferenceView *)view textFieldDidEndEditing:(UITextField *)textField;
@end
