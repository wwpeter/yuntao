#import "CreateHbViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "XLForm.h"
#import "CHOnlyTextCell.h"
#import "CHSelectStoreViewController.h"
#import "CHProposeCostViewController.h"
#import "CHSelectStoreCell.h"
#import "CHSelectImageCell.h"
#import "CHCostView.h"
#import "MBProgressHUD+Add.h"
#import "UIImage+HBClass.h"
#import "YTQueryShopHelper.h"
#import "UIViewController+Helper.h"
#import "UIImage+HBClass.h"

NSString* const kHbImage = @"hbImage";
NSString* const kHbName = @"hbName";
NSString* const kHbNumber = @"hbNumber";
NSString* const kHbPrice = @"hbPrice";
NSString* const kHbStartTime = @"hbStartTime";
NSString* const kHbEndTime = @"hbEndTime";
NSString* const kHbDescribe = @"hbDescribe";
NSString* const kHbRules = @"hbRules";

NSString* const kHbBusiness = @"hbBusiness";
NSString* const kHbSelectBusiness = @"hbSelectBusiness";

@interface CreateHbViewController () <XLFormDescriptorDelegate, CHProposeCostControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) CHCostView* costView;
@property (strong, nonatomic) UIButton* doneButton;
@property (strong, nonatomic) NSMutableDictionary* hbFormValues;
@property (strong, nonatomic) UIImagePickerController* imagePicker;
@end

@implementation CreateHbViewController

#pragma mark - Life cycle
- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeForm];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}
- (void)initializeForm
{
    [[YTQueryShopHelper queryShopHelper].shopArray removeAllObjects];
    UIFont* textFont = [UIFont systemFontOfSize:14];
    UIColor *titleColor = CCCUIColorFromHex(0x666666);
    
    XLFormDescriptor* form = [XLFormDescriptor formDescriptorWithTitle:@"创建"];
    XLFormSectionDescriptor* section;
    XLFormRowDescriptor* row;

    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kHbImage rowType:XLFormRowDescriptorTypeSelectImage title:@"图片  建议使用店招图"];
    //    row.value = [[NSMutableArray alloc] init];
    row.action.formSelector = @selector(didTouchSelectImage:);
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kHbName rowType:XLFormRowDescriptorTypeText title:@"名称"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
    [row.cellConfig setObject:titleColor forKey:@"textLabel.textColor"];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    row.value = @"100元现金";
    //    if ([YTUsr usr].shop.name) {
    //        row.value = [YTUsr usr].shop.name;
    //    } else{
    //        [row.cellConfig setObject:@"" forKey:@"textField.text"];
    //    }
    //    [row.cellConfig setObject:[UIColor redColor] forKey:@"self.tintColor"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kHbNumber rowType:XLFormRowDescriptorTypeInteger title:@"个数"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
     [row.cellConfig setObject:titleColor forKey:@"textLabel.textColor"];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    [row.cellConfig setObject:@"请输入红包个数" forKey:@"textField.placeholder"];

    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kHbPrice rowType:XLFormRowDescriptorTypeInteger title:@"价值"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
     [row.cellConfig setObject:titleColor forKey:@"textLabel.textColor"];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    [row.cellConfig setObject:@"请输入红包价值(最小1元,如100元)" forKey:@"textField.placeholder"];
    [section addFormRow:row];

    // Starts
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kHbStartTime rowType:XLFormRowDescriptorTypeDate title:@"开始时间"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
     [row.cellConfig setObject:titleColor forKey:@"textLabel.textColor"];
    [row.cellConfig setObject:[NSDate new] forKey:@"datePicker.minimumDate"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24];
    [section addFormRow:row];

    // Ends
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kHbEndTime rowType:XLFormRowDescriptorTypeDate title:@"失效时间"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
     [row.cellConfig setObject:titleColor forKey:@"textLabel.textColor"];
    [row.cellConfig setObject:[NSDate new] forKey:@"datePicker.minimumDate"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 30];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kHbDescribe rowType:XLFormRowDescriptorTypeTextView title:@"概述"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
     [row.cellConfig setObject:titleColor forKey:@"textLabel.textColor"];
    [row.cellConfig setObject:textFont forKey:@"textView.font"];
//    [row.cellConfig setObject:@"如:到店免费领取中杯摩卡一杯" forKey:@"textView.placeholder"];
    row.value = @"到店免费任意领取红包价值以下商品,本店热销菜品如下:糖醋里脊15元，蛋黄鸡翅22元，酸菜鱼36元";
    [section addFormRow:row];

    // 优先投放商户
    section = [XLFormSectionDescriptor formSection];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kHbBusiness rowType:XLFormRowDescriptorTypeSelectorPush title:@"指定优先投放商户"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
    row.action.viewControllerStoryboardId = @"CHSelectStoreViewController";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kHbSelectBusiness rowType:XLFormRowDescriptorTypeSelectStore title:@"选择投放商户"];
    row.hidden = @(YES);
    row.value = [[NSMutableArray alloc] init];
    //    row.action.viewControllerClass = [CHSelectStoreViewController class];
    row.action.viewControllerStoryboardId = @"CHSelectStoreViewController";
    [section addFormRow:row];
    
    XLFormRowDescriptor* customRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:@"customText" rowType:@"XLFormRowDescriptorTypeCustom"];
    customRowDescriptor.cellClass = [CHOnlyTextCell class];
    customRowDescriptor.value = @"系统将优先投放红包到指定商户";
    [section addFormRow:customRowDescriptor];
    
    [form addFormSection:section];
    
    // 规则
    section = [XLFormSectionDescriptor formSectionWithTitle:nil
                                             sectionOptions:XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete
                                          sectionInsertMode:XLFormSectionInsertModeButton];
    section.multivaluedTag = kHbRules;
    section.multivaluedAddButton.title = @"使用规则(如:节假日通用)";
    [section.multivaluedAddButton.cellConfig setObject:textFont forKey:@"textLabel.font"];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    row.value = @"到店免费任意领取现金红包价值以下商品";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    row.value = @"大于现金红包价值消费可抵现金使用";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    row.value = @"不找零不兑现";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    row.value = @"单次消费限用一张";
    [section addFormRow:row];

    
    XLFormBaseCell *addCell = [section.multivaluedAddButton cellForFormController:self];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kDeviceWidth-80, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"yt_cell_detail_button.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cellDetailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addCell.contentView addSubview:button];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kHbRules rowType:XLFormRowDescriptorTypeTextView];
    section.multivaluedRowTemplate = row;
    [form addFormSection:section];

    section = [XLFormSectionDescriptor formSection];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"customText" rowType:@"XLFormRowDescriptorTypeCustom"];
    row.cellClass = [CHOnlyTextCell class];
    row.value = @"非免费红包会导致审核不通过";
    [section addFormRow:row];
    [form addFormSection:section];
    
    self.form = form;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoBacktarget:self action:@selector(didLeftBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializePageSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    XLFormRowDescriptor* businessDescriptor = [self.form formRowWithTag:kHbSelectBusiness];
    businessDescriptor.hidden = [YTQueryShopHelper queryShopHelper].shopArray.count > 0 ? @(NO) : @(YES);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XLFormDescriptorDelegate

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor*)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue
{
    [super formRowDescriptorValueHasChanged:rowDescriptor oldValue:oldValue newValue:newValue];
    if ([rowDescriptor.tag isEqualToString:kHbStartTime]) {
        XLFormRowDescriptor* startDateDescriptor = [self.form formRowWithTag:kHbStartTime];
        XLFormRowDescriptor* endDateDescriptor = [self.form formRowWithTag:kHbEndTime];
        if ([startDateDescriptor.value compare:endDateDescriptor.value] == NSOrderedDescending) {
            [endDateDescriptor.cellConfig setObject:startDateDescriptor.value forKey:@"datePicker.minimumDate"];
            endDateDescriptor.value = [[NSDate alloc] initWithTimeInterval:(60 * 60 * 24 * 7)sinceDate:startDateDescriptor.value];
            [endDateDescriptor.cellConfig removeObjectForKey:@"detailTextLabel.attributedText"];
            [self updateFormRow:endDateDescriptor];
        }
    }
    else if ([rowDescriptor.tag isEqualToString:kHbSelectBusiness]) {
        [self updateFormRow:rowDescriptor];
    }else if ([rowDescriptor.tag isEqualToString:kHbBusiness]){
        XLFormRowDescriptor* businessDescriptor = [self.form formRowWithTag:kHbSelectBusiness];
        businessDescriptor.value = newValue;
        [self updateFormRow:businessDescriptor];
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return CGFLOAT_MIN;
    }
    return 12;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
#pragma mark - ViewDelegetes
- (void)proposeCostController:(CHProposeCostViewController*)controller inputCost:(NSString*)cost
{
    self.costView.costLabel.text = [NSString stringWithFormat:@"￥%ld", (long)[cost integerValue]];
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
    [picker.view addSubview:hud];
    hud.labelText = @"正在处理图片...";
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
            [self updateSelectHbImage:image];
            [picker dismissViewControllerAnimated:YES
                                       completion:^{
                                       }];
        }];
}

#pragma mark - UISheetViewDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag != 1110) {
        return;
    }
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
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

#pragma mark - Event response
- (void)didTouchSelectImage:(XLFormRowDescriptor*)sender
{
    [self deselectFormRow:sender];
    UIActionSheet* sheet;
    // 判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 1110;
    [sheet showInView:self.view];
}
- (void)doneButtonClicked:(id)sender
{
    [self createHvDone];
}
- (void)cellDetailButtonClicked:(id)sender
{
    NSString *message = @"例如:\n1、到店任意消费 \n2、不找零不兑现\n3、可抵现金使用\n4、买单享受8.8折\n5、新品不参与活动";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    for (UIView *view in alert.subviews) {
        if([[view class] isSubclassOfClass:[UILabel class]]) {
            ((UILabel*)view).textAlignment = NSTextAlignmentLeft;
        }
    }
    [alert show];
}
#pragma mark - Private methods
- (void)updateSelectHbImage:(UIImage*)image
{
    XLFormRowDescriptor* imageDescriptor = [self.form formRowWithTag:kHbImage];
    imageDescriptor.value = image;
    [self updateFormRow:imageDescriptor];
}

- (void)inputProposeCost
{
    CHProposeCostViewController* costVC = [[CHProposeCostViewController alloc] init];
    costVC.delegate = self;
    [self.navigationController pushViewController:costVC animated:YES];
}

- (void)createHvDone
{
    NSString* hbNumber = [self.formValues objectForKey:kHbNumber];
    NSString* hbPrice = [self.formValues objectForKey:kHbPrice];
    NSString* hbDescribe = [self.formValues objectForKey:kHbDescribe];
    NSArray* hbRules = [self.formValues objectForKey:kHbRules];
    if ([hbNumber isEqual:[NSNull null]] || [hbPrice isEqual:[NSNull null]] || [hbDescribe isEqual:[NSNull null]]) {
        [self showAlert:@"信息尚未填写完整哦" title:@""];
        return;
    }
    if (hbRules.count == 0) {
        [self showAlert:@"请输入红包使用规则" title:@""];
        return;
    }
    NSInteger costValue = [[self.formValues objectForKey:kHbPrice] integerValue];
    NSDictionary* paras = @{ @"name" : [self.formValues objectForKey:kHbName],
        @"num" : [self.formValues objectForKey:kHbNumber],
        @"cost" : @(costValue * 100),
        @"title" : [self.formValues objectForKey:kHbDescribe],
        @"endTime" : @((long long)([[self.formValues objectForKey:kHbEndTime] timeIntervalSince1970] * 1000)),
        @"startTime" : @((long long)([[self.formValues objectForKey:kHbStartTime] timeIntervalSince1970] * 1000)) };
    NSMutableDictionary* requestParas = [NSMutableDictionary dictionaryWithDictionary:paras];
    UIImage* hbImage = [self.formValues objectForKey:kHbImage];
    if (![hbImage isEqual:[NSNull null]]) {
        [requestParas setObject:@[ UIImageJPEGRepresentation(hbImage, 0.5) ] forKey:postingDataKey];
    }

    NSArray* rulesArr = [self.formValues objectForKey:kHbRules];
    for (int i = 0; i < rulesArr.count; i++) {
        NSString* ruleDesc = [rulesArr objectAtIndex:i];
        [requestParas setObject:ruleDesc forKey:[NSString stringWithFormat:@"hongbaoRule[0].descs[%d]", i]];
    }
    NSArray* selectShops = [self.formValues objectForKey:kHbSelectBusiness];
    if (selectShops.count > 0) {
        for (int i = 0; i < selectShops.count; i++) {
            YTShop* shop = selectShops[i];
            NSString* shopKey = [NSString stringWithFormat:@"toShopIds[%@]]", @(i)];
            [requestParas setObject:shop.shopId forKey:shopKey];
        }
    }
    [requestParas setObject:@(YES) forKey:loadingKey];
    self.requestParas = requestParas;
    self.requestURL = createHongbaoURL;
}
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (parserObject.success) {
        if (self.successBlock) {
            self.successBlock();
        }
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     [[YTQueryShopHelper queryShopHelper].shopArray removeAllObjects];
                                 }];
    }
    else {
        [self showAlert:parserObject.message title:@""];
    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    //    _costView = [[CHCostView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-50-kNavigationFullHeight, CGRectGetWidth(self.view.bounds), 50)];
    //    [self.view addSubview:_costView];
    //    __weak __typeof(self) weakSelf = self;
    //    _costView.selectBlock = ^(NSInteger selectIndex) {
    //        if (selectIndex == 1) {
    //            [weakSelf inputProposeCost];
    //        } else {
    //            [weakSelf createHvDone];
    //        }
    //    };
//    XLFormSectionDescriptor *section = [self.form formSectionAtIndex:2];
//    XLFormBaseCell *addCell = [section.multivaluedAddButton cellForFormController:self];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 44, 44);
//    button.backgroundColor = [UIColor redColor];
//    [addCell.contentView addSubview:button];
    [self.view addSubview:self.doneButton];
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 50);
}
#pragma mark - Navigation
- (void)didLeftBarButtonItemAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didRightBarButtonItemAction:(id)sender
{
    [self createHvDone];
}

#pragma mark - Getters & Setters
- (UIImagePickerController*)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
- (UIButton*)doneButton
{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 50 - kNavigationFullHeight, CGRectGetWidth(self.view.bounds), 50);
        _doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_doneButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xf9646d)] forState:UIControlStateNormal];
                [_doneButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xeb4851)] forState:UIControlStateHighlighted];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
