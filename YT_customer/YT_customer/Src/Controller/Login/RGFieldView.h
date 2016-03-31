//
//  RGFieldView.h
//  YT_business
//
//  Created by chun.chen on 15/6/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RGFieldViewDelegate;

@interface RGFieldView : UIView <UITextFieldDelegate>

@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UITextField *textFiled;
@property(readonly, nonatomic) UIImageView *topLine;
@property(readonly, nonatomic) UIImageView *bottomLine;
@property(strong, nonatomic) NSString *placeholder;
@property(assign, nonatomic) CGFloat leftMargin;
@property(nonatomic) UIKeyboardType keyboardType;
// defines NO
@property(assign, nonatomic) BOOL displayTopLine;

@property (assign, nonatomic) id<RGFieldViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame;
@end


@protocol RGFieldViewDelegate <NSObject>
@optional
- (void)rgfiledView:(RGFieldView *)filedView textFieldDidBeginEditing:(UITextField *)textField;
- (void)rgfiledView:(RGFieldView *)filedView textFieldDidEndEditing:(UITextField *)textField;
- (void)rgfiledView:(RGFieldView *)filedView textFieldShouldReturn:(UITextField *)textField;

@end
