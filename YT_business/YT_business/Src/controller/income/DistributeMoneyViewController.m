#import "DistributeMoneyViewController.h"
#import "DistrubuteMoneyFieldView.h"
#import "UIView+DKAddition.h"
#import "UIBarButtonItem+Addition.h"
#import "UIImage+HBClass.h"
#import "UIView+BlockGesture.h"
#import "OutWebViewController.h"
#import "DistributePayViewController.h"
#import "MBProgressHUD+Add.h"
#import "YTMembersNumModel.h"
#import "UIViewController+Helper.h"

@interface DistributeMoneyViewController () <DistrubuteMoneyFieldViewDelegate, UIScrollViewDelegate> {
    CGFloat _totalCost;
}
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) DistrubuteMoneyFieldView* hbCountView;
@property (nonatomic, strong) DistrubuteMoneyFieldView* luckCostView;
@property (nonatomic, strong) DistrubuteMoneyFieldView* normalCostView;
@property (nonatomic, strong) DistrubuteMoneyFieldView* mesView;

@property (nonatomic, strong) UILabel* vipTotalLabel;
@property (nonatomic, strong) UILabel* hbTypeLabel;
@property (nonatomic, strong) UILabel* costTotalLabel;

@property (nonatomic, strong) UIButton* hbTypeBtn;
@property (nonatomic, strong) UIButton* distributeBtn;

@property (nonatomic, assign) BOOL hbAnimationFinsihed;

@end

@implementation DistributeMoneyViewController
#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"发红包";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:[UIImage imageNamed:@"yt_navigation_question.png"] highlightImage:nil target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializePageSubviews];
    self.hbAnimationFinsihed = YES;
    self.hongbaoType = DistributeMoneyHBTypeLuck;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (!parserObject.success) {
        [MBProgressHUD showError:parserObject.message toView:self.view];
        return;
    }
    YTMembersNumModel* membersModel = (YTMembersNumModel*)parserObject;
    self.vipTotalLabel.text = [NSString stringWithFormat:@"会员共%@人", membersModel.members.membersNum];
}

#pragma mark - DistrubuteMoneyFieldViewDelegate
- (BOOL)distrubuteMoneyFieldView:(DistrubuteMoneyFieldView*)view textFieldShouldBeginEditing:(UITextField*)textField
{
    if (view == _mesView) {
        [self.scrollView setContentOffset:CGPointMake(0, 160) animated:YES];
    }
    else if (view == _luckCostView || view == _normalCostView) {
        [self.scrollView setContentOffset:CGPointMake(0, 85) animated:YES];
    }
    else {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
    return YES;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if ([scrollView.panGestureRecognizer translationInView:scrollView].y > 0) {
        [self.scrollView endEditing:YES];
    }
}
#pragma mark - Event response
- (void)hbTypeButtonDidClicked:(id)sender
{
    if (!self.hbAnimationFinsihed) {
        return;
    }
    if (self.hongbaoType == DistributeMoneyHBTypeLuck) {
        self.hongbaoType = DistributeMoneyHBTypeNormal;
        [self.normalCostView.textFiled becomeFirstResponder];
    }
    else {
        self.hongbaoType = DistributeMoneyHBTypeLuck;
        [self.luckCostView.textFiled becomeFirstResponder];
    }
    [self updateButtonEnbale];
}
- (void)distributeButtonClicked:(id)sender
{
    if (self.hongbaoType == DistributeMoneyHBTypeLuck) {
        NSInteger count = [self.hbCountView.text integerValue];
        CGFloat amount = [self.luckCostView.text floatValue]/count;
        if (amount < 0.01f) {
            [self showAlert:@"单个红包金额不可低于0.01元,请重现填写" title:@""];
            return;
        }
    }
    NSMutableDictionary* mutableDict = [[NSMutableDictionary alloc] init];
    [mutableDict setObject:[YTUsr usr].shop.shopId forKey:@"shopId"];
    [mutableDict setObject:self.mesView.text forKey:@"content"];
    [mutableDict setObject:self.hbCountView.text forKey:@"hongbaoNum"];
    if (self.hongbaoType == DistributeMoneyHBTypeLuck) {
        NSInteger amount = [self.luckCostView.text floatValue] * 100;
        [mutableDict setObject:@3 forKey:@"hongbaoLx"];
        [mutableDict setObject:@(amount) forKey:@"totalSum"];
    }
    else {
        NSInteger amount = [self.normalCostView.text floatValue] * 100;
        [mutableDict setObject:@4 forKey:@"hongbaoLx"];
        [mutableDict setObject:@(amount) forKey:@"hongbaoSum"];
    }
    self.requestParas = [NSDictionary dictionaryWithDictionary:mutableDict];

    YTDistributeMoneyHbModel* hongbao = [[YTDistributeMoneyHbModel alloc] initWithHongbaoType:self.hongbaoType count:[self.hbCountView.text integerValue] content:self.mesView.text];
    hongbao.cost = _totalCost;
    DistributePayViewController* distributePayVC = [[DistributePayViewController alloc] init];
    distributePayVC.hongbao = hongbao;
    [self.navigationController pushViewController:distributePayVC animated:YES];
}
#pragma mark - Private methods
- (void)hongbaoTextFieldChanged
{
    [self updateButtonEnbale];
}
- (BOOL)isValidHongbaoCount
{
    NSInteger count = [self.hbCountView.text integerValue];
    return count >= 1;
}
- (BOOL)isValidHongbaoCost
{
    CGFloat cost = 0;
    if (self.hongbaoType == DistributeMoneyHBTypeLuck) {
        cost = [self.luckCostView.text floatValue];
    }
    else {
        cost = [self.normalCostView.text floatValue];
    }
    return !(cost < 0.01f);
}
- (void)updateButtonEnbale
{
    BOOL enbale = [self isValidHongbaoCost] && [self isValidHongbaoCount];
    self.distributeBtn.enabled = enbale;
    if (!enbale) {
        self.costTotalLabel.text = @"￥0.00";
        return;
    }
    if (self.hongbaoType == DistributeMoneyHBTypeLuck) {
        _totalCost = [self.luckCostView.text floatValue];
    }
    else {
        CGFloat cost = [self.normalCostView.text floatValue];
        _totalCost = cost * [self.hbCountView.text integerValue];
    }
    self.costTotalLabel.text = [NSString stringWithFormat:@"￥%.2f", _totalCost];
}
- (BOOL)isValidPassword:(NSString*)password
{
    return password.length > 3;
}
- (void)changeDistributeType
{
    self.hbAnimationFinsihed = NO;
    if (self.hongbaoType == DistributeMoneyHBTypeLuck) {
        if (self.luckCostView.dk_x == self.hbCountView.dk_x) {
            self.hbAnimationFinsihed = YES;
            return;
        }
        [UIView animateWithDuration:0.35f
            animations:^{
                _luckCostView.dk_x = _hbCountView.dk_x;
                _normalCostView.dk_x = -CGRectGetWidth(self.view.bounds);
            }
            completion:^(BOOL finished) {
                _normalCostView.dk_x = CGRectGetWidth(self.view.bounds);
                _hbAnimationFinsihed = YES;
            }];
    }
    else {
        [UIView animateWithDuration:0.35f
            animations:^{
                _normalCostView.dk_x = _hbCountView.dk_x;
                _luckCostView.dk_x = -CGRectGetWidth(self.view.bounds);
            }
            completion:^(BOOL finished) {
                _luckCostView.dk_x = CGRectGetWidth(self.view.bounds);
                _hbAnimationFinsihed = YES;
            }];
    }
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    OutWebViewController* webVC = [[OutWebViewController alloc] initWithNibName:@"OutWebViewController" bundle:nil];
    webVC.urlStr = @"";
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.hbCountView];
    [self.scrollView addSubview:self.luckCostView];
    [self.scrollView addSubview:self.normalCostView];
    [self.scrollView addSubview:self.mesView];
    [self.scrollView addSubview:self.vipTotalLabel];
    [self.scrollView addSubview:self.hbTypeLabel];
    [self.scrollView addSubview:self.hbTypeBtn];
    [self.scrollView addSubview:self.costTotalLabel];
    [self.scrollView addSubview:self.distributeBtn];
    __weak __typeof(self) weakSelf = self;
    [_scrollView addTapActionWithBlock:^(UIGestureRecognizer* gestureRecoginzer) {
        [weakSelf.scrollView endEditing:YES];
        [weakSelf.scrollView setContentOffset:CGPointZero animated:YES];
    }];
    self.vipTotalLabel.text = @"会员共..人";
    self.costTotalLabel.text = @"￥0.00";
    self.mesView.text = [NSString stringWithFormat:@"%@送您一个红包",[YTUsr usr].shop.name];
    self.requestParas = @{ @"shopId" : [YTUsr usr].shop.shopId };
    self.requestURL = getMembersNumURL;
}
#pragma mark - Getters & Setters
- (void)setHongbaoType:(DistributeMoneyHBType)hongbaoType
{
    _hongbaoType = hongbaoType;
    if (hongbaoType == DistributeMoneyHBTypeLuck) {
        _hbTypeLabel.text = @"当前为拼手气红包，";
        _hbTypeLabel.dk_width = 120;
        [_hbTypeBtn setTitle:@"改为普通红包" forState:UIControlStateNormal];
    }
    else {
        _hbTypeLabel.text = @"当前为普通红包，";
        _hbTypeLabel.dk_width = 105;
        [_hbTypeBtn setTitle:@"改为拼手气红包" forState:UIControlStateNormal];
    }
    _hbTypeBtn.dk_x = _hbTypeLabel.dk_right;
    [self changeDistributeType];
}
- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.view.bounds) + 64);
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (DistrubuteMoneyFieldView*)hbCountView
{
    if (!_hbCountView) {
        _hbCountView = [[DistrubuteMoneyFieldView alloc] initWithFrame:CGRectMake(15, 15, CGRectGetWidth(self.view.bounds) - 30, 45)];
        _hbCountView.title = @"红包个数";
        _hbCountView.rightText = @"个";
        _hbCountView.placeholder = @"填写个数";
        _hbCountView.keyboardType = UIKeyboardTypeNumberPad;
        [_hbCountView addTextTarget:self action:@selector(hongbaoTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _hbCountView;
}
- (DistrubuteMoneyFieldView*)luckCostView
{
    if (!_luckCostView) {
        _luckCostView = [[DistrubuteMoneyFieldView alloc] initWithFrame:_hbCountView.frame];
        _luckCostView.dk_y = _hbCountView.dk_bottom + 35;
        _luckCostView.delegate = self;
        _luckCostView.titleAttributedString = [self luckAttributedString];
        _luckCostView.rightText = @"元";
        _luckCostView.placeholder = @"填写金额";
        _luckCostView.keyboardType = UIKeyboardTypeDecimalPad;
        [_luckCostView addTextTarget:self action:@selector(hongbaoTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _luckCostView;
}
- (DistrubuteMoneyFieldView*)normalCostView
{
    if (!_normalCostView) {
        _normalCostView = [[DistrubuteMoneyFieldView alloc] initWithFrame:_luckCostView.frame];
        _normalCostView.dk_x = CGRectGetWidth(self.view.bounds);
        _normalCostView.delegate = self;
        _normalCostView.title = @"单个金额";
        _normalCostView.rightText = @"元";
        _normalCostView.placeholder = @"填写金额";
        _normalCostView.keyboardType = UIKeyboardTypeDecimalPad;
        [_normalCostView addTextTarget:self action:@selector(hongbaoTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _normalCostView;
}
- (DistrubuteMoneyFieldView*)mesView
{
    if (!_mesView) {
        _mesView = [[DistrubuteMoneyFieldView alloc] initWithFrame:_hbCountView.frame];
        _mesView.dk_y = _luckCostView.dk_bottom + 35;
        _mesView.delegate = self;
        _mesView.hideTitle = YES;
        _mesView.keyboardType = UIKeyboardTypeDefault;
        _mesView.textAlignment = NSTextAlignmentLeft;
    }
    return _mesView;
}
- (UILabel*)vipTotalLabel
{
    if (!_vipTotalLabel) {
        _vipTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(_hbCountView.dk_x + 15, _hbCountView.dk_bottom, _hbCountView.dk_width, 30)];
        _vipTotalLabel.numberOfLines = 1;
        _vipTotalLabel.font = [UIFont systemFontOfSize:13];
        _vipTotalLabel.textColor = CCCUIColorFromHex(0x666666);
        _vipTotalLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _vipTotalLabel;
}
- (UILabel*)hbTypeLabel
{
    if (!_hbTypeLabel) {
        _hbTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_vipTotalLabel.dk_x, _luckCostView.dk_bottom, 100, 30)];
        _hbTypeLabel.numberOfLines = 1;
        _hbTypeLabel.font = [UIFont systemFontOfSize:13];
        _hbTypeLabel.textColor = CCCUIColorFromHex(0x666666);
        _hbTypeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _hbTypeLabel;
}
- (UIButton*)hbTypeBtn
{
    if (!_hbTypeBtn) {
        _hbTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hbTypeBtn.frame = CGRectMake(_hbTypeLabel.dk_right, _hbTypeLabel.dk_y, 100, 30);
        _hbTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _hbTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_hbTypeBtn setTitleColor:CCCUIColorFromHex(0x0073e5) forState:UIControlStateNormal];
        [_hbTypeBtn addTarget:self action:@selector(hbTypeButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hbTypeBtn;
}
- (UILabel*)costTotalLabel
{
    if (!_costTotalLabel) {
        _costTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _mesView.dk_bottom + 10, CGRectGetWidth(self.view.bounds), 50)];
        _costTotalLabel.numberOfLines = 1;
        _costTotalLabel.font = [UIFont systemFontOfSize:40];
        _costTotalLabel.textColor = CCCUIColorFromHex(0x333333);
        _costTotalLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _costTotalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _costTotalLabel;
}
- (UIButton*)distributeBtn
{
    if (!_distributeBtn) {
        _distributeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _distributeBtn.frame = CGRectMake(15, _costTotalLabel.dk_bottom + 10, CGRectGetWidth(self.view.bounds) - 30, 50);
        _distributeBtn.layer.masksToBounds = YES;
        _distributeBtn.layer.cornerRadius = 4;
        _distributeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_distributeBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xE63E4B)] forState:UIControlStateNormal];
        [_distributeBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xDA2F3C)] forState:UIControlStateHighlighted];
        [_distributeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_distributeBtn setTitle:@"塞进红包" forState:UIControlStateNormal];
        [_distributeBtn addTarget:self action:@selector(distributeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _distributeBtn.enabled = NO;
    }
    return _distributeBtn;
}
- (NSAttributedString*)luckAttributedString
{
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:@"总金额"];
    UIImage* image = [UIImage imageNamed:@"distribute_moneyHb_pin.png"];
    NSTextAttachment* textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(2, -3, image.size.width, image.size.height);
    NSAttributedString* luckAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attString appendAttributedString:luckAttachmentString];
    return [[NSAttributedString alloc] initWithAttributedString:attString];
}
@end
