//
//  ZHQChangeAccountViewController.h
//  YT_customer
//
//  Created by 郑海清 on 15/6/15.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+HBClass.h"
#import "UIBarButtonItem+Addition.h"
@interface ZHQChangeAccountViewController : UIViewController<UITextFieldDelegate>

typedef NS_ENUM(NSInteger,ViewType) {
    NickView,
    PhoneView,
    NewPhoneView,
    PasswordView,
    };
typedef void (^changeBlock)(NSString *value,ViewType viewType);
@property (nonatomic) ViewType viewType;

@property (strong, nonatomic) UITextField *nickTextField;


@property (copy, nonatomic) changeBlock block;


@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) UIButton *getCode;



@property (strong, nonatomic) NSString *oldPassword;
@property (strong, nonatomic) UITextField *oldPasswordTextField;
@property (strong, nonatomic) UITextField *tPasswordTextField;
@property (strong, nonatomic) UITextField *checkPasswordTextField;



@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;


@property (strong, nonatomic) UIButton *bottomBtn;
@property (assign, nonatomic) BOOL countdowning;


@end
