#import "CDealPayRefundSuccessViewController.h"
#import "YTTradeRefundModel.h"
#import "PayRefundHeadView.h"

@interface CDealPayRefundSuccessViewController ()

@end

@implementation CDealPayRefundSuccessViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.navigationItem.title = @"退款成功";
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"done") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    PayRefundHeadView *headView = [[PayRefundHeadView alloc] init];
    headView.titleLabel.text = @"退款成功";
    headView.amountLabel.text = [NSString stringWithFormat:@"退款金额:%@",self.amount];
    headView.orderLabel.text = [NSString stringWithFormat:@"退款单:%@",self.trade.toOuterId];
    headView.timeLabel.text = [NSString stringWithFormat:@"退款时间:%@",[YTTaskHandler outDateStrWithTimeStamp:self.trade.createdAt withStyle:@"yyyy-MM-dd HH:mm:ss"]];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(110);
    }];
}
@end
