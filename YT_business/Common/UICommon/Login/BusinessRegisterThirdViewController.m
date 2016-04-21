
#import "BusinessRegisterThirdViewController.h"
#import "TopRedView.h"
#import "RGTextCodeView.h"
#import "YTRegisterHelper.h"
#import "UIViewController+Helper.h"
#import "OutWebViewController.h"
#import "BusinessRegisterSecondViewController.h"
#import "YTCityMatch.h"
#import "RGFieldView.h"
#import "UIView+BlockGesture.h"

static NSString* const YT_Service_Agreement = @"http://biz.protocol.yuntaohongbao.com";
static const NSInteger kTextFieldTag = 2000;

@interface BusinessRegisterThirdViewController () <UITextFieldDelegate,RGFieldViewDelegate>

@property (strong, nonatomic) UIScrollView*scrollView;
@property (strong, nonatomic) RGTextCodeView* rgView;
@property (strong, nonatomic) UITextField* legalField;
@property (strong, nonatomic) UIButton* clickBtn;
@property (strong, nonatomic) UIButton* agreementBtn;
@property (strong, nonatomic) UILabel* wordLabel;
@property (strong, nonatomic) RGFieldView *accountView;
@property (strong, nonatomic) RGFieldView *bankView;
@end

@implementation BusinessRegisterThirdViewController

#pragma mark - Life cycle
- (id)init
{
    if ((self = [super init])) {
        self.navigationItem.title = @"注册2/3";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"下一步", @"Next") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializePageSubviews];
    [self requestMatchCityZoneid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:cityMatchURL]) {
            YTCityMatchModel* cityModel = (YTCityMatchModel*)parserObject;
            [YTRegisterHelper registerHelper].zoneId = cityModel.cityMatch.zoneId;
        }
    }
    else {
        [self showAlert:parserObject.message title:@""];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self.accountView.textFiled becomeFirstResponder];
    return YES;
}
#pragma mark - RGFieldViewDelegate
- (void)rgfiledView:(RGFieldView *)filedView textFieldShouldBeginEditing:(UITextField *)textField
{
    CGPoint pointInView = [filedView.superview convertPoint:filedView.frame.origin toView:self.view];
    CGFloat bottomHeight = CGRectGetHeight(self.view.bounds)-pointInView.y-50;
    if (bottomHeight < 286) {
        CGPoint contentOffset = self.scrollView.contentOffset;
        contentOffset.y += 286-bottomHeight+50;
        [self.scrollView setContentOffset:contentOffset animated:YES];
    }
}
- (void)rgfiledView:(RGFieldView *)filedView textFieldShouldReturn:(UITextField *)textField
{
    if (filedView == _accountView) {
        [self.bankView.textFiled becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
}
#pragma mark - Private methods
- (void)requestMatchCityZoneid
{
    self.requestParas = @{ @"provinceString" : [YTRegisterHelper registerHelper].province,
        @"cityString" : [YTRegisterHelper registerHelper].city,
        @"areaString" : [YTRegisterHelper registerHelper].district };
    self.requestURL = cityMatchURL;
}
- (void)toRegisterThirdView
{
    BOOL isValid = [_rgView checkTextDidInEffect];
    if (!isValid) {
        return;
    }
    [self.view endEditing:YES];
    [YTRegisterHelper registerHelper].mobile = _rgView.phoneField.text;
    [YTRegisterHelper registerHelper].password = _rgView.psdField.text;
    [YTRegisterHelper registerHelper].checkCode = _rgView.codeField.text;
    [YTRegisterHelper registerHelper].legalPerson = _legalField.text;
    BusinessRegisterSecondViewController* registerSecondVC = [[BusinessRegisterSecondViewController alloc] init];
    [self.navigationController pushViewController:registerSecondVC animated:YES];
}
#pragma mark - Event response
- (void)clickBtnPre:(id)sender
{
    if (self.navigationItem.rightBarButtonItem.enabled) {
        [_clickBtn setImage:[UIImage imageNamed:@"yt_register_selectBtn_cancel.png"] forState:UIControlStateNormal];
    }
    else {
        [_clickBtn setImage:[UIImage imageNamed:@"yt_register_selectBtn_select.png"] forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem.enabled = !self.navigationItem.rightBarButtonItem.enabled;
}

- (void)agreementBtnPre:(id)sender
{
    OutWebViewController* webVC = [[OutWebViewController alloc] initWithURL:YT_Service_Agreement title:@"用户协议" isShowRight:NO];
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self toRegisterThirdView];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    TopRedView* redView = [[TopRedView alloc] init];
    redView.index = 2;
    [self.view addSubview:redView];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    UIView* contentView = [[UIView alloc] init];
    [self.scrollView addSubview:contentView];
    
    [redView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(10);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.and.bottom.mas_equalTo(self.view);
    }];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
    }];
    
    wSelf(wSelf);
    _rgView = [[RGTextCodeView alloc] init];
    _rgView.validCodeBlock = ^(NSString* mobile) {
        if (!wSelf) {
            return;
        }
        __strong typeof(wSelf) sSelf = wSelf;
        sSelf.requestParas = @{ @"mobile" : mobile };
        sSelf.requestURL = sendRegCodeURL;
    };
    [contentView addSubview:_rgView];

    UIView* legalView = [[UIView alloc] init];
    legalView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:legalView];
    UIImageView* accBottomLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    [legalView addSubview:accBottomLine];

    UIImageView* accLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    accLeftImageView.image = [UIImage imageNamed:@"yt_register_name.png"];
    _legalField = [[UITextField alloc] init];
    _legalField.delegate = self;
    _legalField.borderStyle = UITextBorderStyleNone;
    _legalField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _legalField.returnKeyType = UIReturnKeyNext;
    _legalField.leftViewMode = UITextFieldViewModeAlways;
    _legalField.enablesReturnKeyAutomatically = YES;
    _legalField.leftView = accLeftImageView;
    _legalField.placeholder = @"对公账号 (若没有对公账号则不填)";
    _legalField.tag = kTextFieldTag;
    [legalView addSubview:_legalField];

    UIView* inviteView = [[UIView alloc] init];
    inviteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:inviteView];

    UIImageView* inviteBottomLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    [inviteView addSubview:inviteBottomLine];
    _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clickBtn setImage:[UIImage imageNamed:@"yt_register_selectBtn_select.png"] forState:UIControlStateNormal];
    [_clickBtn addTarget:self action:@selector(clickBtnPre:) forControlEvents:UIControlEventTouchUpInside];

    _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreementBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _agreementBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_agreementBtn setTitle:@"《商户协议》" forState:UIControlStateNormal];
    [_agreementBtn setBackgroundColor:[UIColor clearColor]];
    [_agreementBtn addTarget:self action:@selector(agreementBtnPre:) forControlEvents:UIControlEventTouchUpInside];

    _wordLabel = [[UILabel alloc] init];
    _wordLabel.font = [UIFont systemFontOfSize:15];
    _wordLabel.text = @"我已阅读并同意云淘红包";
    _wordLabel.textColor = CCCUIColorFromHex(0x666666);

    [inviteView addSubview:_clickBtn];
    [inviteView addSubview:_wordLabel];
    [inviteView addSubview:_agreementBtn];

    [_rgView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(15);
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(150);
    }];

    [legalView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(contentView);
        make.top.mas_equalTo(_rgView.bottom);
        make.height.mas_equalTo(50);
    }];
    [_legalField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(legalView).offset(10);
        make.left.mas_equalTo(legalView).offset(5);
        make.right.mas_equalTo(legalView);
        make.height.mas_equalTo(30);
    }];
    [accBottomLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.mas_equalTo(legalView);
        make.height.mas_equalTo(1);
    }];
    [inviteView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(contentView);
        make.top.mas_equalTo(legalView.bottom);
        make.height.mas_equalTo(50);
    }];
    [_clickBtn makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.mas_equalTo(inviteView.top).offset(25);
    }];
    [_wordLabel makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_clickBtn.right);
        make.centerY.mas_equalTo(_clickBtn);
    }];
    [_agreementBtn makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_wordLabel.right);
        make.centerY.mas_equalTo(_wordLabel);
    }];
    [inviteBottomLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.mas_equalTo(inviteView);
        make.height.mas_equalTo(1);
    }];
    
    
    UIView *commonView = [[UIView alloc] init];
    commonView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:commonView];
    
    UIImageView *commonTopLine = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [commonView addSubview:commonTopLine];
    
    UILabel *commonWordLabel = [[UILabel alloc] init];
    commonWordLabel.font = [UIFont systemFontOfSize:15];
    commonWordLabel.text = @"如有对公账号请输入以下信息(选填)";
    commonWordLabel.textColor = CCCUIColorFromHex(0x666666);
    [commonView addSubview:commonWordLabel];
    
    [commonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inviteView.bottom).offset(15);
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(150);
    }];
    [commonTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(commonView);
        make.height.mas_equalTo(1);
    }];
    [commonWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(commonView);
    }];
    
    _accountView = [[RGFieldView alloc] initWithTitle:@"对公账号" frame:CGRectMake(0, 50, CGRectGetWidth(self.view.bounds), 50)];
    _accountView.delegate = self;
    _accountView.displayTopLine = YES;
    _accountView.keyboardType = UIKeyboardTypeASCIICapable;
    _accountView.textFiled.returnKeyType = UIReturnKeyNext;
    _accountView.placeholder = @"请输入对公账号户头";
    _bankView = [[RGFieldView alloc] initWithTitle:@"详细开户行" frame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 50)];
    _bankView.delegate = self;
    _bankView.leftMargin = 0;
    _bankView.placeholder = @"如中国农业银行杭州申花路支行";
    [commonView addSubview:_accountView];
    [commonView addSubview:_bankView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(commonView.bottom);
    }];
    [_scrollView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        __strong typeof(wSelf) sSelf = wSelf;
        [sSelf.scrollView endEditing:YES];
        [sSelf.scrollView setContentOffset:CGPointZero animated:YES];
    }];
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif

@end
