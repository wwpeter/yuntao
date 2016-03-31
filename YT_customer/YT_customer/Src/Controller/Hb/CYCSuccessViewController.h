//
//  CYCSuccessViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYCSuccessViewController : UIViewController

// 标题
@property (strong, nonatomic) NSString *successTitle;
// 说明
@property (strong, nonatomic) NSString *successDescribe;
// 红色button 标题
@property (strong, nonatomic) NSString *redButtonTitle;
// 灰色button 标题
@property (strong, nonatomic) NSString *grayButtonTitle;
// 是否显示红色按钮
@property (assign, nonatomic) BOOL displayRedButton;
// 是否显示灰色按钮
@property (assign, nonatomic) BOOL displaygrayButton;
@end
