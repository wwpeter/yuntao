
#import "TopRedView.h"
#import "RGTextCodeView.h"
#import "UIImage+HBClass.h"
#import "YTRegisterHelper.h"
#import "MBProgressHUD+Add.h"
#import "BusinessRegisterSecondViewController.h"
#import "RegisterInfomationTableCell.h"
#import "YTHttpClient.h"
#import "UIViewController+Helper.h"
#import "YTUploadPicModel.h"
#import "YTYellowBackgroundView.h"

static NSString* CellIdentifier = @"BusinessRegisterSecondViewIdentifier";
static const NSInteger kPhotoPickerTag = 1000;

@interface BusinessRegisterSecondViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIImagePickerController* imagePicker;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) YTYellowBackgroundView* yellowBgView;
@property (copy, nonatomic) NSArray* informationTexts;
@property (copy, nonatomic) NSMutableArray* informationImages;

@property (assign, nonatomic) BOOL isImageLoading;

@end

@implementation BusinessRegisterSecondViewController

#pragma mark - Life cycle
- (id)init
{
    if ((self = [super init])) {
        self.navigationItem.title = @"注册3/3";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"Done") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializeData];
    [self initializePageSubviews];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (![self.navigationController.viewControllers containsObject:self]) {
        [YTRegisterHelper registerHelper].imgLicense = @"";
        [YTRegisterHelper registerHelper].imgIdCardFront = @"";
        [YTRegisterHelper registerHelper].imgIdCardBack = @"";
        [YTRegisterHelper registerHelper].imgShopFront = @"";
        [YTRegisterHelper registerHelper].imgShopInside = @"";
        [YTRegisterHelper registerHelper].imgDoorNo = @"";
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:registerNewURL]) {
            [[YTRegisterHelper registerHelper] cleanRegisterData];
            [self dismissViewControllerAnimated:YES
                                     completion:^{
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotification
                                                                                             object:nil];
                                     }];
        }
    }
    else {
        [self showAlert:parserObject.message title:@""];
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.informationTexts.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    RegisterInfomationTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.photoText = self.informationTexts[indexPath.section];
    cell.photoImage = self.informationImages[indexPath.section];

    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];

    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIActionSheet* sheet;
    // 判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = kPhotoPickerTag + indexPath.section;
    [sheet showInView:self.view];
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

    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:picker.view];
    hud.labelText = @"正在处理图片...";
    [picker.view addSubview:hud];
    NSInteger imageIndex = picker.view.tag - kPhotoPickerTag;
    __weak __typeof(self) weakSelf = self;
    __block UIImage* image = info[UIImagePickerControllerOriginalImage];
    [hud showAnimated:YES
        whileExecutingBlock:^{
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
            image = [image imageScaledWithMaxWidth:kDeviceCurrentWidth];
        }
        completionBlock:^{
            [hud removeFromSuperview];
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf uploadPhotoImage:image imageIndex:imageIndex];
            [picker dismissViewControllerAnimated:YES completion:NULL];
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
    self.imagePicker.view.tag = actionSheet.tag;
    [self presentViewController:self.imagePicker
                       animated:YES
                     completion:^{
                     }];
}

#pragma mark - Event response
#pragma mark - Private methods
- (void)uploadPhotoImage:(UIImage*)image imageIndex:(NSInteger)index
{
    self.isImageLoading = YES;
    [MBProgressHUD showMessag:@"" toView:self.view];
    [self.informationImages replaceObjectAtIndex:index withObject:image];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    __weak __typeof(self) weakSelf = self;
    [[YTHttpClient client] requestMultipartWithURL:registerUploadPicURL
        parameters:@{}
        Image:image
        success:^(AFHTTPRequestOperation* operation, NSObject* parserObject) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            strongSelf.isImageLoading = NO;
            YTUploadPicModel* picModel = (YTUploadPicModel*)parserObject;
            [strongSelf uploadRegisterPic:picModel index:index];
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* requestErr) {
            weakSelf.isImageLoading = NO;
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [MBProgressHUD showError:@"连接失败" toView:weakSelf.view];
        }];
}
- (void)uploadRegisterPic:(YTUploadPicModel*)picModel index:(NSInteger)index
{
    if (!picModel.success) {
        [MBProgressHUD showError:picModel.message toView:self.view];
        return;
    }
    if (index == 0) {
        [YTRegisterHelper registerHelper].imgLicense = picModel.url;
    }
    else if (index == 1) {
        [YTRegisterHelper registerHelper].imgIdCardFront = picModel.url;
    }
    else if (index == 2) {
        [YTRegisterHelper registerHelper].imgIdCardBack = picModel.url;
    }
    else if (index == 3) {
        [YTRegisterHelper registerHelper].imgShopFront = picModel.url;
    }
    else if (index == 4) {
        [YTRegisterHelper registerHelper].imgShopInside = picModel.url;
    }
    else if (index == 5) {
        [YTRegisterHelper registerHelper].imgDoorNo = picModel.url;
    }
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self.view endEditing:YES];
    BOOL isValid = [[YTRegisterHelper registerHelper] checkValidateWithStepIndex:1];
    if (!isValid) {
        return;
    }
    if (self.isImageLoading) {
        [self showAlert:@"图片正在上传,请稍后" title:@""];
        return;
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSMutableDictionary* reqParas = [NSMutableDictionary dictionary];
    YTRegisterHelper* registerHelper = [YTRegisterHelper registerHelper];
    if ([NSStrUtil notEmptyOrNull:registerHelper.tel]) {
        [reqParas setObject:registerHelper.tel forKey:@"tel"];
    }
    if ([NSStrUtil notEmptyOrNull:registerHelper.endTime]) {
        [reqParas setObject:registerHelper.endTime forKey:@"endTime"];
    }
    if ([NSStrUtil notEmptyOrNull:registerHelper.startTime]) {
        [reqParas setObject:registerHelper.startTime forKey:@"startTime"];
    }
    if ([NSStrUtil notEmptyOrNull:registerHelper.legalPerson]) {
        [reqParas setObject:registerHelper.legalPerson forKey:@"legalPerson"];
    }
    if ([NSStrUtil notEmptyOrNull:registerHelper.imgIdCardFront]) {
        [reqParas setObject:registerHelper.imgIdCardFront forKey:@"imgIdCardFront"];
    }
    if ([NSStrUtil notEmptyOrNull:registerHelper.imgIdCardBack]) {
        [reqParas setObject:registerHelper.imgIdCardBack forKey:@"imgIdCardBack"];
    }
    if ([NSStrUtil notEmptyOrNull:registerHelper.imgShopFront]) {
        [reqParas setObject:registerHelper.imgShopFront forKey:@"imgShopFront"];
    }
    if ([NSStrUtil notEmptyOrNull:registerHelper.imgShopInside]) {
        [reqParas setObject:registerHelper.imgShopInside forKey:@"imgShopInside"];
    }
    if ([NSStrUtil notEmptyOrNull:registerHelper.imgDoorNo]) {
        [reqParas setObject:registerHelper.imgDoorNo forKey:@"imgDoorNo"];
    }
    if ([NSStrUtil notEmptyOrNull:registerHelper.upAddress]) {
        [reqParas setObject:registerHelper.upAddress forKey:@"upAddress"];
    }

    NSString* openDays = [NSStrUtil makeOpendaysNumberWithDays:registerHelper.openDays];
    [reqParas setObject:openDays forKey:@"openDays"];
    [reqParas setObject:registerHelper.name forKey:@"name"];
    [reqParas setObject:@(registerHelper.lat) forKey:@"lat"];
    [reqParas setObject:@(registerHelper.lon) forKey:@"lon"];
    [reqParas setObject:registerHelper.catId forKey:@"catId"];
    [reqParas setObject:registerHelper.mobile forKey:@"mobile"];
    [reqParas setObject:registerHelper.address forKey:@"address"];
    [reqParas setObject:@(registerHelper.zoneId) forKey:@"zoneId"];
    [reqParas setObject:[NSStrUtil ytLoginMD5WithPhoneNumber:registerHelper.mobile password:registerHelper.password] forKey:@"password"];
    [reqParas setObject:registerHelper.checkCode forKey:@"checkCode"];
    [reqParas setObject:@(registerHelper.custFee * 100) forKey:@"custFee"];
    [reqParas setObject:@(registerHelper.parkingSpace) forKey:@"parkingSpace"];
    [reqParas setObject:registerHelper.imgLicense forKey:@"imgLicense"];

    NSMutableArray* postDataArr = [NSMutableArray array];
    if (registerHelper.masterImg) {
        [postDataArr addObject:@{ @"masterImg" : registerHelper.masterImg }];
    }
    if (registerHelper.hjImgArr) {
        NSMutableArray* imageArr = [[NSMutableArray alloc] init];
        for (UIImage* image in registerHelper.hjImgArr) {
            NSData* imageDate = UIImageJPEGRepresentation(image, 0.5);
            [imageArr addObject:imageDate];
        }
        [postDataArr addObject:@{ @"hjImg" : imageArr }];
    }
    [reqParas setObject:postDataArr forKey:postingDataKey];
    [reqParas setObject:@(YES) forKey:loadingKey];
    self.requestParas = [NSDictionary dictionaryWithDictionary:reqParas];

    self.requestURL = registerNewURL;
}

#pragma mark - Page subviews
- (void)initializeData
{
    self.isImageLoading = NO;
    self.informationTexts = @[ @"上传营业执照", @"上传法人身份证正面", @"上传法人身份证反面", @"上传门店正面", @"上传门店内景", @"上传门牌号" ];
    NSArray* images = @[ [UIImage imageNamed:@"yt_register_information_01.png"],
        [UIImage imageNamed:@"yt_register_information_02.png"],
        [UIImage imageNamed:@"yt_register_information_03.png"],
        [UIImage imageNamed:@"yt_register_information_04.png"],
        [UIImage imageNamed:@"yt_register_information_05.png"],
        [UIImage imageNamed:@"yt_register_information_06.png"] ];
    self.informationImages = [[NSMutableArray alloc] initWithArray:images copyItems:YES];
}
- (void)initializePageSubviews
{
    TopRedView* redView = [[TopRedView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 10)];
    redView.index = 3;
    [self.view addSubview:redView];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.yellowBgView;
}
#pragma mark - Getters & Setters
- (void)setInformationImages:(NSMutableArray*)informationImages
{
    _informationImages = [informationImages mutableCopy];
}
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 10) style:UITableViewStyleGrouped];
        _tableView.rowHeight = 185;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[RegisterInfomationTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (YTYellowBackgroundView*)yellowBgView
{
    if (!_yellowBgView) {
        _yellowBgView = [[YTYellowBackgroundView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 48)];
        _yellowBgView.textLabel.numberOfLines = 0;
        _yellowBgView.textLabel.textColor = CCCUIColorFromHex(0xc3941e);
        _yellowBgView.textLabel.textAlignment = NSTextAlignmentLeft;
        _yellowBgView.textLabel.text = @"使用支付宝当面付功能需要上传以下材料,若不需要支付宝当面付功能则只需上传营业执照";
    }
    return _yellowBgView;
}
- (UIImagePickerController*)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
