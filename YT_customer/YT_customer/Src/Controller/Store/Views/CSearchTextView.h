//
//  CSearchTextView.h
//  YT_customer
//
//  Created by chun.chen on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSearchTextViewDelegate;

@interface CSearchTextView : UIView <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *searchField;
@property (weak, nonatomic) id<CSearchTextViewDelegate> delegate;

@end


@protocol CSearchTextViewDelegate <NSObject>
@optional
- (void)searchTextView:(CSearchTextView *)view textFieldShouldBeginEditing:(UITextField *)textField;
- (void)searchTextView:(CSearchTextView *)view textFieldDidBeginEditing:(UITextField *)textField;
- (void)searchTextView:(CSearchTextView *)view textFieldShouldEndEditing:(UITextField *)textField;
- (void)searchTextView:(CSearchTextView *)view textFieldDidEndEditing:(UITextField *)textField;
- (void)searchTextView:(CSearchTextView *)view shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)searchTextView:(CSearchTextView *)view textFieldShouldClear:(UITextField *)textField;
- (void)searchTextView:(CSearchTextView *)view textFieldShouldReturn:(UITextField *)textField;
@end