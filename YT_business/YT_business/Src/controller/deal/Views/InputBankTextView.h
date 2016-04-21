//
//  InputBankTextView.h
//  YT_business
//
//  Created by chun.chen on 15/7/20.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCTextField;

@interface InputBankTextView : UIView
@property (nonatomic, copy) dispatch_block_t actionBlock;
@property (nonatomic, strong)CCTextField *textField;
@property (nonatomic, strong)UIButton *doneButton;
@end
