

#import "UIImage+HBClass.h"
#import "YTPromotionModel.h"
#import "PromotionHbIntroView.h"
#import "PromotionHbNumberView.h"
#import "YTYellowBackgroundView.h"
#import "PromotionHbViewController.h"
#import "PromotionHbDetailViewController.h"

@interface PromotionHbViewController ()

@property (strong, nonatomic) UIButton* buyButton;
@property (strong, nonatomic) PromotionHbIntroView* hbIntroView;
@property (strong, nonatomic) PromotionHbNumberView* hbNumberView;
@property (strong, nonatomic) YTYellowBackgroundView* yellowHeadView;
@end

@implementation PromotionHbViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)pushToHbDetailViewController
{
    PromotionHbDetailViewController* hbDetailVC = [[PromotionHbDetailViewController alloc] initWithHbId:self.promotionHongbao.hongbaoId];
    [self.navigationController pushViewController:hbDetailVC animated:YES];
}
#pragma mark - Event response
- (void)buyButtonClicked:(id)sender
{
    [self pushToHbDetailViewController];
}
- (void)hbIntroViewTap:(UITapGestureRecognizer*)tap
{
    [self pushToHbDetailViewController];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.yellowHeadView];
    [self.view addSubview:self.hbIntroView];
    [self.view addSubview:self.hbNumberView];
    [self.view addSubview:self.buyButton];
    CGFloat statusHeight = self.promotionHongbao.status == YTSHOPBUYHBSTATUS_SOONNO ? 30 : 0;

    [_yellowHeadView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(64);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(statusHeight);
    }];
    [_hbIntroView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(_yellowHeadView.bottom);
        make.height.mas_equalTo(120);
    }];
    [_hbNumberView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(_hbIntroView.bottom).offset(15);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(140);
    }];
    [_buyButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];

    [self.hbIntroView configPromotionHbIntroViewWithModel:self.promotionHongbao];
    [self.hbNumberView configPromotionHbNumberViewWithModel:self.promotionHongbao];
    if (self.promotionHongbao.status == YTSHOPBUYHBSTATUS_CLOSED ||
        self.promotionHongbao.status == YTSHOPBUYHBSTATUS_STOCK) {
        self.buyButton.hidden = YES;
    }
    [self.hbIntroView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hbIntroViewTap:)]];
}

#pragma mark - Getters & Setters
- (YTYellowBackgroundView*)yellowHeadView
{
    if (!_yellowHeadView) {
        _yellowHeadView = [[YTYellowBackgroundView alloc] init];
        _yellowHeadView.textLabel.text = @"红包很受欢迎,即将被领完,赶快在补一些吧";
    }
    return _yellowHeadView;
}
- (PromotionHbIntroView*)hbIntroView
{
    if (!_hbIntroView) {
        _hbIntroView = [[PromotionHbIntroView alloc] init];
    }
    return _hbIntroView;
}
- (PromotionHbNumberView*)hbNumberView
{
    if (!_hbNumberView) {
        _hbNumberView = [[PromotionHbNumberView alloc] init];
    }
    return _hbNumberView;
}
- (UIButton*)buyButton
{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_buyButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfd5c63)] forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyButton setTitle:@"购买更多" forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}
@end
