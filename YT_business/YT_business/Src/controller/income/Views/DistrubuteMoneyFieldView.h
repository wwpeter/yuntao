//
//  DistrubuteMoneyFieldView.h
//  YT_business
//
//  Created by chun.chen on 15/12/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DistrubuteMoneyFieldViewDelegate;

@interface DistrubuteMoneyFieldView : UIView
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* rightLabel;
@property (nonatomic, strong) UITextField* textFiled;

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSAttributedString* titleAttributedString;
@property (nonatomic, copy) NSString* rightText;
@property (nonatomic, copy) NSString* placeholder;
@property (nonatomic, copy) NSString* text;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) BOOL hideTitle;

@property (weak, nonatomic) id<DistrubuteMoneyFieldViewDelegate> delegate;

- (void)addTextTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

@protocol DistrubuteMoneyFieldViewDelegate <NSObject>
@optional
- (BOOL)distrubuteMoneyFieldView:(DistrubuteMoneyFieldView*)view textFieldShouldBeginEditing:(UITextField*)textField;
- (void)distrubuteMoneyFieldView:(DistrubuteMoneyFieldView*)view textFieldDidBeginEditing:(UITextField*)textField;
- (void)distrubuteMoneyFieldView:(DistrubuteMoneyFieldView*)view textFieldWillEndEditing:(UITextField*)textField;
- (void)distrubuteMoneyFieldView:(DistrubuteMoneyFieldView*)view textFieldDidEndEditing:(UITextField*)textField;
- (BOOL)distrubuteMoneyFieldView:(DistrubuteMoneyFieldView*)view textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string;
- (void)distrubuteMoneyFieldView:(DistrubuteMoneyFieldView*)view textFieldDidClear:(UITextField*)textField;
- (void)distrubuteMoneyFieldView:(DistrubuteMoneyFieldView*)view textFieldDidReturn:(UITextField*)textField;

@end
