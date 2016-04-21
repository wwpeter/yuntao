//
//  BusinessRegisterViewController.m
//  YT_business
//
//  Created by chun.chen on 15/6/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "MBProgressHUD.h"
#import "YTCategoryModel.h"
#import "UIImage+HBClass.h"
#import "RGSelectSortView.h"
#import "YTRegisterHelper.h"
#import "RGSelectTimeView.h"
#import "CTAssetsPickerController.h"
#import "BusinessRegisterViewController.h"
#import "YTRegisterAddressSelViewController.h"
#import "BusinessRegisterThirdViewController.h"
#import "UIImage+HBClass.h"
#import "YTCityAreaPickerView.h"

#define kMaxMilieuImageCount 9

@interface BusinessRegisterViewController () <UITableViewDelegate,
    UITableViewDataSource,
    UIActionSheetDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    CTAssetsPickerControllerDelegate,
    YTRegisterAddressSelViewControllerDelegate> {
    NSArray* renderArr;
    BOOL selectFromMasterImage;
    YTCategoryModel* categoryModel;
    NSMutableArray* selectEnvironmentArr;

    RGSelectTimeView* timeSelView;
    RGSelectSortView* sortSelView;
    YTCityAreaPickerView *cityPickerView;
    UITableView* registerTableView;
    UIImagePickerController* imagePicker;
}
@end

@implementation BusinessRegisterViewController
static NSMutableParagraphStyle* paragraphStyle;
+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Data prepare
    selectEnvironmentArr = [NSMutableArray array];
    renderArr = @[ @[ @"名称",@"请选择小区/写字楼/学校等", @"补充详细地址", @"分类" ], @[ @"选填", @"营业时间", @"停车位", @"电话", @"人均",@"", @"环境图" ] ];
//            [YTRegisterHelper registerHelper].lat = self.selectPoi.location.latitude;
//            [YTRegisterHelper registerHelper].lon = self.selectPoi.location.longitude;

    [self configureUIComponents];
    [self reqCategoryData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -configureUIComponents
- (void)configureUIComponents
{

    self.showBackBtn = YES;
    self.navigationItem.title = @"注册1/3";

    wSelf(wSelf);
    [self actionCustomRightBtnWithNrlImage:@""
                                  htlImage:@""
                                     title:@"下一步"
                                    action:^{
                                        if (!wSelf) {
                                            return;
                                        }
                                        BOOL isValid = [[YTRegisterHelper registerHelper] checkValidateWithStepIndex:0];
                                        if (isValid) {
                                            BusinessRegisterThirdViewController* registerThirdVc = [[BusinessRegisterThirdViewController alloc] init];
                                            [wSelf.navigationController pushViewController:registerThirdVc animated:YES];
                                        }
                                    }];

    // registerProgressImageView
    UIImageView* registerProgressImageView = [[UIImageView alloc] init];
    registerProgressImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 10);

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.bounds), 10), YES, [UIScreen mainScreen].scale);
    CGContextRef drawContext = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(drawContext, CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 10));
    [[UIColor redColor] setFill];
    CGContextFillRect(drawContext, CGRectMake(0, 0, (CGRectGetWidth(self.view.bounds) - 6) / 3, 10));
    [[UIColor hexFloatColor:@"c8c8c8"] setFill];
    CGContextFillRect(drawContext, CGRectMake((CGRectGetWidth(self.view.bounds) - 6) / 3 + 3, 0, (CGRectGetWidth(self.view.bounds) - 10) / 3, 10));
    CGContextFillRect(drawContext, CGRectMake((CGRectGetWidth(self.view.bounds) - 6) / 3 * 2 + 6, 0, (CGRectGetWidth(self.view.bounds) - 10) / 3, 10));
    registerProgressImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // registerTableView
    registerTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    registerTableView.delegate = self;
    registerTableView.dataSource = self;
    registerTableView.tableHeaderView = registerProgressImageView;
    registerTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    registerTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:registerTableView];

    // imagePicker
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;

    // timeSelView
    timeSelView = [[RGSelectTimeView alloc] initWithFrame:self.view.bounds];
    timeSelView.opendaysBlock = ^(NSString* opendayStr) {
        [YTRegisterHelper registerHelper].openDays = opendayStr;
        if (!wSelf) {
            return;
        }
        __strong typeof(wSelf) sSelf = wSelf;
        [sSelf->registerTableView reloadData];
    };
    timeSelView.opentimeBlock = ^(BOOL isOpen, NSString* timeStr) {
        if (isOpen) {
            [YTRegisterHelper registerHelper].startTime = timeStr;
        }
        else {
            [YTRegisterHelper registerHelper].endTime = timeStr;
        }
        if (!wSelf) {
            return;
        }
        __strong typeof(wSelf) sSelf = wSelf;
        [sSelf->registerTableView reloadData];
    };
    timeSelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:timeSelView];

    // sortSelView
    sortSelView = [[RGSelectSortView alloc] initWithFrame:self.view.bounds];
    sortSelView.selectedCategoryBlock = ^(YTCategory* catgory) {
        if (!wSelf) {
            return;
        }
        __strong typeof(wSelf) sSelf = wSelf;
        [sSelf->registerTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:3 inSection:0] ] withRowAnimation:UITableViewRowAnimationNone];
    };
    sortSelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:sortSelView];
    
    cityPickerView = [[YTCityAreaPickerView alloc] initWithFrame:self.view.bounds];
    cityPickerView.areaDidChangeBlock = ^(YTLocation *locate){
        if (!wSelf) {
            return;
        }
        __strong typeof(wSelf) sSelf = wSelf;
        [YTRegisterHelper registerHelper].province = locate.state;
        [YTRegisterHelper registerHelper].city = locate.city;
        [YTRegisterHelper registerHelper].district = locate.district;
        [YTRegisterHelper registerHelper].zoneId = locate.zoneId;
         [sSelf->registerTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:1 inSection:0] ] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.view addSubview:cityPickerView];
}

#pragma mark -reqCategoryData
- (void)reqCategoryData
{
    self.requestURL = getShopCategoryURL;
}

#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (parserObject.success) {
        categoryModel = (YTCategoryModel*)parserObject;
        sortSelView.categoryModel = categoryModel;
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return renderArr.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    NSArray* sectionArr = [renderArr objectAtIndex:section];
    return [YTRegisterHelper registerHelper].showStretchOption ? sectionArr.count : 1;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    if (section == 0) {
        NSArray* sectionArr = [renderArr objectAtIndex:section];
        if (row == 2) {
            static NSString* addressCellIdentifier = @"addressCell";
            UITableViewCell* addressCell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
            if (!addressCell) {
                addressCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressCellIdentifier];
                addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIView *yellowBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 45)];
                yellowBackView.backgroundColor = [UIColor hexFloatColor:@"fff7d8"];
                [addressCell addSubview:yellowBackView];
                
                UILabel* messageLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, CGRectGetWidth(self.view.bounds)-30, 44)];
                messageLab.numberOfLines = 2;
                messageLab.font = [UIFont systemFontOfSize:14];
                messageLab.textColor = [UIColor hexFloatColor:@"df4248"];
                messageLab.text = @"提示:商户信息必须在门店添加,若不在门店,必须在添加完成后联系客服确认店铺位置信息";
                [yellowBackView addSubview:messageLab];
                
                UITextField* inputTextField = [[UITextField alloc] init];
                [inputTextField addTarget:self action:@selector(setRegisterInfo:) forControlEvents:UIControlEventEditingChanged];
                inputTextField.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 260, 45, 245, 44);
                inputTextField.keyboardType = UIKeyboardTypeDefault;
                inputTextField.textColor = [UIColor hexFloatColor:@"242424"];
                inputTextField.textAlignment = NSTextAlignmentRight;
                inputTextField.font = [UIFont systemFontOfSize:14];
                inputTextField.tag = 200;
                [addressCell addSubview:inputTextField];
                
                UILabel* titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 100, 44)];
                titleLab.tag = 201;
                titleLab.font = [UIFont systemFontOfSize:14];
                titleLab.textAlignment = NSTextAlignmentLeft;
                [addressCell addSubview:titleLab];
            }
            
            UILabel* titleLab = (UILabel*)[addressCell viewWithTag:201];
            UITextField* inputTextField = (UITextField*)[addressCell viewWithTag:200];
            titleLab.text = [sectionArr objectAtIndex:row];
            inputTextField.placeholder = @"如:门牌号/楼层等";
            return addressCell;
        }
        
        static NSString* baseInfoCellIdentifier = @"baseInfoCell";
        UITableViewCell* baseInfoCell = [tableView dequeueReusableCellWithIdentifier:baseInfoCellIdentifier];
        if (!baseInfoCell) {
            baseInfoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseInfoCellIdentifier];
            baseInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;

            // configure UI Property
            UITextField* inputTextField = [[UITextField alloc] init];
            [inputTextField addTarget:self action:@selector(setRegisterInfo:) forControlEvents:UIControlEventEditingChanged];
            inputTextField.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 260, 0, 245, 44);
            inputTextField.keyboardType = UIKeyboardTypeDefault;
            inputTextField.textColor = [UIColor hexFloatColor:@"242424"];
            inputTextField.textAlignment = NSTextAlignmentRight;
            inputTextField.font = [UIFont systemFontOfSize:14];
            inputTextField.tag = 100;
            [baseInfoCell addSubview:inputTextField];

            UILabel* valueLab = [[UILabel alloc] init];
            valueLab.tag = 101;
            valueLab.font = [UIFont systemFontOfSize:14];
            valueLab.textAlignment = NSTextAlignmentRight;
            [baseInfoCell addSubview:valueLab];

            baseInfoCell.textLabel.textColor = [UIColor hexFloatColor:@"242424"];
            baseInfoCell.textLabel.font = [UIFont systemFontOfSize:14];

            [valueLab mas_makeConstraints:^(MASConstraintMaker* make) {
                make.centerY.mas_equalTo(baseInfoCell);
                make.right.mas_equalTo(-30);
                make.left.mas_equalTo(180).priorityHigh();
            }];
        }
        baseInfoCell.textLabel.text = [sectionArr objectAtIndex:row];

        UILabel* valueLab = (UILabel*)[baseInfoCell viewWithTag:101];
        UITextField* inputTextField = (UITextField*)[baseInfoCell viewWithTag:100];
        if (row == 0) {
            valueLab.hidden = YES;
            inputTextField.hidden = NO;
            baseInfoCell.accessoryType = UITableViewCellAccessoryNone;
            if (row == 0) {
                inputTextField.placeholder = @"请输入完整店名,如:绿茶(城西店)";
                inputTextField.text = [YTRegisterHelper registerHelper].name;
            }
            else {
                inputTextField.placeholder = @"请输入业务员授权码";
                inputTextField.text = [YTRegisterHelper registerHelper].saleUserId;
            }
        }
        else {
            if (row == 1) {
                valueLab.textColor = [UIColor hexFloatColor:@"242424"];
                valueLab.text = [[YTRegisterHelper registerHelper] cityZone];
                if ([valueLab.text isEqualToString:@"如: 中山西路199号"]) {
                    valueLab.textColor = [UIColor lightGrayColor];
                }
            }
            else if (row == 3){
                valueLab.textColor = [UIColor hexFloatColor:@"242424"];
                valueLab.text = [YTRegisterHelper registerHelper].categoryName;
                if ([valueLab.text isEqualToString:@"请选择分类"]) {
                    valueLab.textColor = [UIColor lightGrayColor];
                }
            }
            valueLab.hidden = NO;
            inputTextField.hidden = YES;
            baseInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        return baseInfoCell;
    }
    if (row < 5) {
        static NSString* optionCellIdentifier = @"optionCell";
        UITableViewCell* optionCell = [tableView dequeueReusableCellWithIdentifier:optionCellIdentifier];
        if (!optionCell) {
            optionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:optionCellIdentifier];
            optionCell.selectionStyle = UITableViewCellSelectionStyleNone;

            // configure UI Property
            optionCell.textLabel.textColor = [UIColor hexFloatColor:@"242424"];
            optionCell.textLabel.font = [UIFont systemFontOfSize:14];

            UIImageView* arrowImageView = [[UIImageView alloc] init];
            arrowImageView.tag = 100;
            [optionCell addSubview:arrowImageView];

            UILabel* valueLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 230 - 30, 0, 230, 44)];
            valueLab.tag = 102;
            valueLab.numberOfLines = 2;
            valueLab.font = [UIFont systemFontOfSize:13];
            valueLab.textAlignment = NSTextAlignmentRight;
            [optionCell addSubview:valueLab];

            UITextField* inputTextField = [[UITextField alloc] init];
            [inputTextField addTarget:self action:@selector(setRegisterInfo:) forControlEvents:UIControlEventEditingChanged];
            inputTextField.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 260, 0, 245, 44);
            inputTextField.textColor = [UIColor hexFloatColor:@"242424"];
            inputTextField.textAlignment = NSTextAlignmentRight;
            inputTextField.font = [UIFont systemFontOfSize:14];
            inputTextField.tag = 101;
            [optionCell addSubview:inputTextField];
        }
        UIImageView* arrowImageView = (UIImageView*)[optionCell viewWithTag:100];
        UITextField* inputTextField = (UITextField*)[optionCell viewWithTag:101];
        UILabel* valueLab = (UILabel*)[optionCell viewWithTag:102];
        if (row == 0) {
            arrowImageView.hidden = NO;
            inputTextField.hidden = YES;
            valueLab.hidden = YES;
            optionCell.accessoryType = UITableViewCellAccessoryNone;
            optionCell.selectionStyle = UITableViewCellSelectionStyleGray;
            arrowImageView.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 30, 37.5 / 2, 12, 6.5);
            arrowImageView.image = [UIImage imageNamed:[YTRegisterHelper registerHelper].showStretchOption ? @"yt_register_upArrow" : @"yt_register_downArrow"];
        }
        else {
            if (row == 1) {
                arrowImageView.hidden = YES;
                inputTextField.hidden = YES;
                valueLab.text = [NSString stringWithFormat:@"%@-%@\n%@", [YTRegisterHelper registerHelper].startTime, [YTRegisterHelper registerHelper].endTime, [YTRegisterHelper registerHelper].openDays];
                optionCell.selectionStyle = UITableViewCellSelectionStyleGray;
                optionCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if (row == 2) {
                arrowImageView.hidden = NO;
                inputTextField.hidden = YES;
                inputTextField.userInteractionEnabled = NO;
                optionCell.accessoryType = UITableViewCellAccessoryNone;
                optionCell.selectionStyle = UITableViewCellSelectionStyleGray;
                arrowImageView.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 33, 11, 22, 22);
                arrowImageView.image = [UIImage imageNamed:[YTRegisterHelper registerHelper].parkingSpace ? @"yt_register_selectBtn_select" : @"yt_register_selectBtn_cancel"];
            }
            else {
                inputTextField.hidden = NO;
                inputTextField.userInteractionEnabled = YES;
                arrowImageView.hidden = YES;
                optionCell.accessoryType = UITableViewCellAccessoryNone;
                optionCell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (row == 3) {
                    inputTextField.placeholder = @"请输入商家电话,如057188188523";
                    inputTextField.keyboardType = UIKeyboardTypePhonePad;
                }
                else {
                    inputTextField.placeholder = @"请输入人均消费,如100";
                    inputTextField.keyboardType = UIKeyboardTypeNumberPad;
                }
            }
        }

        NSArray* sectionArr = [renderArr objectAtIndex:section];
        optionCell.textLabel.text = [sectionArr objectAtIndex:row];

        return optionCell;
    }
    else if (row == 5) {
        static NSString* upLoadShopCellIdentifder = @"upLoadShopCell";
        UITableViewCell* upLoadShopCell = [tableView dequeueReusableCellWithIdentifier:upLoadShopCellIdentifder];
        if (!upLoadShopCell) {
            upLoadShopCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:upLoadShopCellIdentifder];

            UIImageView* imageView = [[UIImageView alloc] init];
            imageView.tag = 100;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.image = [UIImage imageNamed:@"yt_register_photoimage"];
            imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200);
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [upLoadShopCell addSubview:imageView];
        }
        UIImageView* imageView = (UIImageView*)[upLoadShopCell viewWithTag:100];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.bounds), 200), YES, [UIScreen mainScreen].scale);
        if ([YTRegisterHelper registerHelper].masterImg) {
            UIImage *aImage = [UIImage imageWithData:[YTRegisterHelper registerHelper].masterImg];
            aImage = [aImage imageByScalingAndCroppingForSize:CGSizeMake(CGRectGetWidth(self.view.bounds), 200)];
            [aImage drawInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
        }
        else {
            [[UIImage imageNamed:@"yt_register_photoimage"] drawInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
            [[UIImage imageNamed:@"yt_register_uploadImage"] drawInRect:CGRectMake((CGRectGetWidth(self.view.bounds) - 45) / 2, 55, 45, 45)];
            [@"添加店面图片" drawInRect:CGRectMake(0, 110, CGRectGetWidth(self.view.bounds), 26)
                         withAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:20],
                             NSForegroundColorAttributeName : [UIColor whiteColor],
                             NSParagraphStyleAttributeName : paragraphStyle }];
        }
        imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return upLoadShopCell;
    }
    static NSString* upLoadEnvironmentCellIdentifier = @"upLoadEnvironmentCell";
    UITableViewCell* upLoadEnvironmentCell = [tableView dequeueReusableCellWithIdentifier:upLoadEnvironmentCellIdentifier];
    if (!upLoadEnvironmentCell) {
        upLoadEnvironmentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:upLoadEnvironmentCellIdentifier];

        // configure UI Property
        UILabel* promptLab = [[UILabel alloc] init];
        promptLab.text = @"环境图";
        promptLab.frame = CGRectMake(15, 5, 100, 14);
        promptLab.font = [UIFont systemFontOfSize:12];
        promptLab.textColor = [UIColor lightGrayColor];
        [upLoadEnvironmentCell addSubview:promptLab];

        UIScrollView* photoScrollView = [[UIScrollView alloc] init];
        photoScrollView.tag = 100;

        photoScrollView.frame = CGRectMake(0, 30, CGRectGetWidth(self.view.bounds), 80);
        [upLoadEnvironmentCell addSubview:photoScrollView];
    }
    UIScrollView* photoScrollView = (UIScrollView*)[upLoadEnvironmentCell viewWithTag:100];

    NSUInteger photoCount = selectEnvironmentArr.count;
    if (photoCount < 9) {
        photoCount++;
    }
    for (int i = 0; i < photoCount; i++) {
        if (i < selectEnvironmentArr.count) {
            UIImage* image = [selectEnvironmentArr objectAtIndex:i];
            UIImageView* imageView = [[UIImageView alloc] init];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = image;
            imageView.frame = CGRectMake(10 + 75 * i, 0, 65, 65);
            [photoScrollView addSubview:imageView];
        }
        else {
            UIButton* photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [photoBtn addTarget:self action:@selector(addEnronmentImage) forControlEvents:UIControlEventTouchUpInside];
            [photoBtn setBackgroundImage:[UIImage imageNamed:@"yt_register_addBtn"] forState:UIControlStateNormal];
            photoBtn.frame = CGRectMake(10 + 75 * i, 0, 65, 65);
            [photoScrollView addSubview:photoBtn];
        }
    }
    photoScrollView.contentSize = CGSizeMake(20 + 75 * photoCount, 65);
    return upLoadEnvironmentCell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;

    UITableViewCell* currCell = [tableView cellForRowAtIndexPath:indexPath];
    if (section == 0) {
        if (row == 0) {
            UITextField* inputTextField = (UITextField*)[currCell viewWithTag:100];
            [inputTextField becomeFirstResponder];
        }
        else if (row == 1) {
            [self.view endEditing:YES];
//            [self showCityAreaPicker];
            YTRegisterAddressSelViewController* registerAddressSelVc = [[YTRegisterAddressSelViewController alloc] init];
            registerAddressSelVc.delegate = self;
            [self.navigationController pushViewController:registerAddressSelVc animated:YES];
        }
        else if (row == 3) {
            [self.view endEditing:YES];
            if (sortSelView.alpha == 0) {
                [sortSelView showSelectSortView];
            }
            else {
                [sortSelView hideSelectSortView];
            }
        }
    }
    else {
        if (row == 0) {
            [YTRegisterHelper registerHelper].showStretchOption = ![YTRegisterHelper registerHelper].showStretchOption;
            [tableView reloadData];
        }
        else if (row == 1) {
            [self.view endEditing:YES];
            if (timeSelView.alpha == 0) {
                [timeSelView showSelectTimeView];
            }
            else {
                [timeSelView hideSelectTimeView];
            }
        }
        else if (row == 2) {
            [YTRegisterHelper registerHelper].parkingSpace = ![YTRegisterHelper registerHelper].parkingSpace;
            [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
        }
        else if (row == 5) {
            selectFromMasterImage = YES;
            [self hungUpPhotoSelSheet];
        }
        else if (row != 6) {
            UITextField* inputTextField = (UITextField*)[currCell viewWithTag:101];
            [inputTextField becomeFirstResponder];
        }
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    if (section==0 &&row==2) {
        return 90;
    }
    if (section == 1) {
        if (row == 5) {
            return 200;
        }
        else if (row == 6) {
            return 100;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
#pragma mark -YTRegisterAddressSelViewControllerDelegate
- (void)registerAddressSelViewController:(YTRegisterAddressSelViewController*)viewController didSelectPoi:(AMapPOI*)mapPoi
{

    [registerTableView reloadData];
}
#pragma mark -setRegisterInfo
- (void)setRegisterInfo:(UITextField*)textField
{
    UITableViewCell* cell = (UITableViewCell*)textField.superview;
    if (![cell isMemberOfClass:[UITableViewCell class]]) {
        cell = (UITableViewCell*)cell.superview;
    }
    NSIndexPath* indexPath = [registerTableView indexPathForCell:cell];
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    if (section == 0) {
        if (row == 0) {
            [YTRegisterHelper registerHelper].name = textField.text;
        }
        else if (row == 2) {
            [YTRegisterHelper registerHelper].upAddress = textField.text;
        }
        else if (row == 3) {
            [YTRegisterHelper registerHelper].saleUserId = textField.text;
        }
    }
    else if (section == 1) {
        if (row == 3) {
            [YTRegisterHelper registerHelper].tel = textField.text;
        }
        else if (row == 4) {
            [YTRegisterHelper registerHelper].custFee = textField.text.intValue;
        }
    }
}

#pragma mark -CTAssetsPickerControllerDelegate
- (BOOL)assetsPickerController:(CTAssetsPickerController*)picker isDefaultAssetsGroup:(ALAssetsGroup*)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController*)picker didFinishPickingAssets:(NSArray*)assets
{

    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:picker.view];
    hud.labelText = @"正在处理图片...";
    [picker.view addSubview:hud];

    __block NSMutableArray* environmentArr = selectEnvironmentArr;
    [hud showAnimated:YES
        whileExecutingBlock:^{
            for (ALAsset* asset in assets) {
                UIImage* image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                image = [image imageScaledWithMaxWidth:kDeviceCurrentWidth];
                [environmentArr addObject:image];
                [YTRegisterHelper registerHelper].hjImgArr = [NSMutableArray arrayWithArray:environmentArr];
            }
        }
        completionBlock:^{
            [hud removeFromSuperview];
            [picker.presentingViewController dismissViewControllerAnimated:YES
                                                                completion:^{
                                                                    [registerTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:6 inSection:1] ] withRowAnimation:UITableViewRowAnimationNone];
                                                                }];
        }];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController*)picker shouldEnableAsset:(ALAsset*)asset
{
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
        return NO;
    }
    return YES;
}

- (BOOL)assetsPickerController:(CTAssetsPickerController*)picker shouldSelectAsset:(ALAsset*)asset
{
    NSInteger count = kMaxMilieuImageCount - selectEnvironmentArr.count;
    if (picker.selectedAssets.count >= count) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您最多只能选择%ld张图片", (long)count] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    return (picker.selectedAssets.count < count && asset.defaultRepresentation != nil);
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (buttonIndex == 2) {
            return;
        }
        switch (buttonIndex) {
        case 0: {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } break;
        case 1: {
            if (selectFromMasterImage) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            else {
                CTAssetsPickerController* picker = [[CTAssetsPickerController alloc] init];
                picker.assetsFilter = [ALAssetsFilter allPhotos];
                picker.title = @"相册";
                picker.delegate = self;
                picker.selectedAssets = [[NSMutableArray alloc] init];
                [self presentViewController:picker animated:YES completion:nil];
                return;
            }
        } break;
        default:
            return;
        }
    }
    else {
        if (buttonIndex == 1) {
            return;
        }
        if (buttonIndex == 0) {
            if (selectFromMasterImage) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            else {
                CTAssetsPickerController* picker = [[CTAssetsPickerController alloc] init];
                picker.assetsFilter = [ALAssetsFilter allPhotos];
                picker.title = @"相册";
                picker.delegate = self;
                picker.selectedAssets = [[NSMutableArray alloc] init];
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{

    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:picker.view];
    hud.labelText = @"正在处理图片...";
    [picker.view addSubview:hud];

    wSelf(wSelf);
    __block NSMutableArray* environmentArr = selectEnvironmentArr;
    __block UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [hud showAnimated:YES
        whileExecutingBlock:^{
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
            image = [image imageScaledWithMaxWidth:kDeviceCurrentWidth];
        }
        completionBlock:^{
            [hud removeFromSuperview];
            __strong typeof(wSelf) sSelf = wSelf;
            if (sSelf->selectFromMasterImage) {
                [YTRegisterHelper registerHelper].masterImg = UIImageJPEGRepresentation(image, 0.5);
                [sSelf->registerTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:5 inSection:1] ] withRowAnimation:UITableViewRowAnimationNone];
            }
            else {
                [environmentArr addObject:image];
                [YTRegisterHelper registerHelper].hjImgArr = [NSMutableArray arrayWithArray:environmentArr];
                [sSelf->registerTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:6 inSection:1] ] withRowAnimation:UITableViewRowAnimationNone];
            }
            [picker dismissViewControllerAnimated:YES completion:NULL];
        }];
}

#pragma mark -addEnronmentImage
- (void)addEnronmentImage
{
    selectFromMasterImage = NO;
    [self hungUpPhotoSelSheet];
}

#pragma mark -hungUpPhotoSelSheet
- (void)hungUpPhotoSelSheet
{
    UIActionSheet* photoSheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        photoSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        photoSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    [photoSheet showInView:self.view];
}
#pragma mark -cityAreaPicker
- (void)showCityAreaPicker
{
    [cityPickerView showAreaPickerView];
}

@end
