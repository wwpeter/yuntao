//
//  ZHQHomeHeaderView.m
//  YT_business
//
//  Created by 郑海清 on 15/6/13.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "ZHQHomeHeaderView.h"
#import "UserInfomationModel.h"
#import "UserMationMange.h"
#import "UIImageView+WebCache.h"

#define kHeadDefaultIcon [UIImage imageNamed:@"zhq_user_defult_icon"]

@implementation ZHQHomeHeaderView

#pragma mark -Life cycle


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.myFrame = frame;
        [self setUp];
    }
    return self;
}

#pragma mark - Event response
- (void)toMyHb:(id)sender
{
    [_tapDelegate toMyHbTap:sender];
}

- (void)toMyConsume:(id)sender
{
    [_tapDelegate toMyConsumeTap:sender];
}

- (void)handlMyIcon:(id)sender
{
    [_tapDelegate toMyInfoTap:sender];
}

#pragma mark -Public Menthods
- (void)updateuserInfomation
{
    if ([[UserMationMange sharedInstance] userLogin]) {
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        NSString* userName = [userDefault objectForKey:iYCUserNameKey];
        [self.userNickBtn setTitle:userName forState:UIControlStateNormal];
        NSData* imageData = [userDefault objectForKey:iYCUserImageKey];
        if (imageData) {
            UIImage* image = [UIImage imageWithData:imageData];
            self.userIconImg.image = image;
        }
        else {
            NSString* imageAvatar = [userDefault objectForKey:iYCUserAvatarKey];
            [self.userIconImg sd_setImageWithURL:[imageAvatar imageUrlWithWidth:200] placeholderImage:kHeadDefaultIcon];
        }
    }
    else {
        [self.userNickBtn setTitle:@"点击登录" forState:UIControlStateNormal];
        self.userIconImg.image = kHeadDefaultIcon;
    }
}
#pragma mark -Private Menthods

#pragma mark - Page subviews
- (void)setUp
{
    [self addSubview:self.backgroudImg];
    [self addSubview:self.userIconImg];
    [self addSubview:self.userNickBtn];

    //添加约束
    [_backgroudImg makeConstraints:^(MASConstraintMaker* make) {
        make.edges.mas_equalTo(self);
    }];
    [_userIconImg makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];

    [_userNickBtn makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self.userIconImg);
        make.top.mas_equalTo(self.userIconImg.bottom).offset(10);
    }];
}

#pragma mark - Getters && Setters
- (UIImageView*)backgroudImg
{
    if (!_backgroudImg) {
        _backgroudImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhq_my_backgroud"]];
        _backgroudImg.clipsToBounds = YES;
        _backgroudImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroudImg;
}

- (UIImageView*)userIconImg
{
    if (!_userIconImg) {
        _userIconImg = [[UIImageView alloc] initWithImage:kHeadDefaultIcon];
        _userIconImg.contentMode = UIViewContentModeScaleAspectFill;
        _userIconImg.userInteractionEnabled = YES;
        _userIconImg.layer.masksToBounds = YES;
        _userIconImg.layer.cornerRadius = _userIconImg.frame.size.height / 2;
        _userIconImg.layer.borderWidth = 2;
        _userIconImg.layer.borderColor = CCCUIColorFromHex(0xffffff).CGColor;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlMyIcon:)];
        [_userIconImg addGestureRecognizer:tap];
    }
    return _userIconImg;
}

- (UIButton*)userNickBtn
{
    if (!_userNickBtn) {
        _userNickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _userNickBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_userNickBtn setTitleColor:CCCUIColorFromHex(0xffffff) forState:UIControlStateNormal];
        [_userNickBtn setTitle:@"点击登录" forState:UIControlStateNormal];
        [_userNickBtn addTarget:self action:@selector(handlMyIcon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userNickBtn;
}
@end
