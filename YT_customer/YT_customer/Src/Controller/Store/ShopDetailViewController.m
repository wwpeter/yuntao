#import "ShopDetailViewController.h"
#import "ShopDetailHeadView.h"
#import "MBProgressHUD+Add.h"
#import "ShopDetailSectionHeadView.h"
#import "ShopDetailHbTableCell.h"
#import "UINavigationBar+Awesome.h"
#import "UIViewController+Helper.h"
#import "MWPhotoBrowser.h"
#import "UIImage+HBClass.h"
#import "YTNetworkMange.h"
#import "ShopDetailModel.h"
#import "SingleHbModel.h"
#import "ShopDetailBottomView.h"
#import <MapKit/MapKit.h>
#import "CMyHbDetailViewController.h"
#import "StoryBoardUtilities.h"
#import "PayViewController.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"
#import "ShopDetailPayTableCell.h"
#import "UIBarButtonItem+Addition.h"
#import "ShopDetailSubtractPayTableCell.h"
#import "ShopSubtractRuleViewController.h"
#import "CollectManager.h"
#import "CollectModel.h"

static NSString* CellIdentifier = @"ShopDetailCellIdentifier";
static NSString* CellPayIdentifier = @"ShopDetailCellPayIdentifier";
static NSString* CellSubtractPayIdentifier =
    @"ShopDetailCellSubtractPayIdentifier";

#define NAVBAR_CHANGE_POINT 50

@interface ShopDetailViewController () <UITableViewDataSource, UITableViewDelegate, ShopDetailHeadViewDelegate,
    MWPhotoBrowserDelegate, UIActionSheetDelegate>
@property (nonatomic) CollectModel *model;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) ShopDetailHeadView* headView;
@property (strong, nonatomic) ShopDetailModel* shopModel;
@property (strong, nonatomic) NSMutableArray* mwPhotos;

@end

@implementation ShopDetailViewController

#pragma mark - Life cycle
- (instancetype)initWithShopId:(NSNumber*)shopId
{
    self = [super init];
    if (self) {
        _shopId = shopId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"商户详情";
    //收藏按钮
    //[self addLeftButton];
    if (self.isPromotion) {
        [self.navigationController.navigationBar
            lt_setBackgroundColor:[UIColor clearColor]];
        [self configNavigationBarTitleColor:[UIColor whiteColor]];
        [self configNavigationLeftItemImage:YES];
    }
    else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadShopDetailData];
}

//收藏
- (void)addLeftButton {
    UIImage *saoButton = [UIImage imageNamed:@"collection.png"];
    UIImage *higImage = [UIImage imageNamed:@"collection.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:saoButton highlightImage:higImage target:self action:@selector(didCollectButtonItemAction:)];
}

- (void)didCollectButtonItemAction:(UIButton *)button {
    NSLog(@"收藏");
    _model = [[CollectModel alloc] init];
    self.model.shopID = [NSString stringWithFormat:@"%@",self.shopId];
    if (self.model) {
        [[CollectManager sharedInstance] insertModel:self.model];
        //收藏提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"已收藏" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"完成");
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"收藏失败" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"完成");
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self scrollViewDidScroll:self.tableView];
    if (self.isPromotion) {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self configNavigationBarTitleColor:[UIColor blackColor]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Data
- (void)loadShopDetailData
{
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    NSDictionary* parameters = @{ @"shopId" : _shopId };
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_ShopInfo
        parameters:parameters
        success:^(id responseData) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.shopModel = [[ShopDetailModel alloc]
                initWithShopDetailDictionary:responseData];
            [strongSelf initializePageSubviews];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        }
        failure:^(NSString* errorMessage) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [MBProgressHUD showError:errorMessage toView:weakSelf.view];
        }];
}
#pragma mark - UITableViewDataSource 代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1 + [self buyModeNumber];
}
- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == [self buyModeNumber]) {
        return self.shopModel.hbList.count;
    }
    else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    BOOL validateSection = indexPath.section != [self buyModeNumber];
    BOOL valideateSub = [self buyModeNumber] > 1 && indexPath.section == 1;
    if (validateSection && self.shopModel.promotionType == 2) {
        if ([self buyModeNumber] == 1 || valideateSub) {
            return (self.shopModel.fullInDateRules.count * 24 + (self.shopModel.fullInDateRules.count > 0 ? 10 : 0)) + 60;
        }
    }
    return 60;
}
- (CGFloat)tableView:(UITableView*)tableView
    heightForHeaderInSection:(NSInteger)section
{
    if (section == [self buyModeNumber]) {
        return 60;
    }
    else {
        return 15;
    }
}
- (CGFloat)tableView:(UITableView*)tableView
    heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView*)tableView:(UITableView*)tableView
    viewForHeaderInSection:(NSInteger)section
{
    if (self.shopModel.hbList.count == 0) {
        return nil;
    }
    if (section != [self buyModeNumber]) {
        return nil;
    }
    UIView* headView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60)];
    [headView addSubview:({
                  ShopDetailSectionHeadView* sectionView =
                      [[ShopDetailSectionHeadView alloc]
                          initWithFrame:CGRectMake(0, 15, kDeviceWidth, 45)];
                  sectionView.leftLabel.text =
                      [NSString stringWithFormat:@"红包(%@)",
                                @(self.shopModel.hbList.count)];
                  sectionView.rightLabel.text = @"送消费等值红包";
                  sectionView;
              })];
    return headView;
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == [self buyModeNumber]) {
        ShopDetailHbTableCell* cell =
            [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        SingleHbModel* hbModel = self.shopModel.hbList[indexPath.row];
        [cell configShopDetailHbTableCellModel:hbModel];

        return cell;
    }
    else {
        ShopDetailPayTableCell* cell =
            [tableView dequeueReusableCellWithIdentifier:CellPayIdentifier];
        if (self.shopModel.userHongbaos.count > 0 || self.isPromotion) {
            NSInteger num = [self buyModeNumber];
            if (num == 1) {
                if (self.shopModel.userHongbaos.count > 0) {
                    [cell showHongbaoPay];
                }
                else {
                    if (self.shopModel.promotionType == 2) {
                        return [self shopDetailSubtractPayTableCell:tableView];
                    }
                    else {
                        [cell showDiscountPay:self.shopModel.discount];
                    }
                }
            }
            else {
                if (indexPath.section == 0) {
                    [cell showHongbaoPay];
                }
                else {
                    if (self.shopModel.promotionType == 2) {
                        return [self shopDetailSubtractPayTableCell:tableView];
                    }
                    else {
                        [cell showDiscountPay:self.shopModel.discount];
                    }
                }
            }
        }
        else {
            cell.buyLabel.text = @"快捷支付";
            cell.payType = PreferencePayTypeNone;
        }
        __weak __typeof(self) weakSelf = self;
        cell.payBlock = ^(PreferencePayType payType) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf pushToStoreReceiveViewController:payType];
        };
        return cell;
    }
}
- (ShopDetailSubtractPayTableCell*)shopDetailSubtractPayTableCell:
    (UITableView*)tableView
{
    ShopDetailSubtractPayTableCell* cell =
        [tableView dequeueReusableCellWithIdentifier:CellSubtractPayIdentifier];
    [cell configShopDetailSubtractPayTimes:self.shopModel.fullInDateRules];
    __weak __typeof(self) weakSelf = self;
    cell.payBlock = ^(PreferencePayType payType) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf pushToStoreReceiveViewController:payType];
    };
    cell.selectBlock = ^() {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        ShopSubtractRuleViewController* shopSubtractVC = [[ShopSubtractRuleViewController alloc] init];
        shopSubtractVC.shopDetail = strongSelf.shopModel;
        [strongSelf.navigationController pushViewController:shopSubtractVC animated:YES];
    };
    return cell;
}
- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == [self buyModeNumber]) {
        SingleHbModel* introModel = self.shopModel.hbList[indexPath.row];
        CMyHbDetailViewController* hbDetailVC = [StoryBoardUtilities
            viewControllerForMainStoryboard:[CMyHbDetailViewController class]];
        hbDetailVC.detailModel = introModel.hbDetailModel;
        hbDetailVC.hbtype = HbDetailTypeShopHb;
        [self.navigationController pushViewController:hbDetailVC animated:YES];
        ;
    }
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (!self.isPromotion) {
        return;
    }
    UIColor* color = [UIColor colorWithRed:248 / 255.0
                                     green:248 / 255.0
                                      blue:248 / 255.0
                                     alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64);
        [self.navigationController.navigationBar
            lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [self configNavigationBarTitleColor:[UIColor blackColor]];
        [self configNavigationLeftItemImage:NO];
    }
    else {
        [self.navigationController.navigationBar
            lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        [self configNavigationBarTitleColor:[UIColor whiteColor]];
        [self configNavigationLeftItemImage:YES];
    }
}
#pragma mark - ShopDetailHeadViewDelegate
- (void)shopDetailHeadView:(ShopDetailHeadView*)headView
           didClickedIndex:(NSInteger)index
{
    if (index == 0) {
        [self callPhoneNumber:self.shopModel.shopPhone];
    }
    else if (index == 1) {
        CLLocationCoordinate2D to = CLLocationCoordinate2DMake(
            self.shopModel.latitude, self.shopModel.longitude);
        [self openNavigation:to destinationNamen:self.shopModel.shopName];
    }
    else if (index == 2) {
        if (self.shopModel.hjImages.count == 0) {
            return;
        }
        self.mwPhotos = [[NSMutableArray alloc] init];
        for (NSDictionary* item in self.shopModel.hjImages) {
            NSString* imageUrl = item[@"img"];
            MWPhoto* photo = [MWPhoto
                photoWithURL:[imageUrl imageUrlWithWidth:kDeviceCurrentWidth]];
            [self.mwPhotos addObject:photo];
        }
        MWPhotoBrowser* browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        [self.navigationController pushViewController:browser animated:YES];
    }
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser*)photoBrowser
{
    return self.mwPhotos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser*)photoBrowser
               photoAtIndex:(NSUInteger)index
{
    if (index < self.mwPhotos.count) {
        return self.mwPhotos[index];
    }
    return nil;
}
#pragma mark - Private methods
- (NSInteger)buyModeNumber
{
    NSInteger i = 0;
    if (self.shopModel.userHongbaos.count > 0 || self.isPromotion) {
        if (self.shopModel.userHongbaos.count > 0) {
            i += 1;
        }
        if (self.isPromotion) {
            i += 1;
        }
    }
    else {
        i = 1;
    }
    return i;
}
- (void)pushToStoreReceiveViewController:(PreferencePayType)payType
{
    PayViewController* payVC = [[PayViewController alloc] init];
    payVC.shopModel = self.shopModel;
    payVC.payType = payType;
    [self.navigationController pushViewController:payVC animated:YES];
}
#pragma mark - Navigation
- (void)configNavigationBarTitleColor:(UIColor*)color
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSForegroundColorAttributeName : color,
        NSShadowAttributeName : [NSShadow new]
    }];
}
- (void)configNavigationLeftItemImage:(BOOL)isLight
{
    if (isLight) {
        UIImage* norImage =
            [UIImage imageNamed:@"yt_navigation_backBtn_normal02.png"];
        UIImage* higlImage =
            [UIImage imageNamed:@"yt_navigation_backBtn_high02.png"];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
            initWithCustomImage:norImage
                 highlightImage:higlImage
                         target:self
                         action:@selector(didLeftBarButtonItemAction:)];
    }
    else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
            initWithYunTaoBacktarget:self
                              action:@selector(didLeftBarButtonItemAction:)];
    }
}
- (void)didLeftBarButtonItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    self.isPromotion = self.shopModel.isPromotion;
    [self.view addSubview:self.tableView];

    CGFloat headHeight = self.isPromotion ? 438 : 238;
    if ([NSStrUtil isEmptyOrNull:_shopModel.startDate]) {
        headHeight -= 44;
    }
    if (_shopModel.parking.integerValue == 0) {
        headHeight -= 44;
    }
    self.headView = [[ShopDetailHeadView alloc]
        initWithShopDetailModel:_shopModel
                          Frame:CGRectMake(0, 0, kDeviceWidth, headHeight)];
    self.headView.delegate = self;
    self.tableView.tableHeaderView = self.headView;
    //    if (!self.shopModel.conflictVer) {
    //        [self showAlert:@"当前版本不适用最新商家满减规则,请及时更新版本" title:@""];
    //    }
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.estimatedRowHeight = 60.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[ShopDetailHbTableCell class]
            forCellReuseIdentifier:CellIdentifier];
        [_tableView registerClass:[ShopDetailPayTableCell class]
            forCellReuseIdentifier:CellPayIdentifier];
        [_tableView registerClass:[ShopDetailSubtractPayTableCell class]
            forCellReuseIdentifier:CellSubtractPayIdentifier];
    }
    return _tableView;
}
@end
