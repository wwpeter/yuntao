#import "CSearchHbDetailViewController.h"
#import "SearchHbDetailTableCell.h"
#import "UIViewController+Helper.h"
#import "MBProgressHUD+Add.h"
#import "YTResultHbDetailModel.h"
#import "HbDetailHeadView.h"
#import "HbDetailNotesView.h"
#import "CHbDetailAddressView.h"
#import "UIView+DKAddition.h"
#import "ShopDetailViewController.h"
#import "SearchSectionHeadView.h"
#import "ShopDetailViewController.h"
#import "UIViewController+ShopDetail.h"

static NSString* hbAddressCellIdentifier = @"HbAddressCellIdentifier";
static NSString* hbNotesCellIdentifier = @"HbNotesCellIdentifier";
static NSString* hbCellIdentifier = @"searchHbCellIdentifier";

static HbDetailNotesView* notesView;

@interface CSearchHbDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) YTResultHbDetail *hbDetail;
@end

@implementation CSearchHbDetailViewController
- (id)init {
    if ((self = [super init])) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"红包详情";
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fetchData
{
    self.requestParas = @{@"id" : self.hongbaoId,
                          loadingKey : @(YES)};
    self.requestURL = YC_Request_HongbaoDetail;
}
- (void)actionFetchRequest:(YTRequestModel *)request result:(YTBaseModel *)parserObject
              errorMessage:(NSString *)errorMessage
{
    
    if (parserObject.success) {
        YTResultHbDetailModel *hbDetailModel = (YTResultHbDetailModel *)parserObject;
        self.hbDetail = hbDetailModel.hbDetail;
        [self initializePageSubviews];
    }else{
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }
    return self.hbDetail.shops.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 1) {
        return notesView.dk_height;
    }else {
        return 86;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 15;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return nil;
    }
    SearchSectionHeadView *headView = [[SearchSectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
    return headView;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [self hbAddressCell];
    } else if (indexPath.section == 1) {
        cell = [self hbNotesCell];
    }
    else{
        SearchHbDetailTableCell *searchCell = (SearchHbDetailTableCell *)[tableView dequeueReusableCellWithIdentifier:hbCellIdentifier];
        if (indexPath.row < self.hbDetail.shops.count) {
            YTHbShopModel* shopModel = (YTHbShopModel*)[self.hbDetail.shops objectAtIndex:indexPath.row];
            [searchCell configSearchHbDetailCellWithModel:shopModel];
        }
        return searchCell;
    }
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 2) {
        return;
    }
    
    YTHbShopModel* shopModel = (YTHbShopModel*)[self.hbDetail.shops objectAtIndex:indexPath.row];BOOL isPromotion = (shopModel.promotionType == 1 && shopModel.isDiscount) || shopModel.promotionType==2;
    [self showShopDetailWithShopId:shopModel.shopId isPromotion:isPromotion];
}
#pragma mark - Private methods
- (UITableViewCell *)hbAddressCell
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:hbAddressCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:hbAddressCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 地址
        CHbDetailAddressView* addressView = [[CHbDetailAddressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100)];
        addressView.tag = 101;
        [cell.contentView addSubview:addressView];
    }
    CHbDetailAddressView* addressView = (CHbDetailAddressView*)[cell.contentView viewWithTag:101];
    addressView.shopLabel.text = self.hbDetail.hongbao.shop.name;
    addressView.addressLabel.text = self.hbDetail.hongbao.shop.address;
    __weak __typeof(self) weakSelf = self;
    addressView.selectBlock = ^(NSInteger selectIndex) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (selectIndex == 0) {
            [strongSelf callPhoneNumber:weakSelf.hbDetail.hongbao.shop.mobile];
        }
        else {
//            [strongSelf shopNavi];
            BOOL isPromotion = weakSelf.hbDetail.hongbao.shop.promotionType > 0 ? YES : NO;
            [self showShopDetailWithShopId:weakSelf.hbDetail.hongbao.shop.shopId isPromotion:isPromotion];
        }
    };
    
    return cell;
}
- (UITableViewCell *)hbNotesCell
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:hbNotesCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:hbNotesCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        notesView.tag = 102;
        [cell.contentView addSubview:notesView];
    }
    return cell;
}
- (void)shopNavi
{
    CLLocationCoordinate2D to = CLLocationCoordinate2DMake(self.hbDetail.hongbao.shop.lat, self.hbDetail.hongbao.shop.lon);
    [self openNavigation:to destinationNamen:self.hbDetail.hongbao.shop.name];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    notesView = [[HbDetailNotesView alloc] initWithResultHongBao:self.hbDetail.hongbao frame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
    [notesView fitOptimumSize];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = ({
        HbDetailHeadView *headView = [[HbDetailHeadView alloc] initWithDisplayTime:NO frame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 270)];
        [headView configDetailHeadViewWithResultHongBao:self.hbDetail.hongbao];
        headView;
    });
    [self setExtraCellLineHidden:self.tableView];
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SearchHbDetailTableCell class] forCellReuseIdentifier:hbCellIdentifier];
    }
    return _tableView;
}
@end
