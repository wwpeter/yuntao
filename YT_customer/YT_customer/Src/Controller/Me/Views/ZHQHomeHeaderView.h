//
//  ZHQHomeHeaderView.h
//  YT_business
//
//  Created by 郑海清 on 15/6/13.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+HBClass.h"
#import "ZHQMyHeaderTapDelegate.h"
#import "NSStrUtil.h"

@interface ZHQHomeHeaderView : UIView

@property (strong, nonatomic) UIImageView *backgroudImg;
@property (strong, nonatomic) UIImageView *userIconImg;
@property (strong, nonatomic) UIButton *userNickBtn;
@property (assign, nonatomic) CGRect myFrame;
@property (weak, nonatomic) id<ZHQMyHeaderTapDelegate> tapDelegate;


-(instancetype)init;
-(instancetype)initWithFrame:(CGRect)frame ;

-(void)updateuserInfomation;
@end
