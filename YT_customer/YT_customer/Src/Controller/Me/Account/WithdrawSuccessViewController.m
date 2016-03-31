#import "WithdrawSuccessViewController.h"
#import "RGLrTextView.h"
#import "UIImage+HBClass.h"

@interface WithdrawSuccessViewController ()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) RGLrTextView *cardView;
@property (strong, nonatomic) RGLrTextView *amountView;
@property (strong, nonatomic) UIButton* doneButton;
@end

@implementation WithdrawSuccessViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
        self.navigationItem.title = @"余额提现";
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
#pragma mark - Event response
- (void)doneButtonClicked:(UIButton*)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.cardView];
    [self.view addSubview:self.amountView];
    [self.view addSubview:self.doneButton];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.bottom).offset(15);
        make.left.right.mas_equalTo(self.view);
    }];
    [_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.bottom).offset(30);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [_amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cardView.bottom);
        make.left.right.mas_equalTo(_cardView);
        make.height.mas_equalTo(_cardView);
    }];
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_amountView.bottom).offset(30);
        make.height.mas_equalTo(45);
    }];
}

#pragma mark - Getters & Setters
- (void)setSuccessTitle:(NSString *)successTitle
{
    _successTitle = successTitle;
    _titleLabel.text = successTitle;
}
- (void)setCardText:(NSString *)cardText
{
    _cardText = cardText;
    _cardView.rightLabel.text = cardText;
}
- (void)setAmountText:(NSString *)amountText
{
    _amountText = amountText;
    _amountView.rightLabel.text = amountText;
}
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face_pay_waiting_02.png"]];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (RGLrTextView *)cardView
{
    if (!_cardView) {
        _cardView = [[RGLrTextView alloc] init];
        _cardView.displayTopLine = YES;
        _cardView.leftMargin = 15;
        _cardView.leftLabel.text = @"储蓄卡";
    }
    return _cardView;
}
- (RGLrTextView *)amountView
{
    if (!_amountView) {
        _amountView = [[RGLrTextView alloc] init];
        _amountView.leftLabel.text = @"提现金额";
    }
    return _amountView;
}

- (UIButton*)doneButton
{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.layer.masksToBounds = YES;
        _doneButton.layer.cornerRadius = 4;
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_doneButton setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}
@end
