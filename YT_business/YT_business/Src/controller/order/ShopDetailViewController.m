#import "ShopDetailViewController.h"
#import "ShopDetailHeadView.h"
#import "YTUpdateShopInfoModel.h"
#import "MBProgressHUD+Add.h"
#import "ShopDetailSectionHeadView.h"
#import "ShopDetailHbTableCell.h"
#import "UINavigationBar+Awesome.h"
#import "YTHttpClient.h"
#import "UIViewController+Helper.h"
#import "CheckInstalledMapAPP.h"
#import "MarsLocationChange.h"
#import "YTVenderDefine.h"
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import "MWPhotoBrowser.h"
#import "UIImage+HBClass.h"
#import "PromotionHbDetailViewController.h"
#import "NSStrUtil.h"
#import "ApplyUntil.h"

static NSString* CellIdentifier = @"ShopDetailCellIdentifier";

#define NAVBAR_CHANGE_POINT 50

@interface ShopDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ShopDetailHeadViewDelegate,MWPhotoBrowserDelegate,UIActionSheetDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)ShopDetailHeadView *headView;

@property (strong, nonatomic) YTUpdateShopInfoModel *shopInfoModel;
@property (strong, nonatomic) NSMutableArray *mwPhotos;
@end

@implementation ShopDetailViewController

#pragma mark - Life cycle
-(instancetype)initWithShopId:(NSString *)shopId
{
    self = [super init];
    if (self) {
        _shopId = shopId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.requestParas = @{@"shopId":self.shopId,
                          loadingKey : @(YES)};
    self.requestURL = shopInfoURL;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -fetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
    if (parserObject.success) {
        self.shopInfoModel = (YTUpdateShopInfoModel *)parserObject;
        [self initializePageSubviews];

    }else{
        [MBProgressHUD showMessag:parserObject.message toView:self.view];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shopInfoModel.shopInfo.receiveableHongbao.count;;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.shopInfoModel.shopInfo.receiveableHongbao.count == 0) {
        return nil;
    }
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60)];
    [headView addSubview:({
        ShopDetailSectionHeadView *sectionView = [[ShopDetailSectionHeadView alloc] initWithFrame:CGRectMake(0, 25, kDeviceWidth, 45)];
        sectionView.leftLabel.text = [NSString stringWithFormat:@"红包（%@）",@(self.shopInfoModel.shopInfo.receiveableHongbao.count)];
        if (self.shopInfoModel.shopInfo.receiveableHongbao.count > 0) {
            sectionView.rightLabel.text = @"买单享折扣并送等值红包";
        }
        sectionView;
    })];
    return headView;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    ShopDetailHbTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    YTCommonHongBao *hongbao = self.shopInfoModel.shopInfo.receiveableHongbao[indexPath.row];
    [cell configShopDetailHbTableCellModel:hongbao];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.shopInfoModel.shopInfo.receiveableHongbao.count) {
        YTCommonHongBao *hongbao = self.shopInfoModel.shopInfo.receiveableHongbao[indexPath.row];
        PromotionHbDetailViewController *hbDetailVC = [[PromotionHbDetailViewController alloc] initWithHbId:hongbao.hongbaoId];
        [self.navigationController pushViewController:hbDetailVC animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64);
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        self.navigationItem.title = self.shopInfoModel.shopInfo.shop.name;
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        self.navigationItem.title = @"";
    }
}
#pragma mark - ShopDetailHeadViewDelegate
- (void)shopDetailHeadView:(ShopDetailHeadView*)headView didClickedIndex:(NSInteger)index
{
    if (index == 0) {
        [self callPhoneNumber:self.shopInfoModel.shopInfo.shop.mobile];
    }else if (index == 1) {
        YTShop *shop = self.shopInfoModel.shopInfo.shop;
        CLLocationCoordinate2D to = CLLocationCoordinate2DMake(shop.lat, shop.lon);
        [self openNavigation:to destinationNamen:shop.name];
    }else if (index == 2) {
        self.mwPhotos = [[NSMutableArray alloc] init];
        for (YTImage* imageUrl in self.shopInfoModel.shopInfo.hjImg) {
            MWPhoto* photo = [MWPhoto photoWithURL:[NSURL URLWithString:imageUrl.img]];
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

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser*)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.mwPhotos.count) {
        return self.mwPhotos[index];
    }
    return nil;
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{    
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    [self.headView configShopDetailHeadViewWithModel:self.shopInfoModel];
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight) style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[ShopDetailHbTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (ShopDetailHeadView *)headView
{
    if (!_headView) {
        CGFloat headHeight = 350;
        if ([NSStrUtil isEmptyOrNull:_shopInfoModel.shopInfo.shop.startTime]) {
            headHeight -= 44;
        }
        if (_shopInfoModel.shopInfo.shop.parkingSpace == 0) {
            headHeight -= 44;
        }
        _headView = [[ShopDetailHeadView alloc] initWithShopInfoModel:_shopInfoModel frame:CGRectMake(0, 0, kDeviceWidth, headHeight)];
        _headView.delegate = self;
    }
    return _headView;
}

//- (UIRectEdge)edgesForExtendedLayout
//{
//    return UIRectEdgeTop;
//}
@end
