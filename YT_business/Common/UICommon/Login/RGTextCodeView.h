//
//  RGTextCodeView.h
//  YT_business
//
//  Created by chun.chen on 15/6/4.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^reqValidCodeBlock)(NSString *mobile);

@interface RGTextCodeView : UIView
<
UITextFieldDelegate
>

@property (strong, nonatomic) UIButton *codeBtn;
@property (assign, nonatomic) BOOL countdowning;
@property (strong, nonatomic) UITextField *psdField;
@property (strong, nonatomic) UITextField *codeField;
@property (strong, nonatomic) UITextField *phoneField;
@property (nonatomic,copy) reqValidCodeBlock validCodeBlock;


- (BOOL)checkTextDidInEffect;
@end
