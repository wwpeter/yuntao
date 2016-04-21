#import "PromotionHbDetailViewController.h"
#import "HbDetailHeadView.h"
#import "HbDetailModel.h"
#import "UIView+DKAddition.h"
#import "NSStrUtil.h"
#import "PromotionHbSignBuyView.h"
#import "YTHongbaoDetailModel.h"
#import "YTHongbaoStoreHelper.h"
#import "MBProgressHUD+Add.h"
#import "YTOrderModel.h"
#import "HbOrderConfirmViewController.h"
#import "HbStoreStatsView.h"
#import "HbSelectListViewController.h"
#import "StoryBoardUtilities.h"
#import "HbDetailNotesView.h"
#import "CHbDetailAddressView.h"
#import "UIViewController+Helper.h"

static const NSInteger kHeaderHeight = 260;

@interface PromotionHbDetailViewController ()<PromotionHbSignBuyViewDelegate,HbStoreStatsViewDelegate,HbSelectListViewControllerDelegate>

@property (strong, nonatomic) NSString *hbId;
@property (strong, nonatomic) UIScrollView *scrollView;
// 购买View
@property (strong, nonatomic) PromotionHbSignBuyView *signBuyView;
// 下方统计View
@property (strong, nonatomic) HbStoreStatsView *statsView;

@property (strong, nonatomic) YTUsrHongBao *hongbao;

@end

@implementation PromotionHbDetailViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithHbId:(NSString *)hbId
{
    self = [super init];
    if (self) {
        _hbId = hbId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"红包详情";
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    
    [self initializePageSubviews];
    self.requestParas = @{@"hongbaoId" : _hbId,
                          loadingKey : @(YES)};
    self.requestURL = hongbaoInfoURL;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -override fetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
     if (parserObject.success) {
          YTHongbaoDetailModel *hongbaoDetailModel = (YTHongbaoDetailModel *)parserObject;
         self.hongbao = hongbaoDetailModel.hongbao;
         for (YTUsrHongBao *selectHongbao in [YTHongbaoStoreHelper hongbaoStoreHelper].hbArray) {
             if ([selectHongbao.hongbaoId isEqualToString:self.hongbao.hongbaoId]) {
                 self.hongbao.buyNum = selectHongbao.buyNum;
                 break;
             }
         }
         [self setupDeatilView];
         [self setupSignBuyViewText];
         [self setupStatsViewText];
     }else{
         [MBProgressHUD showError:parserObject.message toView:self.view];
     }
}

#pragma mark - PromotionHbSignBuyViewDelegate
- (void)promotionHbSignBuyView:(PromotionHbSignBuyView *)view textFieldDidEndEditing:(UITextField *)textField
{
    self.hongbao.buyNum = [NSNumber numberWithInteger:[textField.text integerValue]];
    [self setupUserChangeHongbao];
}
- (void)promotionHbSignBuyViewDidAddHb:(PromotionHbSignBuyView *)view
{
    NSInteger butInt = self.hongbao.buyNum.integerValue;
    butInt += 1;
    self.hongbao.buyNum = [NSNumber numberWithInteger:butInt];
    [self setupUserChangeHongbao];
}
- (void)promotionHbSignBuyViewDidMinushb:(PromotionHbSignBuyView *)view
{
    if (self.hongbao.buyNum.integerValue == 0) {
        return;
    }
    NSInteger butInt = self.hongbao.buyNum.integerValue;
    butInt -= 1;
    self.hongbao.buyNum = [NSNumber numberWithInteger:butInt];
    [self setupUserChangeHongbao];
}
- (void)promotionHbSignBuyViewAskAction:(PromotionHbSignBuyView *)view
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉,您不能购买同行业红包" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}
#pragma mark -HbStoreStatsViewDelegate
- (void)hbStoreStatsView:(HbStoreStatsView *)view clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        HbSelectListViewController *selectListVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbSelectListViewController class]];
        selectListVC.delegate = self;
        [self.navigationController pushViewController:selectListVC animated:YES];
    } else {
        NSDictionary *orderDic = [[YTHongbaoStoreHelper hongbaoStoreHelper] setupConfimOrder];
        HbOrderConfirmViewController *orderConfirmVC = [[HbOrderConfirmViewController alloc] init];
        YTOrderModel *orderModel = [[YTOrderModel alloc] initWithJSONDict:orderDic];
        orderConfirmVC.orderArray = [[NSArray alloc] initWithArray:orderModel.orderSet.records];
        [self.navigationController pushViewController:orderConfirmVC animated:YES];
    }
}
#pragma mark -HbSelectListViewControllerDelegate
- (void)hbSelectListViewControllerDidChangeStoreHbs:(HbSelectListViewController *)viewController
{
    [self setupShowStatsView];
}
- (void)setupShowStatsView {
    if ([YTHongbaoStoreHelper hongbaoStoreHelper].hbArray.count == 0 ) {
        self.statsView.hidden = YES;
        return;
    }
    self.statsView.hidden = NO;
    int countPrice = 0;
    int countNum = 0;
    for(YTUsrHongBao *hongbao in [YTHongbaoStoreHelper hongbaoStoreHelper].hbArray) {
        countNum += hongbao.buyNum.integerValue;
        countPrice += (hongbao.buyNum.integerValue *hongbao.price);
    }
    self.statsView.badgeText = [NSString stringWithFormat:@"%d",countNum];
    self.statsView.cost = [NSString stringWithFormat:@"%.2f",countPrice/100.];
}
#pragma mark - Event response
- (void)scrollHandleTap:(UITapGestureRecognizer *)tap
{
    [self.signBuyView endEditing:YES];
}
#pragma mark - Private methods
- (void)setupUserChangeHongbao
{
    BOOL isAtStoreModels = NO;
    for (NSInteger i = 0; i < [YTHongbaoStoreHelper hongbaoStoreHelper].hbArray.count; i++) {
        YTUsrHongBao* hongbao = [YTHongbaoStoreHelper hongbaoStoreHelper].hbArray[i];
        if (hongbao.hongbaoId.integerValue == self.hongbao.hongbaoId.integerValue) {
            isAtStoreModels = YES;
            if (self.hongbao.buyNum.integerValue > 0) {
                [[YTHongbaoStoreHelper hongbaoStoreHelper].hbArray replaceObjectAtIndex:i withObject:self.hongbao];
            }
            else {
                [[YTHongbaoStoreHelper hongbaoStoreHelper].hbArray removeObjectAtIndex:i];
            }
            break;
        }
    }
    if (!isAtStoreModels && self.hongbao.buyNum.integerValue > 0) {
        [[YTHongbaoStoreHelper hongbaoStoreHelper].hbArray addObject:self.hongbao];
    }
    [self setupShowStatsView];
    [self setupStatsViewText];
}
- (void)setupStatsViewText
{
    self.statsView.hidden = self.hongbao.buyNum.integerValue == 0 ? YES : NO;
    self.signBuyView.textFiled.text = [NSString stringWithFormat:@"%@",@(self.hongbao.buyNum.integerValue)];
//    CGFloat totalPrice = self.hongbao.buyNum.integerValue*self.hongbao.price;
//    self.statsView.cost = [NSString stringWithFormat:@"%.2f",totalPrice/100];
}
- (void)toOrderConfirm
{
    NSDictionary *orderDic = [[YTHongbaoStoreHelper hongbaoStoreHelper] setupConfimOrder];
    HbOrderConfirmViewController *orderConfirmVC = [[HbOrderConfirmViewController alloc] init];
    YTOrderModel *orderModel = [[YTOrderModel alloc] initWithJSONDict:orderDic];
    orderConfirmVC.orderArray = [[NSArray alloc] initWithArray:orderModel.orderSet.records];
    [self.navigationController pushViewController:orderConfirmVC animated:YES];
}
#pragma mark - Page subviews
- (void)setupSignBuyViewText
{
    NSString *str = [NSString stringWithFormat:@"￥%@/个 库存%@个",@(self.hongbao.price*0.01),@(self.hongbao.remainNum)];
    NSString *priseStr = [NSString stringWithFormat:@"%@",@(self.hongbao.price*0.01)];
    NSMutableAttributedString* attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, priseStr.length+1)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:YTDefaultRedColor range:NSMakeRange(0, priseStr.length+1)];
    self.signBuyView.costLabel.attributedText = attributedStr;
}
- (void)setupDeatilView
{
    // 详情View
    UIView *hbHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kHeaderHeight+50)];
    hbHeadView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:hbHeadView];
    
    CGFloat detailMaxWidth = CGRectGetWidth(hbHeadView.bounds);
    HbDetailHeadView *headView = [[HbDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, detailMaxWidth, kHeaderHeight)];
    [headView configDetailHeadViewWithUsrHongBao:self.hongbao];
    [hbHeadView addSubview:headView];
    
    // 输入框
    [hbHeadView addSubview:self.signBuyView];
    if (self.hongbao.status != YTDRAINAGESTATUS_PASS || [[YTUsr usr].shop.catId isEqualToString:self.hongbao.shop.catId]) {
        self.signBuyView.disableField = YES;
        if ([[YTUsr usr].shop.catId isEqualToString:self.hongbao.shop.catId]) {
            self.signBuyView.displaySameOccupation = YES;
        }
    }

    // 地址
    CHbDetailAddressView* addressView = [[CHbDetailAddressView alloc] initWithFrame:CGRectMake(0, hbHeadView.dk_bottom + 15, detailMaxWidth, 100)];
    addressView.shopLabel.text =  self.hongbao.shop.name;
    addressView.addressLabel.text = self.hongbao.shop.address;
    __weak __typeof(self) weakSelf = self;
    addressView.selectBlock = ^(NSInteger selectIndex) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (selectIndex == 0) {
            [weakSelf callPhoneNumber:strongSelf.self.hongbao.shop.mobile];
        }
        else {
            CLLocationCoordinate2D to = CLLocationCoordinate2DMake(self.hongbao.shop.lat, self.hongbao.shop.lon);
            [weakSelf openNavigation:to destinationNamen:self.hongbao.shop.name];
        }
    };
    [self.scrollView addSubview:addressView];
    
    HbDetailNotesView *notesView = [[HbDetailNotesView alloc] initWithUsrHongBao:self.hongbao frame:CGRectMake(0, addressView.dk_bottom+15, CGRectGetWidth(self.view.bounds), 0)];
    [notesView fitOptimumSize];
    [self.scrollView addSubview:notesView];
    self.scrollView.contentSize = CGSizeMake(0, notesView.dk_bottom+84);
}
- (void)initializePageData
{
//    self.statsView.cost = @"0";
    [self setupShowStatsView];
}
- (void)initializePageSubviews
{
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.statsView];
    [self initializePageData];
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(scrollHandleTap:)]];
}

#pragma mark - Getters & Setters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(0, 1000);
    }
    return _scrollView;
}
- (PromotionHbSignBuyView *)signBuyView
{
    if (!_signBuyView) {
        _signBuyView = [[PromotionHbSignBuyView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kDeviceWidth, 50)];
        _signBuyView.delegate = self;
    }
    return _signBuyView;
}
- (HbStoreStatsView *)statsView
{
    if (!_statsView) {
        _statsView = [[HbStoreStatsView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.bounds)-50-64), kDeviceWidth, 50)];
        _statsView.delegate = self;
        _statsView.hidden = YES;
    }
    return _statsView;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
