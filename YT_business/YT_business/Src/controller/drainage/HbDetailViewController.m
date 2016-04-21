
#import "YTDrainageDetailModel.h"
#import "HbDetailViewController.h"
#import "HbDetailHeadView.h"
#import "HbDetailModel.h"
#import "UIView+DKAddition.h"
#import "HbDetaiDescribeView.h"
#import "NSStrUtil.h"
#import "HbDetailRuleView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+HBClass.h"
#import "THMerchantUnPassViewController.h"
#import "UIAlertView+TTBlock.h"
#import "UIViewController+YTUrl.h"
#import "MBProgressHUD+Add.h"
#import "YTHongbaoDetailModel.h"
#import "ShopDetailViewController.h"
#import "HbDetailNotesView.h"
#import "HbDetailRecommendView.h"
#import "CHbDetailAddressView.h"
#import "UIViewController+Helper.h"

static const NSInteger kDefaultLeftPadding = 10;
static const NSInteger kHeaderHeight = 260;

@interface HbDetailViewController ()

@property (strong, nonatomic) UIScrollView* scrollView;
// 底部按钮
@property (strong, nonatomic) UIButton* bottomButton;

@end

@implementation HbDetailViewController

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
    self.navigationItem.title = @"红包详情";
    [self initializePageSubviews];
    if (_drainageDetail) {
        [self setupDeatilView];
    } else if (_hbId) {
        self.requestParas = @{ @"id" : _hbId,
            loadingKey : @(YES) };
        self.requestURL = saleHongbaoDetailURL;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -override fetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:saleHongbaoDetailURL]) {
            YTDrainageDetailModel *drainageDetailModel = (YTDrainageDetailModel *)parserObject;
            self.drainageDetail = drainageDetailModel.drainageDetail;
            [self setupDeatilView];
        }
    }
    else {
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
}

#pragma mark - Event response
- (void)bottomButtonClicked:(id)sender
{
    wSelf(wSelf);
    if (self.drainageDetail.hongbao.status == YTDRAINAGESTATUS_PRECONFIRMSHOP) {
        NSDictionary* parameters = @{ @"id" : self.drainageDetail.hongbao.indexId,
            loadingKey : @(YES) };
        [self postRequestParas:parameters
            requestURL:confirmHongbaoURL
            success:^(AFHTTPRequestOperation* operation, YTBaseModel* parserObject) {
                if (parserObject.success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kHbSoldOutNotification object:self];
                    });
                    [wSelf.navigationController popToRootViewControllerAnimated:YES];
                }
                else {
                    [MBProgressHUD showError:parserObject.message toView:self.view];
                }
            }
            failure:^(NSString* errorMessage){

            }];
    }
    else if (self.drainageDetail.hongbao.status == YTDRAINAGESTATUS_PASS) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"红包下架后,再次上架需要重新创建红包,申请下架后未购买的红包会下架。是否确定下架?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

        [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                THMerchantUnPassViewController* unPassVC = [[THMerchantUnPassViewController alloc] initWithStyle:UITableViewStyleGrouped];
                unPassVC.unId = wSelf.drainageDetail.hongbao.indexId;
                unPassVC.dataArray = @[ @"红包引流效果差", @"调整促销红包", @"商家停业/装修", @"其他" ];
                [wSelf.navigationController pushViewController:unPassVC animated:YES];
            }
        }];
        [alert show];
    }
}
#pragma mark - Public methods
#pragma mark - Private methods
- (void)setupDeatilView
{
    // 详情View
    CGFloat detailMaxWidth = CGRectGetWidth(self.view.bounds);
    UIView* hbHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, detailMaxWidth, kHeaderHeight + 15)];
    hbHeadView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:hbHeadView];

    HbDetailHeadView* headView = [[HbDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, detailMaxWidth, kHeaderHeight)];
    [headView configDetailHeadViewWithCommonHongBao:self.drainageDetail.hongbao];
    [hbHeadView addSubview:headView];

    UIImageView* bottonLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    bottonLine.frame = CGRectMake(0, hbHeadView.dk_height - 1, detailMaxWidth, 1);
    [hbHeadView addSubview:bottonLine];
    
    // 地址
    CHbDetailAddressView* addressView = [[CHbDetailAddressView alloc] initWithFrame:CGRectMake(0, hbHeadView.dk_bottom + 15, detailMaxWidth, 100)];
    addressView.shopLabel.text =  self.drainageDetail.hongbao.shop.name;
    addressView.addressLabel.text = self.drainageDetail.hongbao.shop.address;
    __weak __typeof(self) weakSelf = self;
    addressView.selectBlock = ^(NSInteger selectIndex) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (selectIndex == 0) {
            [weakSelf callPhoneNumber:strongSelf.drainageDetail.hongbao.shop.mobile];
        }
        else {
            CLLocationCoordinate2D to = CLLocationCoordinate2DMake(self.drainageDetail.hongbao.shop.lat, self.drainageDetail.hongbao.shop.lon);
            [weakSelf openNavigation:to destinationNamen:self.drainageDetail.hongbao.shop.name];
        }
    };
    [self.scrollView addSubview:addressView];

    HbDetailNotesView* notesView = [[HbDetailNotesView alloc] initWithUsrHongBao:(YTUsrHongBao*)self.drainageDetail.hongbao frame:CGRectMake(0, addressView.dk_bottom + 15, CGRectGetWidth(self.view.bounds), 0)];
    [notesView fitOptimumSize];
    [self.scrollView addSubview:notesView];
    self.scrollView.contentSize = CGSizeMake(0, notesView.dk_bottom + 100);

    if (self.controllerMode == HbDetailViewModeStore) {
        if (self.drainageDetail.recommendShop.count > 0) {
            [self setupStoresViewWithTop:notesView.dk_bottom + 15];
        }
        else {
            [self setupBottomButtonWithTop:notesView.dk_bottom + 15];
        }
    }
}
- (void)setupStoresViewWithTop:(CGFloat)top
{
    HbDetailRecommendView* recommendView = [[HbDetailRecommendView alloc] initWithRecommendShop:self.drainageDetail.recommendShop frame:CGRectMake(0, top, CGRectGetWidth(self.view.bounds), 144)];
    __weak __typeof(self)weakSelf = self;
    recommendView.shopSelectBlock = ^(YTCommonShop *commonShop){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        ShopDetailViewController* shopDetailVC = [[ShopDetailViewController alloc] initWithShopId:commonShop.shopId];
        [strongSelf.navigationController pushViewController:shopDetailVC animated:YES];
    };
    
    [self.scrollView addSubview:recommendView];
    self.scrollView.contentSize = CGSizeMake(0, recommendView.dk_bottom + 84);
    [self setupBottomButtonWithTop:recommendView.dk_bottom + 15];
}
- (void)setupBottomButtonWithTop:(CGFloat)top
{
    if (self.drainageDetail.hongbao.status == YTDRAINAGESTATUS_PRECONFIRMSHOP || self.drainageDetail.hongbao.status == YTDRAINAGESTATUS_PASS) {
        [self.scrollView addSubview:self.bottomButton];
        self.bottomButton.frame = CGRectMake(kDefaultLeftPadding, top, CGRectGetWidth(self.view.bounds) - (2 * kDefaultLeftPadding), 45);
        if (self.drainageDetail.hongbao.status == YTDRAINAGESTATUS_PRECONFIRMSHOP) {
            [self.bottomButton setTitle:@"确认" forState:UIControlStateNormal];
        }
        else if (self.drainageDetail.hongbao.status == YTDRAINAGESTATUS_PASS) {
            [self.bottomButton setTitle:@"申请下架" forState:UIControlStateNormal];
        }
        self.scrollView.contentSize = CGSizeMake(0, self.bottomButton.dk_bottom + 84);
    }
}
#pragma mark - Notification Response
#pragma mark - Navigation
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.scrollView];
}

#pragma mark - Getters & Setters

- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(0, 1000);
    }
    return _scrollView;
}
- (UIButton*)bottomButton
{
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _bottomButton.layer.masksToBounds = YES;
        _bottomButton.layer.cornerRadius = 3.0;
        [_bottomButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_bottomButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:0.9f alpha:1.0]] forState:UIControlStateHighlighted];
        [_bottomButton setTitleColor:CCCUIColorFromHex(0xfd5c63) forState:UIControlStateNormal];
        [_bottomButton addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
