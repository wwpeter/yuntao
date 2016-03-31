//
//  ZHQMeAccountViewController.h
//  YT_customer
//
//  Created by 郑海清 on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTDetailActionView.h"
#import "ZHQMeUserInfoModel.h"
#import "StoryBoardUtilities.h"
#import "ZHQChangeAccountViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "UserInfomationModel.h"

@interface ZHQMeAccountViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

typedef void (^changeBlock)(NSString *value,ViewType viewType);
@property (strong, nonatomic) UIImageView *userIconImg;
@property (strong, nonatomic) NSMutableArray *msgList;
@property (strong, nonatomic) UIButton *photoBtn;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) YTDetailActionView *nickView;
@property (strong, nonatomic) YTDetailActionView *userPhoneView;
@property (strong, nonatomic) YTDetailActionView *passwordView;
@property (strong, nonatomic) UserInfomationModel *model;
@property (strong, nonatomic) NSString *passwordStr;
@property (assign, nonatomic) BOOL issSelectImg;

-(id)initWithFrame:(CGRect)frame;

@end
