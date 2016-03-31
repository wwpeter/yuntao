#import "CStoreOrderConfirmViewController.h"
#import "YTPayHeadView.h"
#import "HbIntroModel.h"
#import "OrderCellHeadView.h"
#import "OrderCellFootView.h"
#import "HbOrderConfirmTableCell.h"
#import "UIImage+HBClass.h"
#import "StoryBoardUtilities.h"
#import "StoryBoardUtilities.h"
#import "YTNetworkMange.h"
#import "PayUtil.h"
#import "PaySuccessViewController.h"
#import "MBProgressHUD+Add.h"

static NSString *CellIdentifier = @"StoreOrderConfirmCellIdentifier";

@interface CStoreOrderConfirmViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)YTPayHeadView *payHeadView;
@property (strong, nonatomic)UIButton *bookingButton;
@property (strong, nonatomic)NSString *shopName;
@property (strong, nonatomic)NSNumber *shopId;
@property (assign, nonatomic)CGFloat totalCost;
@end

@implementation CStoreOrderConfirmViewController

#pragma mark - Life cycle
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (instancetype)initWithShopName:(NSString *)name shopId:(NSNumber *)shopId hbConfirmOrders:(NSArray *)confirmOrders
{
    self = [super init];
    if (self) {
        _shopName = name;
        _shopId = shopId;
        _confirmOrders = confirmOrders;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.navigationItem.title = @"订单确认";
    [self initializePageSubviews];
    [self initializeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _confirmOrders.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44+15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderCellHeadView *headView = [[OrderCellHeadView alloc] init];
    headView.titleLabel.text = _shopName;
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderCellFootView *footView = [[OrderCellFootView alloc] init];
    
    NSString *hbNumberStr = [NSString stringWithFormat:@"%@",@( _confirmOrders.count)];
    NSMutableAttributedString* numAttributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@个红包",hbNumberStr]];
    [numAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(1, hbNumberStr.length)];
    footView.titleLabel.attributedText = numAttributedStr;
    
    NSString *costStr = [NSString stringWithFormat:@"%@",@(self.totalCost)];
    NSMutableAttributedString* costAttributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金额:￥%@",costStr]];
    [costAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(3, costStr.length+1)];
    [costAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(3, costStr.length+1)];
    footView.rightLabel.attributedText = costAttributedStr;
    return footView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HbOrderConfirmTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    HbIntroModel *hbModel = _confirmOrders[indexPath.row];
    [cell configHbOrderConfirmCellModel:hbModel];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
#pragma mark - Event response
- (void)bookingButtonClicked:(id)sender
{
    NSDictionary *parameter = @{@"shopId":@(self.shopId.integerValue),
                                @"amount":@(self.price.integerValue)};
    switch (_payHeadView.payMode) {
        case YTPayModeWx:
            [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_Weixinpay parameters:parameter success:^(id responseData) {
                
            } failure:^(NSString *errorMessage) {
                
            }];
            break;
        case YTPayModeZfb:
        {
            [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
            [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_Alipay parameters:parameter success:^(id responseData) {
                self.payReturnDic = responseData;
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                [[PayUtil sharedPayUtil] alipayOrder:responseData[@"data"][@"payInfo"] blackBlock:^(NSDictionary * dic) {
                    if ([dic[@"resultStatus"] integerValue] == 9000) {
                        PaySuccessViewController *paySuccessVC = [StoryBoardUtilities viewControllerForMainStoryboard:[PaySuccessViewController class]];
                        paySuccessVC.hiddenLeftBtn = YES;
                        paySuccessVC.receiveType = NoReceive;
                        paySuccessVC.navigationItem.leftItemsSupplementBackButton = NO;
                        paySuccessVC.passArr = _confirmOrders;
                        paySuccessVC.orderStr = _payReturnDic[@"data"][@"payOrder"][@"toOuterId"];
                        paySuccessVC.orderId = _payReturnDic[@"data"][@"payOrder"][@"id"];
                        [self.navigationController pushViewController:paySuccessVC animated:YES];
                    }
                }];
                
            } failure:^(NSString *errorMessage) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:errorMessage toView:self.view];
            }];
        }
            break;
        default:
            break;
    }
}
#pragma mark - Public methods
#pragma mark - Private methods
#pragma mark - Page subviews
- (void)initializeData
{
    self.totalCost = 0;
    for (HbIntroModel *model in self.confirmOrders) {
        CGFloat cost = [model.cost doubleValue] ;
        self.totalCost += cost;
    }
    NSString *costStr = [NSString stringWithFormat:@"%.2f",(self.price.floatValue / 100)];
    NSMutableAttributedString* costAttributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总价:￥%.2f",(self.price.floatValue / 100)]];
    [costAttributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(3, costStr.length+1)];
    [costAttributedStr addAttribute:NSForegroundColorAttributeName value:YTDefaultRedColor range:NSMakeRange(3, costStr.length+1)];
    self.payHeadView.costLabel.attributedText = costAttributedStr;
}
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bookingButton];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-50);
    }];
    [_bookingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 165+15)];
    [headView addSubview:self.payHeadView];
    self.tableView.tableHeaderView = headView;
}
#pragma mark - Getters & Setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 60;
        [_tableView registerClass:[HbOrderConfirmTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (YTPayHeadView *)payHeadView
{
    if (!_payHeadView) {
        _payHeadView = [[YTPayHeadView alloc] initWithFrame:CGRectMake(0, 15, kDeviceWidth, 105+60)];
        _payHeadView.titleLabel.text = @"选择支付方式";
    }
    return _payHeadView;
}
- (UIButton *)bookingButton
{
    if (!_bookingButton) {
        _bookingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bookingButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_bookingButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfd5c63)] forState:UIControlStateNormal];
        [_bookingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bookingButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [_bookingButton addTarget:self action:@selector(bookingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bookingButton;
}

@end
