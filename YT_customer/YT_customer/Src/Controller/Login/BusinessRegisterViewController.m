//
//  BusinessRegisterViewController.m
//  YT_business
//
//  Created by chun.chen on 15/6/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "BusinessRegisterViewController.h"
#import "TopRedView.h"
#import "RGFieldView.h"
#import "RGActionView.h"
#import "RGCheckView.h"
#import "MBProgressHUD+Add.h"
#import "UIImage+HBClass.h"
#import "CTAssetsPickerController.h"
#import "UIViewController+Helper.h"
#import "RGPototViewController.h"
#import "BusinessRegisterSecondViewController.h"
#import "RGSelectTimeView.h"
#import "RGSelectSortView.h"
#import "RGSelectAddressViewController.h"

static const NSInteger kDefaultPadding = 15;
static const NSInteger kDefaultHeight = 50;
static const NSInteger kStoreHeight = 200;
static const NSInteger kMilieuHeight = 80;
static const NSInteger kMilieuImageWidth = 65;

static const NSInteger kNameFieldTag = 1000;
static const NSInteger kPhoneFieldTag = 1001;
static const NSInteger kUnitFieldTag = 1002;
static const NSInteger kAddressTag = 2000;
static const NSInteger kSortTag = 2001;
static const NSInteger kOptionTag = 2002;
static const NSInteger ktimeTag = 2003;
static const NSInteger kStoreSheetTag = 4000;
static const NSInteger kMilieuSheetTag = 4001;
static const NSInteger kMilieuImageTag = 5000;

static const NSInteger kMaxMilieuImageCount = 9;

@interface BusinessRegisterViewController ()<UIScrollViewDelegate,RGFieldViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,CTAssetsPickerControllerDelegate,MWPhotoBrowserDelegate,RGActionViewDelegate,RGFieldViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIScrollView *milieuScrollView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) RGFieldView *nameField;
@property (strong, nonatomic) RGActionView *addressView;
@property (strong, nonatomic) RGActionView *sortView;
@property (strong, nonatomic) RGActionView *optionView;
@property (strong, nonatomic) RGActionView *timeView;
@property (strong, nonatomic) RGCheckView *carView;
@property (strong, nonatomic) RGFieldView *phoneField;
@property (strong, nonatomic) RGFieldView *unitField;

@property (strong, nonatomic) RGSelectTimeView *selectTimeView;
@property (strong, nonatomic) RGSelectSortView *selectSortView;

@property (strong, nonatomic) UIImagePickerController *storeImagePicker;
@property (strong, nonatomic) UIImagePickerController *milieuImagePicker;
@property (strong, nonatomic) UIImageView *storeImageView;
@property (strong, nonatomic) UIImage *storeImage;
@property (strong, nonatomic) UIButton *selectMilieuBtn;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *milieuImageViews;
@property (strong, nonatomic) NSMutableArray *milieuImageArray;

@property (assign, nonatomic) BOOL didSelectOptional;

@end

@implementation BusinessRegisterViewController

#pragma mark - Life cycle
- (id)init {
    if ((self = [super init])) {
        self.navigationItem.title = @"注册1/3";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"下一步", @"Next") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    
    self.didSelectOptional = NO;
    self.milieuImageArray = [[NSMutableArray alloc] initWithCapacity:kMaxMilieuImageCount];
    self.milieuImageViews = [[NSMutableArray alloc] initWithCapacity:kMaxMilieuImageCount];
    [self initializePageSubviews];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.view endEditing:YES];
}
- (void)rgactionViewDidClicked:(RGActionView *)actionView
{
    [self.view endEditing:YES];
    if (actionView.tag == kOptionTag) {
        _didSelectOptional = !_didSelectOptional;
        [self didShowOptionalViewAnimation:_didSelectOptional];
    } else if (actionView.tag == ktimeTag) {
        [self showSelectTimeView];
    } else if (actionView.tag == kSortTag) {
        [self showSelectSortView];
    } else if (actionView.tag == kAddressTag) {
        [self showSelectAddressView];
    }
}
- (void)rgfiledView:(RGFieldView *)filedView textFieldDidBeginEditing:(UITextField *)textField
{
    if (filedView.tag == kPhoneFieldTag || filedView.tag == kUnitFieldTag) {
        [self.scrollView setContentOffset:CGPointMake(0, 200) animated:YES];
    }
}
- (void)rgfiledView:(RGFieldView *)filedView textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
}
#pragma mark - imagePicker delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:picker.view];
    [picker.view addSubview:hud];
    hud.labelText = @"正在处理图片...";
    __block UIImage *image = info[UIImagePickerControllerOriginalImage];
    [hud showAnimated:YES whileExecutingBlock:^{
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        if (width > kDeviceCurrentWidth) {
            CGFloat multiple = kDeviceCurrentWidth / width;
            height = height * multiple;
            width = kDeviceCurrentWidth;
            image = [image imageWithImage:image scaledToSize:CGSizeMake(width, height)];
        }
    } completionBlock:^{
        [hud removeFromSuperview];
        if (picker == _storeImagePicker) {
            self.storeImage = image;
        } else {
            [_milieuImageArray addObject:image];
            [self showMilieuImages:_milieuImageArray.count-1];
        }
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }];
}
#pragma mark - assets Picker Delegate
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:picker.view];
    [picker.view addSubview:hud];
    hud.labelText = @"正在处理图片...";
    __block NSMutableArray *images = self.milieuImageArray;
    [hud showAnimated:YES whileExecutingBlock:^{
        for (ALAsset *asset in assets) {
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            CGFloat width = image.size.width;
            CGFloat height = image.size.height;
            if (width > 640) {
                float multiple = 640 / width;
                height = height * multiple;
                width = 640;
                image = [image imageWithImage:image scaledToSize:CGSizeMake(width, height)];
            }
            [images addObject:image];
        }
    } completionBlock:^{
        [hud removeFromSuperview];
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [self showMilieuImages:images.count - assets.count];
        }];
    }];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    NSInteger count= kMaxMilieuImageCount - _milieuImageArray.count;
    if (picker.selectedAssets.count >= count)
    {
        [self showAlert:[NSString stringWithFormat:@"您最多只能选择%@张图片",@(count)] title:@""];
    }
    
    if (!asset.defaultRepresentation)
    {
        [self showAlert:@"Your asset has not yet been downloaded to your device" title:@""];
    }
    
    return (picker.selectedAssets.count < count && asset.defaultRepresentation != nil);
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count) {
        return _photos[index];
    }
    return nil;
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser deletePhotoAtIndex:(NSUInteger)index
{
    if (_photos[index] != [NSNull null]) {
        [_photos removeObjectAtIndex:index];
        [_milieuImageArray removeObjectAtIndex:index];
        for (UIView *view in _milieuImageViews) {
            [view removeFromSuperview];
        }
        [_milieuImageViews removeAllObjects];
        [self showMilieuImages:0];
        if (_photos.count > 0) {
            [photoBrowser reloadData];
        }
        else {
            [photoBrowser.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark - UISheetViewDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kStoreSheetTag){
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0: {
                    self.storeImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                } break;
                    
                case 1: {
                    self.storeImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                } break;
                case 2:
                    return;
                default:
                    return;
            }
        } else {
            if (buttonIndex == 0 ) {
                self.storeImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            else {
                return;
            }
        }
        [self presentViewController:self.storeImagePicker animated:YES completion:^{}];
    }
    else {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0: {
                    [self presentViewController:self.milieuImagePicker animated:YES completion:^{}];
                }
                    break;
                case 1:
                    // 相册
                    [self presentToAssetsPickerController];
                    break;
                    
                case 2:
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                [self presentToAssetsPickerController];
            }
            else {
                return;
            }
        }
    }
}

#pragma mark - Event response
- (void)addStorePhoto:(id)senser
{
    [self showPhotoSheetWithTag:kStoreSheetTag];
}
- (void)addMilieuPhoto:(id)senser
{
    [self showPhotoSheetWithTag:kMilieuSheetTag];
}
- (void)tapMilieuImage:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_milieuImageArray.count];
    for (UIImage *image in _milieuImageArray) {
        MWPhoto *photo = [MWPhoto photoWithImage:image];
        [photos addObject:photo];
    }
    self.photos = photos;
    RGPototViewController *browser = [[RGPototViewController alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.currentPhotoIndex = tap.view.tag - kMilieuImageTag;
    [self.navigationController pushViewController:browser animated:YES];
}
- (void)scrollViewTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
#pragma mark - Private methods
- (void)didShowOptionalViewAnimation:(BOOL)show
{
    CGRect rect = self.bottomView.frame;
    if (show) {
        rect.size.height = 4*kDefaultHeight+kStoreHeight+kMilieuHeight+30;
        
    } else {
         rect.size.height = 0;
    }
    [UIView animateWithDuration:.3f animations:^{
        _bottomView.frame = rect;
    }];
}
- (void)showSelectTimeView
{
    if (!_selectTimeView) {
        _selectTimeView = [[RGSelectTimeView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_selectTimeView];
    }
    [_selectTimeView showSelectTimeView];
}
- (void)showSelectSortView
{
    if (!_selectSortView) {
        _selectSortView = [[RGSelectSortView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_selectSortView];
    }
    [_selectSortView showSelectSortView];
}
- (void)showSelectAddressView
{
    RGSelectAddressViewController *addressVC = [[RGSelectAddressViewController alloc] init];
    [self.navigationController pushViewController:addressVC animated:YES];
}
- (void)showMilieuImages:(NSInteger)count
{
    if (_selectMilieuBtn) {
        [_selectMilieuBtn removeFromSuperview];
    }
    for (NSInteger i = count; i<_milieuImageArray.count; i++) {
        CGFloat imageX = i*(kMilieuImageWidth + 10) + kDefaultPadding;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 0, kMilieuImageWidth, kMilieuImageWidth)];
        imageView.tag = kMilieuImageTag + i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMilieuImage:)]];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image =_milieuImageArray[i];
        [_milieuScrollView addSubview:imageView];
        [_milieuImageViews addObject:imageView];
    }
    if (_milieuImageArray.count < kMaxMilieuImageCount) {
        [self addselectPhotoButton];
        CGFloat Width =  (kMilieuImageWidth + 10)*(_milieuImageArray.count+1)+kDefaultPadding;
        _milieuScrollView.contentSize = CGSizeMake(Width, 0);
    }else {
        CGFloat Width =  (kMilieuImageWidth + 10)*_milieuImageArray.count+kDefaultPadding;
         _milieuScrollView.contentSize = CGSizeMake(Width, 0);
    }
}
- (void)addselectPhotoButton
{
    _selectMilieuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectMilieuBtn setBackgroundImage:[UIImage imageNamed:@"yt_register_addBtn.png"] forState:UIControlStateNormal];
    [_selectMilieuBtn addTarget:self action:@selector(addMilieuPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger bCount = _milieuImageArray.count;
    CGFloat bX = bCount * (kMilieuImageWidth + 10) + kDefaultPadding;
    _selectMilieuBtn.frame = CGRectMake(bX, 0, kMilieuImageWidth, kMilieuImageWidth);
    [_milieuScrollView addSubview:_selectMilieuBtn];
}
- (void)showPhotoSheetWithTag:(NSInteger)tag
{
    [self.view endEditing:YES];
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = tag;
    [sheet showInView:self.view];
}
- (void)presentToAssetsPickerController
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter         = [ALAssetsFilter allPhotos];
    picker.delegate             = self;
    picker.title                = NSLocalizedString(@"相册", @"picker controller");
    picker.selectedAssets       = [[NSMutableArray alloc] init];
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - Notification Response
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self.view endEditing:YES];
    BusinessRegisterSecondViewController *registerSecondVC = [[BusinessRegisterSecondViewController alloc] init];
    [self.navigationController pushViewController:registerSecondVC animated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    TopRedView *redView = [[TopRedView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 10)];
    [self.view addSubview:redView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.topView];
    [self.scrollView addSubview:self.bottomView];
    [self.topView addSubview:self.nameField];
    [self.topView addSubview:self.addressView];
    [self.topView addSubview:self.sortView];
    [self.scrollView addSubview:self.optionView];
    [self.bottomView addSubview:self.timeView];
    [self.bottomView addSubview:self.carView];
    [self.bottomView addSubview:self.phoneField];
    [self.bottomView addSubview:self.unitField];
    [self.bottomView addSubview:self.storeImageView];
    [self setupStoreButton];
     [self.bottomView addSubview:self.milieuScrollView];
    [self showMilieuImages:0];
}
- (void)setupStoreButton
{
    UIButton *storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [storeBtn setBackgroundImage:[UIImage imageNamed:@"yt_register_uploadImage.png"] forState:UIControlStateNormal];
    [storeBtn addTarget:self action:@selector(addStorePhoto:) forControlEvents:UIControlEventTouchUpInside];
    storeBtn.frame = CGRectMake(0, _storeImageView.frame.origin.y+55, 45, 45);
    storeBtn.center = CGPointMake(_storeImageView.center.x, storeBtn.center.y);
    [self.bottomView addSubview:storeBtn];
    
    UILabel *storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, storeBtn.frame.origin.y+60, CGRectGetWidth(_storeImageView.bounds), 25)];
    storeLabel.font = [UIFont systemFontOfSize:20];
    storeLabel.textColor = [UIColor whiteColor];
    storeLabel.text = @"添加店面照片";
    storeLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:storeLabel];
    
    UILabel *milieuLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultPadding, _storeImageView.frame.origin.y+CGRectGetHeight(_storeImageView.bounds)+10, CGRectGetWidth(_storeImageView.bounds), 15)];
    milieuLabel.font = [UIFont systemFontOfSize:14];
    milieuLabel.textColor = [UIColor grayColor];
    milieuLabel.text = @"环境图";
    [self.bottomView addSubview:milieuLabel];
}
#pragma mark - Getters & Setters
- (void)setStoreImage:(UIImage *)storeImage
{
    _storeImage = storeImage;
    self.storeImageView.image = storeImage;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-10)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(0, 8*kDefaultHeight+kStoreHeight+kMilieuHeight+140);
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)]];

    }
    return _scrollView;
}
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, kDefaultPadding, CGRectGetWidth(self.view.bounds), 3*kDefaultHeight)];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, (2*kDefaultPadding)+(4*kDefaultHeight), CGRectGetWidth(self.view.bounds), 0)];
        _bottomView.clipsToBounds = YES;
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (RGFieldView *)nameField
{
    if (!_nameField) {
        _nameField = [[RGFieldView alloc] initWithTitle:@"名称" frame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kDefaultHeight)];
        _nameField.tag = kNameFieldTag;
        _nameField.delegate = self;
        _nameField.displayTopLine = YES;
        _nameField.placeholder = @"请输入名称";
    }
    return _nameField;
}
- (RGActionView *)addressView
{
    if (!_addressView) {
        _addressView = [[RGActionView alloc] initWithTitle:@"地址" frame:CGRectMake(0, kDefaultHeight, CGRectGetWidth(self.view.bounds), kDefaultHeight)];
        _addressView.tag = kAddressTag;
        _addressView.delegate = self;
        _addressView.detailLabel.text = @"199999999号";
    }
    return _addressView;
}
- (RGActionView *)sortView
{
    if (!_sortView) {
        _sortView = [[RGActionView alloc] initWithTitle:@"分类" frame:CGRectMake(0, 2*kDefaultHeight, CGRectGetWidth(self.view.bounds), kDefaultHeight)];
        _sortView.tag = kSortTag;
        _sortView.delegate = self;
        _sortView.leftMargin = 0;
    }
    return _sortView;
}
- (RGActionView *)optionView
{
    if (!_optionView) {
        _optionView = [[RGActionView alloc] initWithTitle:@"选填" frame:CGRectMake(0, (2*kDefaultPadding)+(3*kDefaultHeight), CGRectGetWidth(self.view.bounds), kDefaultHeight)];
        _optionView.tag = kOptionTag;
        _optionView.delegate = self;
        _optionView.displayTopLine = YES;
        _optionView.leftMargin = 0;
        _optionView.diversification = YES;
        _optionView.backgroundColor = [UIColor whiteColor];
    }
    return _optionView;
}
- (RGActionView *)timeView
{
    if (!_timeView) {
        _timeView = [[RGActionView alloc] initWithTitle:@"营业时间" frame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kDefaultHeight)];
        _timeView.tag = ktimeTag;
        _timeView.delegate = self;
        _timeView.detailLabel.text = @"9:00-21:00 \n周一周二周三周四周五周六周日";
    }
    return _timeView;
}
- (RGCheckView *)carView
{
    if (!_carView) {
        _carView = [[RGCheckView alloc] initWithTitle:@"停车位" frame:CGRectMake(0, kDefaultHeight, CGRectGetWidth(self.view.bounds), kDefaultHeight)];
    }
    return _carView;
}
- (RGFieldView *)phoneField
{
    if (!_phoneField) {
        _phoneField = [[RGFieldView alloc] initWithTitle:@"电话" frame:CGRectMake(0, 2*kDefaultHeight, CGRectGetWidth(self.view.bounds), kDefaultHeight)];
        _phoneField.tag = kPhoneFieldTag;
        _phoneField.delegate = self;
        _phoneField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _phoneField;
}
- (RGFieldView *)unitField
{
    if (!_unitField) {
        _unitField = [[RGFieldView alloc] initWithTitle:@"人均" frame:CGRectMake(0, 3*kDefaultHeight, CGRectGetWidth(self.view.bounds), kDefaultHeight)];
        _unitField.tag = kUnitFieldTag;
        _unitField.tag = kPhoneFieldTag;
        _unitField.keyboardType = UIKeyboardTypeNumberPad;
        _unitField.placeholder = @"请输入人均消费";
    }
    return _unitField;
}
- (UIImageView *)storeImageView
{
    if (!_storeImageView) {
        _storeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4*kDefaultHeight, CGRectGetWidth(self.view.bounds), kStoreHeight)];
        _storeImageView.clipsToBounds = YES;
        _storeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _storeImageView.image = CCImageNamed(@"yt_register_photoimage.png");
    }
    return _storeImageView;
}
- (UIScrollView *)milieuScrollView
{
    if (!_milieuScrollView) {
        _milieuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 4*kDefaultHeight+kStoreHeight+35, CGRectGetWidth(self.view.bounds), kMilieuHeight)];
    }
    return _milieuScrollView;

}
-(UIImagePickerController *)milieuImagePicker
{
    if(!_milieuImagePicker){
        _milieuImagePicker = [[UIImagePickerController alloc]init];
        _milieuImagePicker.delegate = self;
        _milieuImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    return _milieuImagePicker;
}
-(UIImagePickerController *)storeImagePicker
{
    if(!_storeImagePicker){
        _storeImagePicker = [[UIImagePickerController alloc]init];
        _storeImagePicker.delegate = self;
    }
    return _storeImagePicker;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
