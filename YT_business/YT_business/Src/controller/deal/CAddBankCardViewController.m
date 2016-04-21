#import "CAddBankCardViewController.h"
#import "RGFieldView.h"
#import "RGActionView.h"
#import "UIImage+HBClass.h"
#import "MBProgressHUD+Add.h"
#import "CSelectBankViewController.h"
#import "UIViewController+Helper.h"
#import "YTBankModel.h"

static NSString *const kAddCardholder = @"cardholder";
static NSString *const kAddCardBank= @"cardBank";
static NSString *const kAddOpenBank = @"openBank";
static NSString *const kAddCardNumber = @"cardNumber";

static NSString *const kDefauleCardName = @"使用新卡提现";

static const CGFloat kSignViewHeight = 50;
@interface CAddBankCardViewController ()<RGFieldViewDelegate,RGActionViewDelegate,CSelectBankViewControllerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) RGFieldView *cardholderView;
@property (strong, nonatomic) RGActionView *cardBankView;
@property (strong, nonatomic) RGFieldView *secBankView;
@property (strong, nonatomic) RGFieldView *openBankView;
@property (strong, nonatomic) RGFieldView *cardNumberView;
@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation CAddBankCardViewController

#pragma mark - Life cycle
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加银行卡";
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
    if (parserObject.success) {
        [MBProgressHUD showSuccess:@"成功添加银行卡" toView:self.view];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            YTSaveBank *saveBank = (YTSaveBank *)parserObject;
            if ([self.delegate respondsToSelector:@selector(addBankCardViewController:success:)]) {
                [_delegate addBankCardViewController:self success:saveBank.bank];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }else {
        [self showAlert:parserObject.message title:@""];
    }
}
#pragma mark - RGFieldViewDelegate

- (void)rgfiledView:(RGFieldView *)filedView textFieldShouldBeginEditing:(UITextField *)textField
{
    CGPoint pointInView = [filedView.superview convertPoint:filedView.frame.origin toView:self.view];
    CGFloat bottomHeight = CGRectGetHeight(self.view.bounds)-pointInView.y-kSignViewHeight;
    if (bottomHeight < 266) {
        CGPoint contentOffset = self.scrollView.contentOffset;
        contentOffset.y += 266-bottomHeight+kSignViewHeight;
        [self.scrollView setContentOffset:contentOffset animated:YES];
    }
}
#pragma mark - RGActionViewDelegate
- (void)rgactionViewDidClicked:(RGActionView *)actionView
{
    CSelectBankViewController *selectBankVC = [[CSelectBankViewController alloc] init];
    selectBankVC.delegate = self;
    selectBankVC.selectBankName = self.cardBankView.detailLabel.text;
    [self.navigationController pushViewController:selectBankVC animated:YES];
}
#pragma mark - CSelectBankViewControllerDelegate
- (void)selectBankViewController:(CSelectBankViewController *)controller disSelectBankName:(NSString *)bankName
{
    self.cardBankView.detailLabel.textColor = CCCUIColorFromHex(0x333333);
    self.cardBankView.detailLabel.text = bankName;
}
#pragma mark - Private methods
- (BOOL)checkInputBankMessage
{
    if ([NSStrUtil isEmptyOrNull:self.cardholderView.textFiled.text]) {
        [self showAlert:@"您还未输入姓名~" title:@""];
        return NO;
    }
//    else if ([NSStrUtil isEmptyOrNull:self.cardBankView.detailLabel.text] ||
//               [self.cardBankView.detailLabel.text isEqualToString:kDefauleCardName]){
//        [self showAlert:@"您还未选择银行~" title:@""];
//         return NO;
//    }
    else if ([NSStrUtil isEmptyOrNull:self.secBankView.textFiled.text]){
        [self showAlert:@"您还输入详细开户行信息~" title:@""];
         return NO;
    }
//    else if ([NSStrUtil isEmptyOrNull:self.openBankView.textFiled.text]){
//        [self showAlert:@"您还输入支行名称~" title:@""];
//         return NO;
//    }
    else if ([NSStrUtil isEmptyOrNull:self.cardNumberView.textFiled.text]){
        [self showAlert:@"您还输入卡号~" title:@""];
         return NO;
    }
    return YES;
}
#pragma mark - Event response
- (void)scrollViewTap:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}
- (void)nextButtonClicked:(id)sender
{
    if (![self checkInputBankMessage]) {
        return;
    }
//    self.requestParas = @{@"bankName":self.cardBankView.detailLabel.text,
//                          @"bankNo" : self.cardNumberView.textFiled.text,
//                          @"secName" : self.secBankView.textFiled.text,
//                          @"thirdName" : self.openBankView.textFiled.text,
//                          @"realName" : self.cardholderView.textFiled.text,
//                          loadingKey : @(YES)};
    self.requestParas = @{@"bankNo" : self.cardNumberView.textFiled.text,
                          @"realName" : self.cardholderView.textFiled.text,
                          @"fullName":self.secBankView.textFiled.text,
                          @"bankName" : self.secBankView.textFiled.text,
                          @"secName" : self.secBankView.textFiled.text,
                          @"thirdName" : self.secBankView.textFiled.text,
                          loadingKey : @(YES)};
    self.requestURL = saveBankURL;
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.messageLabel];
    [self.scrollView addSubview:self.cardholderView];
//    [self.scrollView addSubview:self.cardBankView];
    [self.scrollView addSubview:self.secBankView];
//    [self.scrollView addSubview:self.openBankView];
    [self.scrollView addSubview:self.cardNumberView];
    [self.scrollView addSubview:self.nextButton];
}
#pragma mark - Getters & Setters
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.view.bounds)+50);
        _scrollView.delegate = self;
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)]];
    }
    return _scrollView;
}
- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, kDeviceWidth-15, 30)];
        _messageLabel.numberOfLines = 1;
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.textColor = CCCUIColorFromHex(0x666666);
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _messageLabel.text = @"请绑定银行卡";
        _messageLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _messageLabel;
}
- (RGFieldView *)cardholderView
{
    if (!_cardholderView) {
        _cardholderView = [[RGFieldView alloc] initWithTitle:@"持卡人 " frame:CGRectMake(0, 55, kDeviceWidth, kSignViewHeight)];
        _cardholderView.backgroundColor = [UIColor whiteColor];
        _cardholderView.keyboardType = UIKeyboardTypeDefault;
        _cardholderView.displayTopLine = YES;
        _cardholderView.placeholder = @"请输入持卡人姓名";
        _cardholderView.delegate = self;
    }
    
    return _cardholderView;
}
- (RGActionView *)cardBankView
{
    if (!_cardBankView) {
        _cardBankView = [[RGActionView alloc] initWithTitle:@"持卡银行" frame:CGRectMake(0, 55+kSignViewHeight, kDeviceWidth, kSignViewHeight)];
        _cardBankView.backgroundColor = [UIColor whiteColor];
        _cardBankView.detailLabel.text = kDefauleCardName;
        _cardBankView.detailLabel.textColor = CCCUIColorFromHex(0xcccccc);
        _cardBankView.delegate = self;
    }
    return _cardBankView;
}
- (RGFieldView *)secBankView
{
    if (!_secBankView) {
        _secBankView = [[RGFieldView alloc] initWithTitle:@"详细开户行" frame:CGRectMake(0, 55+kSignViewHeight, kDeviceWidth, kSignViewHeight)];
        _secBankView.backgroundColor = [UIColor whiteColor];
        _secBankView.placeholder = @"如:中国农业银行杭州申花路支行";
        _secBankView.delegate = self;
    }
    return _secBankView;
}
- (RGFieldView *)openBankView
{
    if (!_openBankView) {
        _openBankView = [[RGFieldView alloc] initWithTitle:@"开户支行" frame:CGRectMake(0, 55+(kSignViewHeight*3), kDeviceWidth, kSignViewHeight)];
        _openBankView.backgroundColor = [UIColor whiteColor];
        _openBankView.placeholder = @"请填写开户支行";
        _openBankView.delegate = self;
    }
    return _openBankView;
}
- (RGFieldView *)cardNumberView
{
    if (!_cardNumberView) {
        _cardNumberView = [[RGFieldView alloc] initWithTitle:@"卡号  " frame:CGRectMake(0, 55+(kSignViewHeight*2), kDeviceWidth, kSignViewHeight)];
        _cardNumberView.backgroundColor = [UIColor whiteColor];
        _cardNumberView.keyboardType = UIKeyboardTypeDecimalPad;
        _cardNumberView.leftMargin = 0;
        _cardNumberView.placeholder = @"银行卡号";
        _cardNumberView.delegate = self;
    }
    
    return _cardNumberView;
}
- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(15, 55+20+(kSignViewHeight*3), kDeviceWidth-30, 45);
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.cornerRadius = 4;
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_nextButton setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setTitle:@"完成" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

@end
