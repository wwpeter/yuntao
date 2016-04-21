#import "StoreEditInfomationViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "MBProgressHUD+Add.h"
#import "UIImage+HBClass.h"
#import "CTAssetsPickerController.h"
#import "UIViewController+Helper.h"
#import "RGPototViewController.h"
#import "RGSelectSortView.h"
#import "RGSelectTimeView.h"
#import "UIImageView+WebCache.h"
#import "NSStrUtil.h"
#import "YTRegisterAddressSelViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "YTCategoryModel.h"
#import "YTLoginModel.h"
#import "YTCategoryModel.h"
#import "YTCityMatch.h"
#import "RESideMenu.h"
#import "YTEditAccountViewController.h"
#import "YTUpdateShopInfoModel.h"
#import "YTEditLicenseViewController.h"
#import "YTCityAreaPickerView.h"
#import "YTRegisterHelper.h"

static const NSInteger kDefaultPadding = 15;
static const NSInteger kStoreHeight = 200;
static const NSInteger kMilieuHeight = 80;
static const NSInteger kMilieuImageWidth = 65;

static const NSInteger kStoreSheetTag = 4000;
static const NSInteger kMilieuSheetTag = 4001;
static const NSInteger kMilieuImageTag = 5000;

static const NSInteger kMaxMilieuImageCount = 30;

@interface StoreEditInfomationViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, CTAssetsPickerControllerDelegate, MWPhotoBrowserDelegate, YTRegisterAddressSelViewControllerDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray* userData;

@property (strong, nonatomic) RGSelectTimeView* selectTimeView;
@property (strong, nonatomic) RGSelectSortView* selectSortView;
@property (strong, nonatomic) YTCityAreaPickerView* areaPickerView;

@property (strong, nonatomic) UIView* headView;
@property (strong, nonatomic) UIScrollView* milieuScrollView;

@property (strong, nonatomic) UIImagePickerController* storeImagePicker;
@property (strong, nonatomic) UIImagePickerController* milieuImagePicker;
@property (strong, nonatomic) UIImageView* storeImageView;
@property (strong, nonatomic) UIImage* storeImage;
@property (strong, nonatomic) UIButton* selectMilieuBtn;
@property (strong, nonatomic) NSMutableArray* photos;
@property (strong, nonatomic) NSMutableArray* milieuImageViews;
@property (strong, nonatomic) NSMutableArray* milieuImageArray;

@property (strong, nonatomic) YTCategoryModel* categoryModel;
@property (strong, nonatomic) YTCategory* shopCathory;

//@property (strong, nonatomic) AMapPOI* mapPoi;
@property (assign, nonatomic) BOOL didShopEdit;
@property (assign, nonatomic) BOOL didShopUpdate;
@end

@implementation StoreEditInfomationViewController

#pragma mark - Life cycle
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"商户信息";
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoSideLefttarget:self action:@selector(leftDrawerButtonPress:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightDrawerButtonPress:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self initializeData];
    [self initializePageSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUserShopMessage];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -reqCategoryData
- (void)reqCategoryData
{
    self.requestURL = getShopCategoryURL;
}
- (void)handleRefresh:(id)sender
{
    self.requestParas = @{ @"shopId" : [YTUsr usr].shop.shopId };
    self.requestURL = shopInfoURL;
}
#pragma mark -override fetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:getShopCategoryURL]) {
            self.categoryModel = (YTCategoryModel*)parserObject;
            self.selectSortView.categoryModel = _categoryModel;
        }
        else if ([operation.urlTag isEqualToString:cityMatchURL]) {
            YTCityMatchModel* cityModel = (YTCityMatchModel*)parserObject;
            self.requestParas = @{ @"address" : [YTUsr usr].shop.address,
                                   @"lat" : @([YTRegisterHelper registerHelper].lat),
                                   @"lon" : @([YTRegisterHelper registerHelper].lon),
                @"zoneId" : @(cityModel.cityMatch.zoneId)
            };
            self.requestURL = updateShopInfoURL;
        }
        else if ([operation.urlTag isEqualToString:shopInfoURL]) {
            YTUpdateShopInfoModel *shopModel = (YTUpdateShopInfoModel *)parserObject;
            [[YTUsr usr] updateUserShop:shopModel.shopInfo];
            [self updateShopData];
            [self updateShopHjImages];
            [self.tableView reloadData];
        }else if ([operation.urlTag isEqualToString:updateShopInfoURL]){
            [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
            if ([YTUsr usr].shop.status == YTSHOPSTATUSAUDIT_NOT_PASS) {
                [self handleRefresh:nil];
            }
            self.didShopEdit = NO;
            self.didShopUpdate = YES;
        }
    }
    else {
        NSString *errorMsg = requestErr ? @"服务连接失败" : parserObject.message;
        [MBProgressHUD showError:errorMsg toView:self.view];
    }
}
#pragma mark - upData
- (void)updateUserShopMessage
{
    YTShop* shop = [YTUsr usr].shop;
    NSString* openTime = [NSString stringWithFormat:@"%@-%@ \n%@", shop.startTime, shop.endTime, [NSStrUtil makeOpendaysWeekWithDays:shop.openDays]];
    NSArray* userArray = @[ @{ @"title" : @"商户名称",
                               @"detail" : [NSStrUtil makeBlank:shop.name] },
                            @{ @"title" : @"区域",
                               @"detail" : [NSString stringWithFormat:@"%@ %@", [NSStrUtil makeBlank:shop.cityIdString], [NSStrUtil makeBlank:shop.areaIdString]]},
                            @{ @"title" : @"详细地址",
                               @"detail" : [NSStrUtil makeBlank:shop.address] },
                            @{ @"title" : @"分类",
                               @"detail" : [NSStrUtil makeBlank:[YTUsr usr].shopCategory.name] },
                            @{ @"title" : @"营业时间",
                               @"detail" : openTime },
                            @{ @"title" : @"停车位",
                               @"detail" : @(shop.parkingSpace) },
                            @{ @"title" : @"电话号码",
                               @"detail" : [NSStrUtil makeBlank:[YTUsr usr].shop.mobile] },
                            @{ @"title" : @"人均",
                               @"detail" : [NSString stringWithFormat:@"￥%@", @(shop.custFee / 100)] },
                            @{ @"title" : @"营业执照",
                               @"detail" : @"" }];
    self.userData = [[NSMutableArray alloc] initWithArray:userArray];
}
- (void)uploadShopMasterImage
{
    NSData* imageData = UIImageJPEGRepresentation(_storeImage, 0.5f);
    NSDictionary* imageDic = @{ @"masterImg" : imageData };
    self.requestParas = @{ postingDataKey : @[ imageDic ] };
    self.requestURL = updateMasterImgURL;
}
- (void)uploadShopHjImageWithLastIndex:(NSInteger)index
{
    [MBProgressHUD showMessag:@"正在上传..." toView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray* postDataArr = [[NSMutableArray alloc] init];
        NSMutableArray* imageArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < index; i++) {
            NSInteger imageIndex = _milieuImageArray.count - i;
            id object = _milieuImageArray[imageIndex - 1];
            if ([object isKindOfClass:[UIImage class]]) {
                NSData* imageData = UIImageJPEGRepresentation((UIImage*)object, 0.5f);
                //            NSString *imageKey = [NSString stringWithFormat:@"hjImg[%@]",@(i)];
                //            NSDictionary *imageDic = @{imageKey : imageData};
                [imageArr addObject:imageData];
            }
        }
        [postDataArr addObject:@{ @"hjImg" : imageArr }];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.requestParas = @{ postingDataKey : postDataArr };
            self.requestURL = addHJImgURL;
        });
    });
}
- (void)deleteShopHJImg:(id)imageObj
{
}
- (void)uploadUserShopMessage
{
    YTShop* shop = [YTUsr usr].shop;
    self.requestParas = @{ @"name" : [NSStrUtil makeBlank:shop.name],
        @"catId" : [NSStrUtil makeBlank:[YTUsr usr].shopCategory.categoryId],
        @"startTime" : [NSStrUtil makeBlank:shop.startTime],
        @"endTime" : [NSStrUtil makeBlank:shop.endTime],
        @"openDays" : [NSStrUtil makeBlank:shop.openDays],
        @"parkingSpace" : @(shop.parkingSpace),
        @"tel" : [NSStrUtil makeBlank:shop.mobile],
        @"custFee" : @(shop.custFee)
    };
    self.requestURL = updateShopInfoURL;
    if ([NSStrUtil notEmptyOrNull:shop.provinceString] && [NSStrUtil notEmptyOrNull:shop.cityIdString] && [NSStrUtil notEmptyOrNull:shop.areaIdString]) {
        self.requestParas = @{ @"provinceString" : shop.provinceString,
            @"cityString" : shop.cityIdString,
            @"areaString" : shop.areaIdString };
        self.requestURL = cityMatchURL;
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userData.count;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{

    return 12;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"StoreEditCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.numberOfLines = 2;
    }
    NSDictionary* item = _userData[indexPath.row];
    cell.textLabel.text = item[@"title"];
    if (indexPath.row == 5) {
        cell.detailTextLabel.text = @"";
        NSInteger stopCarType = [item[@"detail"] integerValue];
        NSString* selectImageString = stopCarType == 0 ? @"yt_register_selectBtn_cancel.png" : @"yt_register_selectBtn_select.png";
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:selectImageString]];
    }
    else {
        cell.detailTextLabel.text = item[@"detail"];
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        if (indexPath.row == 2) {
//
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//        else {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
    }
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            YTEditAccountViewController *editAccountVC = [[YTEditAccountViewController alloc] init];
            editAccountVC.placeholder = @"请输入名称";
            editAccountVC.fieldText = [YTUsr usr].shop.name;
            [editAccountVC setCompletionWithBlock:^(NSString *resultAsString) {
                [YTUsr usr].shop.name = resultAsString;
            }];
            [self.navigationController pushViewController:editAccountVC animated:YES];
            
        } break;
        case 1: {
            [self showCityAreaPickerView];
            return;
//            YTRegisterAddressSelViewController* registerAddressSelVc = [[YTRegisterAddressSelViewController alloc] init];
//            registerAddressSelVc.delegate = self;
//            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([YTUsr usr].shop.lat, [YTUsr usr].shop.lon);
//            registerAddressSelVc.centerCoordinate = coordinate;
//            [self.navigationController pushViewController:registerAddressSelVc animated:YES];
            
        } break;
        case 2: {
            YTEditAccountViewController *editAccountVC = [[YTEditAccountViewController alloc] init];
            editAccountVC.placeholder = @"请输入详细地址";
            editAccountVC.fieldText = [YTUsr usr].shop.address;
            [editAccountVC setCompletionWithBlock:^(NSString *resultAsString) {
                [YTUsr usr].shop.address = resultAsString;
            }];
            [self.navigationController pushViewController:editAccountVC animated:YES];
            
        } break;
        case 3: {
            [self showSelectSortView];
            return;
        } break;
        case 4: {
            [self showSelectTimeView];
            return;
        } break;
        case 5: {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            NSDictionary* item = _userData[indexPath.row];
            int stopCarType = [item[@"detail"] intValue];
            int newStopCarType = stopCarType == 0 ? 1 : 0;
            NSString* selectImageString = newStopCarType == 0 ? @"yt_register_selectBtn_cancel.png" : @"yt_register_selectBtn_select.png";
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:selectImageString]];
            NSMutableDictionary* aItem = [[NSMutableDictionary alloc] initWithDictionary:item];
            [aItem setObject:@(newStopCarType) forKey:@"detail"];
            [YTUsr usr].shop.parkingSpace = newStopCarType;
            [self.userData replaceObjectAtIndex:indexPath.row withObject:aItem];
        } break;
        case 6: {
            YTEditAccountViewController *editAccountVC = [[YTEditAccountViewController alloc] init];
            editAccountVC.placeholder = @"请输入电话号码";
            editAccountVC.fieldText = [YTUsr usr].shop.mobile;
            editAccountVC.keyboardType = UIKeyboardTypePhonePad;
            [editAccountVC setCompletionWithBlock:^(NSString *resultAsString) {
                [YTUsr usr].shop.mobile = resultAsString;
            }];
            [self.navigationController pushViewController:editAccountVC animated:YES];
        } break;
        case 7: {
            //        [self pushToChangeView:EqualView indexPath:indexPath];
            YTEditAccountViewController *editAccountVC = [[YTEditAccountViewController alloc] init];
            editAccountVC.placeholder = @"请输入人均价格";
            editAccountVC.fieldText = [NSString stringWithFormat:@"%@",@([YTUsr usr].shop.custFee/100.)];
            editAccountVC.keyboardType = UIKeyboardTypeNumberPad;
            [editAccountVC setCompletionWithBlock:^(NSString *resultAsString) {
                CGFloat cutFee = [resultAsString floatValue] * 100;
                [YTUsr usr].shop.custFee = cutFee;
            }];
            [self.navigationController pushViewController:editAccountVC animated:YES];
        } break;
        case 8: {
            YTEditLicenseViewController *editLicenseVC = [[YTEditLicenseViewController alloc] init];
            [self.navigationController pushViewController:editLicenseVC animated:YES];
        } break;
            
        default:
            break;
    }
    self.didShopEdit = YES;
}
#pragma mark - ViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    //    [self.view endEditing:YES];
}
#pragma mark - imagePicker delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    self.didShopEdit = YES;
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:picker.view];
    [picker.view addSubview:hud];
    hud.labelText = @"正在处理图片...";
    __block UIImage* image = info[UIImagePickerControllerOriginalImage];
    wSelf(wSelf);
    [hud showAnimated:YES
        whileExecutingBlock:^{
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
            image = [image imageScaledWithMaxWidth:kDeviceCurrentWidth];
        }
        completionBlock:^{
            __strong __typeof(wSelf) strongSelf = wSelf;
            [hud removeFromSuperview];
            if (picker == _storeImagePicker) {
                strongSelf.storeImage = image;
                [strongSelf uploadShopMasterImage];
            }
            else {
                [_milieuImageArray addObject:image];
                [strongSelf showMilieuImages:_milieuImageArray.count - 1];
                [strongSelf uploadShopHjImageWithLastIndex:1];
            }
            [picker dismissViewControllerAnimated:YES
                                       completion:^{
                                       }];
        }];
}
#pragma mark - assets Picker Delegate
- (BOOL)assetsPickerController:(CTAssetsPickerController*)picker isDefaultAssetsGroup:(ALAssetsGroup*)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController*)picker didFinishPickingAssets:(NSArray*)assets
{
    self.didShopEdit = YES;
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:picker.view];
    [picker.view addSubview:hud];
    hud.labelText = @"正在处理图片...";
    __block NSMutableArray* images = self.milieuImageArray;
    [hud showAnimated:YES
        whileExecutingBlock:^{
            for (ALAsset* asset in assets) {
                UIImage* image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                image = [image imageScaledWithMaxWidth:kDeviceCurrentWidth];
                [images addObject:image];
            }
        }
        completionBlock:^{
            [hud removeFromSuperview];
            [picker.presentingViewController dismissViewControllerAnimated:YES
                                                                completion:^{
                                                                    [self showMilieuImages:images.count - assets.count];
                                                                    [self uploadShopHjImageWithLastIndex:assets.count];
                                                                }];
        }];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController*)picker shouldEnableAsset:(ALAsset*)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController*)picker shouldSelectAsset:(ALAsset*)asset
{
    NSInteger count = kMaxMilieuImageCount - _milieuImageArray.count;
    if (picker.selectedAssets.count >= count) {
        [self showAlert:[NSString stringWithFormat:@"您最多只能选择%@张图片", @(count)] title:@""];
    }

    if (!asset.defaultRepresentation) {
        [self showAlert:@"Your asset has not yet been downloaded to your device" title:@""];
    }

    return (picker.selectedAssets.count < count && asset.defaultRepresentation != nil);
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser*)photoBrowser
{
    return _photos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser*)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _photos.count) {
        return _photos[index];
    }
    return nil;
}
- (void)photoBrowser:(MWPhotoBrowser*)photoBrowser deletePhotoAtIndex:(NSUInteger)index
{
    if (_photos[index] == [NSNull null]) {
        return;
    }
    id imageObj = _milieuImageArray[index];
    if ([imageObj isKindOfClass:[YTImage class]]) {
        YTImage* ytImage = (YTImage*)imageObj;
        self.requestParas = @{@"ids[0]" : ytImage.imageId};
        self.requestURL = deleteHJImgURL;
    }
    [_photos removeObjectAtIndex:index];
    [_milieuImageArray removeObjectAtIndex:index];
    [self updateShopHjImages];
    if (_photos.count > 0) {
        [photoBrowser reloadData];
    }
    else {
        [photoBrowser.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -YTRegisterAddressSelViewControllerDelegate
- (void)registerAddressSelViewController:(YTRegisterAddressSelViewController*)viewController didSelectPoi:(AMapPOI*)mapPoi
{
//    self.mapPoi = mapPoi;
//    [YTUsr usr].shop.address = mapPoi.address;
//    [YTUsr usr].shop.lat = mapPoi.location.latitude;
//    [YTUsr usr].shop.lon = mapPoi.location.longitude;
}
#pragma mark - UISheetViewDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kStoreSheetTag) {
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
        }
        else {
            if (buttonIndex == 0) {
                self.storeImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            else {
                return;
            }
        }
        [self presentViewController:self.storeImagePicker
                           animated:YES
                         completion:^{
                         }];
    }
    else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

            switch (buttonIndex) {
            case 0: {
                [self presentViewController:self.milieuImagePicker
                                   animated:YES
                                 completion:^{
                                 }];
            } break;
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
- (void)tapMilieuImage:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];

    NSMutableArray* photos = [NSMutableArray arrayWithCapacity:_milieuImageArray.count];
    for (id imageObj in _milieuImageArray) {
        MWPhoto* photo;
        if ([imageObj isKindOfClass:[YTImage class]]) {
            YTImage* ytImage = (YTImage*)imageObj;
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:ytImage.img]];
            [photos addObject:photo];
        }
        else if ([imageObj isKindOfClass:[UIImage class]]) {
            UIImage* image = (UIImage*)imageObj;
            photo = [MWPhoto photoWithImage:image];
            [photos addObject:photo];
        }
        else {
        }
    }
    self.photos = photos;
//    MWPhotoBrowser* photoBrower = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    photoBrower.displayActionButton = NO;
//    photoBrower.currentPhotoIndex = tap.view.tag - kMilieuImageTag;
//    [self.navigationController pushViewController:photoBrower animated:YES];

    RGPototViewController* browser = [[RGPototViewController alloc] initWithDelegate:self];
    browser.currentPhotoIndex = tap.view.tag - kMilieuImageTag;
    [self.navigationController pushViewController:browser animated:YES];
}
#pragma mark - Private methods
- (void)updateShopData
{
    [self.storeImageView sd_setImageWithURL:[NSURL URLWithString:[YTUsr usr].shop.img] placeholderImage:CCImageNamed(@"yt_register_photoimage.png")];
    self.milieuImageArray = [[NSMutableArray alloc] initWithArray:[YTUsr usr].hjImg];
    [self updateUserShopMessage];
}
- (void)updateShopHjImages
{
    for (UIView* view in _milieuImageViews) {
        [view removeFromSuperview];
    }
    [_milieuImageViews removeAllObjects];
    [self showMilieuImages:0];
}
- (void)showCityAreaPickerView
{
    if (!_areaPickerView) {
        _areaPickerView = [[YTCityAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
        [self.view addSubview:_areaPickerView];
    }
    wSelf(wSelf);
     _areaPickerView.areaDidChangeBlock = ^(YTLocation *locate){
         if (!wSelf) {
             return ;
         }
         __strong typeof(wSelf) sSelf = wSelf;
         [YTUsr usr].shop.cityIdString = locate.city;
         [YTUsr usr].shop.areaIdString = locate.district;
         sSelf.didShopEdit = YES;
         [sSelf updateUserShopMessage];
         [sSelf.tableView reloadData];
     };
    [_areaPickerView showAreaPickerView];

}
- (void)showSelectTimeView
{
    if (!_selectTimeView) {
        _selectTimeView = [[RGSelectTimeView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_selectTimeView];
    }
     wSelf(wSelf);
    _selectTimeView.opendaysBlock = ^(NSString *opendayStr) {
        [YTUsr usr].shop.openDays = [NSStrUtil makeOpendaysNumberWithDays:opendayStr];
        if (!wSelf) {
            return ;
        }
        __strong typeof(wSelf) sSelf = wSelf;
        sSelf.didShopEdit = YES;
        [sSelf updateUserShopMessage];
        [sSelf.tableView reloadData];
    };
    _selectTimeView.opentimeBlock = ^(BOOL isOpen,NSString *timeStr) {
        if (isOpen) {
            [YTUsr usr].shop.startTime = timeStr;
        } else {
            [YTUsr usr].shop.endTime = timeStr;
        }
        if (!wSelf) {
            return ;
        }
         __strong typeof(wSelf) sSelf = wSelf;
        sSelf.didShopEdit = YES;
        [sSelf updateUserShopMessage];
        [sSelf.tableView reloadData];
    };

    [_selectTimeView showSelectTimeView];
}
- (void)showSelectSortView
{
    //    if (!_selectSortView) {
    //        _selectSortView = [[RGSelectSortView alloc] initWithFrame:self.view.bounds];
    //        [self.view addSubview:_selectSortView];
    //    }
    [_selectSortView showSelectSortView];
}
- (void)showMilieuImages:(NSInteger)count
{
    if (_selectMilieuBtn) {
        [_selectMilieuBtn removeFromSuperview];
    }
    for (NSInteger i = count; i < _milieuImageArray.count; i++) {
        CGFloat imageX = i * (kMilieuImageWidth + 10) + kDefaultPadding;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 0, kMilieuImageWidth, kMilieuImageWidth)];
        imageView.tag = kMilieuImageTag + i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMilieuImage:)]];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        id imageObj = _milieuImageArray[i];
        if ([imageObj isKindOfClass:[UIImage class]]) {
            imageView.image = (UIImage*)imageObj;
        }
        else if ([imageObj isKindOfClass:[YTImage class]]) {
            YTImage* ytImage = (YTImage*)imageObj;
            [imageView sd_setImageWithURL:[NSURL URLWithString:ytImage.img] placeholderImage:YTNormalPlaceImage];
        }
        else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageObj] placeholderImage:YTNormalPlaceImage];
        }
        [_milieuScrollView addSubview:imageView];
        [_milieuImageViews addObject:imageView];
    }
    if (_milieuImageArray.count < kMaxMilieuImageCount) {
        [self addselectPhotoButton];
        CGFloat Width = (kMilieuImageWidth + 10) * (_milieuImageArray.count + 1) + kDefaultPadding;
        _milieuScrollView.contentSize = CGSizeMake(Width, 0);
    }
    else {
        CGFloat Width = (kMilieuImageWidth + 10) * _milieuImageArray.count + kDefaultPadding;
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
    UIActionSheet* sheet;
    // 判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = tag;
    [sheet showInView:self.view];
}
- (void)presentToAssetsPickerController
{
    CTAssetsPickerController* picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.delegate = self;
    picker.title = NSLocalizedString(@"相册", @"picker controller");
    picker.selectedAssets = [[NSMutableArray alloc] init];
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - Navigation
- (void)leftDrawerButtonPress:(id)sender
{
    if (self.didShopEdit && !self.didShopUpdate) {
        [self uploadUserShopMessage];
    }
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (void)rightDrawerButtonPress:(id)sender
{
    [MBProgressHUD showMessag:@"请稍后..." toView:self.view];
    [self uploadUserShopMessage];
}
#pragma mark - Page subviews
- (void)initializeData
{
    self.userData = [[NSMutableArray alloc] init];
    self.milieuImageArray = [[NSMutableArray alloc] initWithCapacity:kMaxMilieuImageCount];
    self.milieuImageViews = [[NSMutableArray alloc] initWithCapacity:kMaxMilieuImageCount];
    [self updateShopData];
    [self reqCategoryData];
}

- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    [self.headView addSubview:self.storeImageView];
    [self setupStoreButton];
    [self.headView addSubview:self.milieuScrollView];
    [self showMilieuImages:0];
    [self.view addSubview:self.selectSortView];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    wSelf(wSelf);
    _selectSortView.selectedCategoryBlock = ^(YTCategory* catgory) {
        if (!wSelf) {
            return;
        }
        __strong typeof(wSelf) sSelf = wSelf;
        [YTUsr usr].shopCategory = catgory;
        sSelf.didShopEdit = YES;
        [sSelf updateUserShopMessage];
        [sSelf.tableView reloadData];
    };
}
- (void)setupStoreButton
{
    UIButton* storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [storeBtn setBackgroundImage:[UIImage imageNamed:@"yt_register_uploadImage.png"] forState:UIControlStateNormal];
    [storeBtn addTarget:self action:@selector(addStorePhoto:) forControlEvents:UIControlEventTouchUpInside];
    storeBtn.frame = CGRectMake(0, _storeImageView.frame.origin.y + 55, 45, 45);
    storeBtn.center = CGPointMake(_storeImageView.center.x, storeBtn.center.y);
    [self.headView addSubview:storeBtn];

    UILabel* storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, storeBtn.frame.origin.y + 60, CGRectGetWidth(_storeImageView.bounds), 25)];
    storeLabel.font = [UIFont systemFontOfSize:20];
    storeLabel.textColor = [UIColor whiteColor];
    storeLabel.text = @"添加店面照片";
    storeLabel.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:storeLabel];

    UILabel* milieuLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultPadding, _storeImageView.frame.origin.y + CGRectGetHeight(_storeImageView.bounds) + 10, CGRectGetWidth(_storeImageView.bounds), 15)];
    milieuLabel.font = [UIFont systemFontOfSize:14];
    milieuLabel.textColor = [UIColor grayColor];
    milieuLabel.text = @"环境图";
    [self.headView addSubview:milieuLabel];
}

#pragma mark - Getters & Setters
- (void)setDidShopEdit:(BOOL)didShopEdit
{
    _didShopEdit = didShopEdit;
    _didShopUpdate = NO;
    self.navigationItem.rightBarButtonItem.enabled = didShopEdit;
}
- (void)setStoreImage:(UIImage*)storeImage
{
    _storeImage = storeImage;
    self.storeImageView.image = storeImage;
}
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight - kNavigationFullHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
    }
    return _tableView;
}
- (UIView*)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 320)];
        _headView.clipsToBounds = YES;
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}
- (UIImageView*)storeImageView
{
    if (!_storeImageView) {
        _storeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kStoreHeight)];
        _storeImageView.clipsToBounds = YES;
        _storeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _storeImageView.image = CCImageNamed(@"yt_register_photoimage.png");
    }
    return _storeImageView;
}
- (RGSelectSortView*)selectSortView
{
    if (!_selectSortView) {
        _selectSortView = [[RGSelectSortView alloc] initWithFrame:self.view.bounds];
        _selectSortView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _selectSortView;
}
- (UIScrollView*)milieuScrollView
{
    if (!_milieuScrollView) {
        _milieuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kStoreHeight + 35, CGRectGetWidth(self.view.bounds), kMilieuHeight)];
    }
    return _milieuScrollView;
}
- (UIImagePickerController*)milieuImagePicker
{
    if (!_milieuImagePicker) {
        _milieuImagePicker = [[UIImagePickerController alloc] init];
        _milieuImagePicker.delegate = self;
        _milieuImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    return _milieuImagePicker;
}
- (UIImagePickerController*)storeImagePicker
{
    if (!_storeImagePicker) {
        _storeImagePicker = [[UIImagePickerController alloc] init];
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
