#import "AboutusViewController.h"
#import "RGActionView.h"
#import "OutWebViewController.h"
#import "OutWebViewController.h"
#import "UIViewController+Helper.h"

static const NSInteger kAgreementViewTag = 1000;
static const NSInteger kStrategyViewTag = 1001;
static const NSInteger kServiceViewTag = 1002;

static NSString *const YT_Service_Strategy = @"http://biz.strategy.yuntaohongbao.com";
static NSString *const YT_Service_Agreement = @"http://biz.protocol.yuntaohongbao.com";

@interface AboutusViewController ()<RGActionViewDelegate>

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) RGActionView *agreementView;
@property (strong, nonatomic) RGActionView *strategyView;
@property (strong, nonatomic) RGActionView *serviceView;
@property (strong, nonatomic) UILabel *companyLabel;

@property (assign, nonatomic) CGFloat actionViewHeight;

@end

@implementation AboutusViewController

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
    self.navigationItem.title = @"关于我们";
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - RGActionViewDelegate
- (void)rgactionViewDidClicked:(RGActionView *)actionView
{
    if (actionView.tag == kAgreementViewTag || actionView.tag == kStrategyViewTag) {
        OutWebViewController *webVC = [[OutWebViewController alloc] initWithNibName:@"OutWebViewController" bundle:nil];
        webVC.urlStr = actionView.tag == kAgreementViewTag ? YT_Service_Agreement :YT_Service_Strategy;
        [self.navigationController pushViewController:webVC animated:YES];
    } else {
        [self callPhoneNumber:YT_Service_Number];
    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    self.actionViewHeight = iPhone4 ? 250 : 308;
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.agreementView];
    [self.view addSubview:self.strategyView];
    [self.view addSubview:self.serviceView];
    [self.view addSubview:self.companyLabel];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50+64);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
    }];
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-30);
        make.left.right.mas_equalTo(self.view);
    }];
}
#pragma mark - Getters & Setters
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
         _iconImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_business_logo_02.png"]];
    }
    return _iconImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = UILabel.new;
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = CCCUIColorFromHex(0x666666);
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = @"云淘红包V1.3.8";
    }
    return _nameLabel;
}
- (RGActionView *)agreementView
{
    if (!_agreementView) {
        _agreementView = [[RGActionView alloc] initWithTitle:@"云淘红包商户协议" frame:CGRectMake(0, _actionViewHeight, kDeviceWidth, 50)];
        _agreementView.tag = kAgreementViewTag;
        _agreementView.delegate = self;
        _agreementView.displayTopLine = YES;
//        _agreementView.leftMargin = 0;
        _agreementView.backgroundColor = [UIColor whiteColor];
    }
    return _agreementView;
}
- (RGActionView *)strategyView
{
    if (!_strategyView) {
        _strategyView = [[RGActionView alloc] initWithTitle:@"云淘红包商户攻略" frame:CGRectMake(0, _actionViewHeight+50, kDeviceWidth, 50)];
        _strategyView.tag = kStrategyViewTag;
        _strategyView.delegate = self;
        _strategyView.backgroundColor = [UIColor whiteColor];
    }
    return _strategyView;
}
- (RGActionView *)serviceView
{
    if (!_serviceView) {
        _serviceView = [[RGActionView alloc] initWithTitle:@"客服热线" frame:CGRectMake(0, _actionViewHeight+100, kDeviceWidth, 50)];
        _serviceView.tag = kServiceViewTag;
        _serviceView.delegate = self;
        _serviceView.leftMargin = 0;
        _serviceView.backgroundColor = [UIColor whiteColor];
    }
    return _serviceView;
}
- (UILabel *)companyLabel
{
    if (!_companyLabel) {
        _companyLabel = UILabel.new;
        _companyLabel.numberOfLines = 1;
        _companyLabel.font = [UIFont systemFontOfSize:13];
        _companyLabel.textColor = CCCUIColorFromHex(0x666666);
        _companyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _companyLabel.textAlignment = NSTextAlignmentCenter;
        _companyLabel.text = @"杭州赛融有限公司版权所有";
    }
    return _companyLabel;
}
@end
