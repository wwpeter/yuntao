//
//  ZHQMeAccountViewController.m
//  YT_customer
//
//  Created by 郑海清 on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "ZHQMeAccountViewController.h"
#import "YTNetworkMange.h"
#import "YTEditPhoneViewController.h"

@interface ZHQMeAccountViewController ()

@end

@implementation ZHQMeAccountViewController

#pragma mark -Life cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view.frame = frame;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"我的账户";
    [self loadData];
    [self setUpSubviews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 检测是否触发返回
    if (![self.navigationController.viewControllers containsObject:self]) {
        [self uploadLocaldata];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - loadData
- (void)loadData
{
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_UserInfo
        parameters:nil
        success:^(id responseData) {

        }
        failure:^(NSString* errorMessage){

        }];
}

#pragma mark - 相册的代理
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    _issSelectImg = NO;
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    _issSelectImg = YES;
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:picker.view];
    [picker.view addSubview:hud];
    hud.labelText = @"正在处理图片...";
    __block UIImage* image = info[UIImagePickerControllerEditedImage];
    [hud showAnimated:YES
        whileExecutingBlock:^{
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
            CGFloat width = image.size.width;
            CGFloat height = image.size.height;
            if (width > kDeviceCurrentWidth) {
                CGFloat multiple = kDeviceCurrentWidth / width;
                height = height * multiple;
                width = kDeviceCurrentWidth;
                image = [image imageWithImage:image scaledToSize:CGSizeMake(width, height)];
            }
        }
        completionBlock:^{
            [hud removeFromSuperview];
            self.userIconImg.image = image;
            [[NSUserDefaults standardUserDefaults] setObject:UIImageJPEGRepresentation(image, 0.5) forKey:iYCUserImageKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [picker dismissViewControllerAnimated:YES
                                       completion:^{
                                       }];
        }];
}

#pragma mark - UISheetViewDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
        case 0: {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } break;

        case 1: {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } break;
        case 2:
            return;
        default:
            return;
        }
    }
    else {
        if (buttonIndex == 0) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        else {
            return;
        }
    }
    [self presentViewController:self.imagePicker
                       animated:YES
                     completion:^{
                     }];
}

#pragma mark Private Methods
- (void)uploadLocaldata
{
    //    [YCApi setupCookies];
    [self upLoadNick];
    if (_issSelectImg) {
        [self upLoadImg];
    }
}

- (void)upLoadImg
{
    //上传头像
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_UpdataAvatarImg
        parameters:nil
        singleImage:_userIconImg.image
        imageName:@"avatarImg"
        success:^(id responseData) {
            _model = [[UserInfomationModel alloc] initWithUserDictionary:responseData[@"data"]];
            [_model saveUserDefaults];
        }
        failure:^(NSString* errorMessage){

        }];
}

- (void)upLoadNick
{
    //上传昵称
    NSDictionary* parameters = @{ @"userName" : _nickView.detailLabel.text };
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_UpdateUserInfo
        parameters:parameters
        success:^(id responseData) {
            _model = [[UserInfomationModel alloc] initWithUserDictionary:responseData[@"data"]];
            [_model saveUserDefaults];
        }
        failure:^(NSString* errorMessage){
            NSLog(@"%@",errorMessage);
        }];
}
#pragma mark - Events response 相册选择图片
- (void)addLicensePhoto:(id)senser
{
    UIActionSheet* sheet;
    // 判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    [sheet showInView:self.view];
}

#pragma mark Page subviews
- (void)setUpSubviews
{
    [self.view addSubview:self.userIconImg];
    [self.view addSubview:self.nickView];
    [self.view addSubview:self.userPhoneView];
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.photoBtn];

    [_userIconImg makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(self.view).offset(64 + 25);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];

    [_photoBtn makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.center.mas_equalTo(_userIconImg);
    }];

    [_nickView makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(self.userIconImg.bottom).offset(25);
        make.height.mas_offset(50);
        make.left.right.equalTo(self.view);
    }];
    [_userPhoneView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickView.bottom);
        make.height.mas_offset(50);
        make.left.right.equalTo(self.view);
    }];
    [_passwordView makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_userPhoneView.bottom);
        make.height.mas_offset(50);
        make.left.right.equalTo(self.view);
    }];
}

- (void)changePageValue:(NSString*)value type:(ViewType)type
{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];

    switch (type) {
    case NickView:
        [userDef setObject:value forKey:iYCUserNameKey];
        _nickView.detailLabel.text = [userDef objectForKey:iYCUserNameKey];
        break;
    case PhoneView:
        [userDef setObject:value forKey:iYCUserMobileKey];
        _userPhoneView.detailLabel.text = [userDef objectForKey:iYCUserMobileKey];
        break;
    case PasswordView:
        _passwordStr = value;
        break;
    default:
        break;
    }
    [userDef synchronize];
}

#pragma mark - Getters && Setters

- (UIImagePickerController*)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

- (UIButton *)photoBtn
{
    if (!_photoBtn) {
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBtn setBackgroundImage:[UIImage imageNamed:@"yt_register_uploadImage.png"] forState:UIControlStateNormal];
        [_photoBtn setBackgroundColor:[UIColor clearColor]];
        [_photoBtn addTarget:self action:@selector(addLicensePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}

- (UIImageView *)userIconImg
{
    if (!_userIconImg) {
        _userIconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhq_user_defult_icon"]];
        _userIconImg.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:iYCUserImageKey]];
        _userIconImg.contentMode = UIViewContentModeScaleAspectFit;
        _userIconImg.layer.masksToBounds = YES;
        _userIconImg.layer.cornerRadius = 90 / 2;
        _userIconImg.layer.borderWidth = 1;
        _userIconImg.layer.borderColor = [UIColor whiteColor].CGColor;
    }

    return _userIconImg;
}

- (NSMutableArray *)msgList
{
    if (!_msgList) {
        _msgList = [[NSMutableArray alloc] initWithObjects:@"昵称", @"手机", @"密码", nil];
    }
    return _msgList;
}

- (YTDetailActionView *)nickView
{

    if (!_nickView) {
        __weak __typeof(self) weakSelf = self;
        _nickView = [[YTDetailActionView alloc] init];
        _nickView.titleLabel.text = @"昵称";
        _nickView.detailLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:iYCUserNameKey];
        [_nickView displayTopLine:YES bottomLine:YES];
        _nickView.actionBlock = ^(void) {
            [weakSelf pushToChangeView:NickView];
        };
    }
    return _nickView;
}

- (YTDetailActionView*)userPhoneView
{

    if (!_userPhoneView) {
        __weak __typeof(self) weakSelf = self;
        _userPhoneView = [[YTDetailActionView alloc] init];
        _userPhoneView.titleLabel.text = @"手机";
        _userPhoneView.detailLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:iYCUserMobileKey];
        [_userPhoneView displayTopLine:NO bottomLine:YES];
        _userPhoneView.actionBlock = ^(void) {
            [weakSelf pushToChangeView:PhoneView];
        };
        ;
    }
    return _userPhoneView;
}
- (YTDetailActionView*)passwordView
{

    if (!_passwordView) {
        __weak __typeof(self) weakSelf = self;
        _passwordView = [[YTDetailActionView alloc] init];
        _passwordView.titleLabel.text = @"密码";
        _passwordView.detailLabel.text = @"修改";
        [_passwordView displayTopLine:NO bottomLine:YES];
        _passwordView.actionBlock = ^(void) {
            [weakSelf pushToChangeView:PasswordView];
        };
    }
    return _passwordView;
}

#pragma mark - Navigation
- (void)pushToChangeView:(ViewType)viewType
{

    if (viewType == PhoneView) {
        YTEditPhoneViewController* editPhoneVC = [[YTEditPhoneViewController alloc] init];
        __weak __typeof(self) weakSelf = self;
        editPhoneVC.editSuccessBlock = ^(NSString* mobile) {
            [weakSelf changePageValue:mobile type:PhoneView];
        };
        [self.navigationController pushViewController:editPhoneVC animated:YES];
    }
    else {
        ZHQChangeAccountViewController* changeVC = [[ZHQChangeAccountViewController alloc] init];
        changeVC.viewType = viewType;
        __weak __typeof(self) weakSelf = self;
        changeVC.block = ^(NSString* value, ViewType viewType) {
            [weakSelf changePageValue:value type:viewType];
        };
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:changeVC];

        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

@end
