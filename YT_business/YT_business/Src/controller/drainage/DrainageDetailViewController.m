

#import "HbEmptyView.h"
#import "YTDrainageModel.h"
#import "YTDetailActionView.h"
#import "StoryBoardUtilities.h"
#import "YTDrainageDetailModel.h"
#import "HbDetailViewController.h"
#import "DrainageDetailTableCell.h"
#import "DrainageDetailViewController.h"
#import "DrainageDetailTableHeadView.h"
#import "ShopDetailViewController.h"

static NSString *CellIdentifier = @"DrainageDetailCellIdentifier";

@interface DrainageDetailViewController ()
<
DrainageDetailHeadViewDelegate,
UITableViewDataSource,
UITableViewDelegate
> {
    YTDrainageDetail *drainageDetail;
    DrainageDetailTableHeadView *headView;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) HbEmptyView *emptyView;
@property (strong, nonatomic) YTDetailActionView *topDeatilView;
@end

@implementation DrainageDetailViewController

#pragma mark - Life cycle
- (id)init {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"我的红包";
        self.view.backgroundColor =  CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -fetchHongbaoDetail
- (void)fetchHongbaoDetail {
    self.requestParas = @{@"id":self.drainage.drainageId,
                          loadingKey:@(YES)};
    self.requestURL = saleHongbaoDetailURL;
}

#pragma mark -override fetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
    if (parserObject.success) {
        YTDrainageDetailModel *drainageDetailModel = (YTDrainageDetailModel *)parserObject;
        drainageDetail = drainageDetailModel.drainageDetail;
        [headView configDrainageDetailHeadViewWithModel:drainageDetail];
        wSelf(wSelf);
        self.topDeatilView.actionBlock = ^() {
            if (!wSelf) {
                return ;
            }
            __strong typeof(wSelf) sSelf = wSelf;
            HbDetailViewController *hbDetailVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbDetailViewController class]];
            hbDetailVC.drainageDetail = sSelf->drainageDetail;
            [sSelf.navigationController pushViewController:hbDetailVC animated:YES];
        };
        if (drainageDetail.shops.count == 0) {
            [self showEmptyView];
        }else {
          [self.tableView reloadData];
        }
    } else {
        
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return drainageDetail.shops.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DrainageDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.section < drainageDetail.shops.count) {
        YTCommonShop *commonShop = (YTCommonShop *)[drainageDetail.shops objectAtIndex:indexPath.section];
        [cell configDrainageDetailCellWithModel:commonShop];
    }
   
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     if (indexPath.section >= drainageDetail.shops.count) {
         return;
     }
    YTCommonShop *commonShop = (YTCommonShop *)[drainageDetail.shops objectAtIndex:indexPath.section];
    ShopDetailViewController *shopDetailVC  = [[ShopDetailViewController alloc] initWithShopId:commonShop.shopId];
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

#pragma mark - DrainageDetailHeadViewDelegate
- (void)drainageDetailHeadViewDidTap:(DrainageDetailTableHeadView *)view
{
    if (drainageDetail) {
        HbDetailViewController *hbDetailVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbDetailViewController class]];
        hbDetailVC.drainageDetail = drainageDetail;
        [self.navigationController pushViewController:hbDetailVC animated:YES];
    }
}
#pragma mark - Event response
#pragma mark - Private methods
- (void)showEmptyView
{
    if (drainageDetail.shops.count == 0) {
        self.emptyView.hidden = NO;
    } else {
        self.emptyView.hidden = YES;
    }
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
       [self.view addSubview:self.emptyView];
    if (self.drainage.status == YTDRAINAGESTATUS_PASS ||
        self.drainage.status == YTDRAINAGESTATUS_AUDITOFFSHELVESPASS ||
        self.drainage.status == YTDRAINAGESTATUS_FORCEOFFSHELVES ||
        self.drainage.status == YTDRAINAGESTATUS_EXPIRED ) {
        [self.view addSubview:self.tableView];
        headView = [[DrainageDetailTableHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 140)];
        headView.delegate = self;
        self.tableView.tableHeaderView = headView;
    }else {
        [self.view addSubview:self.topDeatilView];
        self.emptyView.hidden = NO;
        self.topDeatilView.titleLabel.text = [NSString stringWithFormat:@"%@ 价值%.2f元",self.drainage.name,self.drainage.cost/100.];
        self.topDeatilView.detailLabel.text = [YTTaskHandler outDrainageStatusStrWithStatus:self.drainage.status];
        [self.topDeatilView displayTopLine:NO bottomLine:YES];
    }
    [self fetchHongbaoDetail];
    self.emptyView.yOffset = 0;
    self.emptyView.descriptionColor = [UIColor blackColor];
    if (self.drainage.status == YTDRAINAGESTATUS_PRECONFIRMPRICE ||
              self.drainage.status == YTDRAINAGESTATUS_PREAUDIT) {
        self.emptyView.titleLabel.text = @"待审核";
        self.emptyView.descriptionLabel.text = @"";
    } else if (self.drainage.status == YTDRAINAGESTATUS_AUDITNOTPASS) {
        self.emptyView.titleLabel.text = @"审核未通过";
        self.emptyView.descriptionLabel.text = @"";
    }else{
        self.emptyView.titleLabel.text = @"暂未投放到其他商家";
    }
}
#pragma mark - Getters & Setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-kNavigationFullHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 95;
        [_tableView registerClass:[DrainageDetailTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (HbEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[HbEmptyView alloc] initWithFrame:self.view.bounds];
        _emptyView.iconImageView.image = [UIImage imageNamed:@"hb_emptu_icon.png"];
        _emptyView.titleLabel.text = @"暂无商家投放红包";
        _emptyView.yOffset = 20;
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
- (YTDetailActionView *)topDeatilView
{
    if (!_topDeatilView) {
        _topDeatilView = [[YTDetailActionView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
    }
    return _topDeatilView;
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
