//
//  YTNotificationRemindViewController.m
//  YT_counterman
//
//  Created by chun.chen on 15/6/22.
//  Copyright (c) 2015年 杭州赛融网络科技有限公司. All rights reserved.
//

#import "YTNotificationRemindViewController.h"

@interface YTNotificationRemindViewController ()

@property (strong, nonatomic)UIImageView *iconImageView;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UILabel *messageLabel;
@property (strong, nonatomic)UIImageView *settingImageView;
@property (strong, nonatomic)UILabel *settingLabel;
@property (strong, nonatomic)UIImageView *remindImageView;
@property (strong, nonatomic)UILabel *remindLabel;
@property (strong, nonatomic)UIImageView *hbImageView;
@property (strong, nonatomic)UILabel *hbLabel;
@end

@implementation YTNotificationRemindViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupUserDidOpenNotification
{
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (type == UIRemoteNotificationTypeNone) {
        self.iconImageView.image = [UIImage imageNamed:@"yt_notification_fail.png"];
         self.titleLabel.text = @"新消息提醒已关闭";
    } else{
         self.iconImageView.image = [UIImage imageNamed:@"yt_notification_success.png"];
         self.titleLabel.text = @"新消息提醒已开启";
    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.messageLabel];
    [self.view addSubview:self.settingImageView];
    [self.view addSubview:self.settingLabel];
    [self.view addSubview:self.remindImageView];
    [self.view addSubview:self.remindLabel];
    [self.view addSubview:self.hbImageView];
    [self.view addSubview:self.hbLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(57+64);
        make.centerX.mas_equalTo(self.view).offset(30);
    }];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50+64);
        make.right.mas_equalTo(_titleLabel.left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(_iconImageView.bottom).offset(50);
    }];
    [_settingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_messageLabel.bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_settingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_settingImageView.right).offset(15);
        make.centerY.mas_equalTo(_settingImageView);
        make.right.mas_equalTo(self.view);
    }];
    
    [_remindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_settingImageView);
        make.top.mas_equalTo(_settingImageView.bottom).offset(15);
        make.size.mas_equalTo(_settingImageView);
    }];
    [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_remindImageView.right).offset(15);
        make.centerY.mas_equalTo(_remindImageView);
        make.right.mas_equalTo(self.view);
    }];
    
    [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_remindImageView);
        make.top.mas_equalTo(_remindImageView.bottom).offset(15);
        make.size.mas_equalTo(_remindImageView);
    }];
    [_hbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_hbImageView.right).offset(15);
        make.centerY.mas_equalTo(_hbImageView);
        make.right.mas_equalTo(self.view);
    }];
    [self setupUserDidOpenNotification];
}
#pragma mark - Getters & Setters
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_notification_success.png"]];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = CCCUIColorFromHex(0x666666);
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        NSString *message = @"要开启或停用云淘红包客户端的新消息提醒服务,您可以在 设置>通知>云淘红包 中手动设置";
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:message];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:10];
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, message.length)];
        [str addAttribute:NSForegroundColorAttributeName value:YTDefaultRedColor range:NSMakeRange(27, 10)];
        _messageLabel.attributedText = str;

    }
    return _messageLabel;
}
- (UIImageView *)settingImageView
{
    if (!_settingImageView) {
        _settingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"levelthree_setting_icon.png"]];
    }
    return _settingImageView;
}
- (UILabel *)settingLabel
{
    if (!_settingLabel) {
        _settingLabel = [[UILabel alloc] init];
        _settingLabel.numberOfLines = 1;
        _settingLabel.font = [UIFont systemFontOfSize:14];
        _settingLabel.textColor = CCCUIColorFromHex(0x333333);
        _settingLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _settingLabel.text = @"打开“设置”";
    }
    return _settingLabel;
}
- (UIImageView *)remindImageView
{
    if (!_remindImageView) {
        _remindImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"levelthree_setting_icon02.png"]];
    }
    return _remindImageView;
}
- (UILabel *)remindLabel
{
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.numberOfLines = 1;
        _remindLabel.font = [UIFont systemFontOfSize:14];
        _remindLabel.textColor = CCCUIColorFromHex(0x333333);
        _remindLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _remindLabel.text = @"进入“通知中心”";
    }
    return _remindLabel;
}
- (UIImageView *)hbImageView
{
    if (!_hbImageView) {
        _hbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_customer_logo_01.png"]];
    }
    return _hbImageView;
}
- (UILabel *)hbLabel
{
    if (!_hbLabel) {
        _hbLabel = [[UILabel alloc] init];
        _hbLabel.numberOfLines = 1;
        _hbLabel.font = [UIFont systemFontOfSize:14];
        _hbLabel.textColor = CCCUIColorFromHex(0x333333);
        _hbLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _hbLabel.text = @"选择“云淘红包”开启提醒";
    }
    return _hbLabel;
}
@end
