//
//  OrderRefundTextFieldView.h
//  YT_business
//
//  Created by chun.chen on 16/1/13.
//  Copyright © 2016年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderRefundFieldViewDelegate;

@interface OrderRefundTextFieldView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, copy) NSString* placeholder;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic, weak) id<OrderRefundFieldViewDelegate> delegate;
@end

@protocol OrderRefundFieldViewDelegate <NSObject>
@optional
- (void)orderRefundTextFieldView:(OrderRefundTextFieldView*)fieldView textFieldShouldBeginEditing:(UITextField*)textField;
- (void)orderRefundTextFieldView:(OrderRefundTextFieldView*)fieldView textFieldDidBeginEditing:(UITextField*)textField;
- (void)orderRefundTextFieldView:(OrderRefundTextFieldView*)fieldView textFieldDidEndEditing:(UITextField*)textField;
- (void)orderRefundTextFieldView:(OrderRefundTextFieldView*)fieldView textFieldShouldReturn:(UITextField*)textField;

@end
