
#import "HbSelectTableCell.h"
#import "XLFormRowNavigationAccessoryView.h"
#import "YTTradeModel.h"

@interface HbSelectTableCell ()<UITextFieldDelegate>

@property (nonatomic) XLFormRowNavigationAccessoryView * navigationAccessoryView;
@end

@implementation HbSelectTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
#pragma mark - Public methods
- (void)configHbStoreTableListModel:(YTUsrHongBao *)hongbao
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 价值%.2f元",hongbao.name,hongbao.cost/100.];
    CGFloat price = hongbao.price/100.;
    NSInteger butNumInt = hongbao.buyNum.integerValue;
    self.costLabel.text = [NSString stringWithFormat:@"￥%@",@(butNumInt*price)];
    if (hongbao.buyNum > 0) {
        self.textFiled.text = [NSString stringWithFormat:@"x%@",hongbao.buyNum];
    } else{
        self.textFiled.text = @"";
    }
}
#pragma mark - Private methods
#pragma mark - Event response
- (void)doneButtonDidClicked:(id)sender
{
    [self.textFiled resignFirstResponder];
}

#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.textFiled];
    [self.contentView addSubview:self.costLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {

        [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(60);
        }];
        [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_costLabel.left).offset(-10);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(60);
        }];

        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(16);
            make.right.mas_equalTo(_textFiled.left).offset(20);
            make.centerY.mas_equalTo(self.contentView);
        }];

        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Setter & Getter

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}
- (UILabel *)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.textColor = [UIColor blackColor];
        _costLabel.font = [UIFont boldSystemFontOfSize:15];
        _costLabel.numberOfLines = 1;
        _costLabel.textAlignment = NSTextAlignmentRight;
    }
    return _costLabel;
}
- (UITextField *)textFiled
{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc] init];
        _textFiled.borderStyle = UITextBorderStyleNone;
        _textFiled.keyboardType = UIKeyboardTypeNumberPad;
        _textFiled.returnKeyType = UIReturnKeyDone;
        _textFiled.enablesReturnKeyAutomatically = YES;
        _textFiled.font = [UIFont systemFontOfSize:16];
        _textFiled.textAlignment = NSTextAlignmentRight;
        _textFiled.delegate = self;
        _textFiled.inputAccessoryView =self.navigationAccessoryView;
        _textFiled.userInteractionEnabled = NO;
    }
    return _textFiled;
}

-(XLFormRowNavigationAccessoryView *)navigationAccessoryView
{
    if (_navigationAccessoryView) return _navigationAccessoryView;
    _navigationAccessoryView = [XLFormRowNavigationAccessoryView new];
    _navigationAccessoryView.doneButton.target = self;
    _navigationAccessoryView.doneButton.action = @selector(doneButtonDidClicked:);
    _navigationAccessoryView.tintColor = [UIColor redColor];
    [_navigationAccessoryView.previousButton setCustomView:[UIView new]];
    [_navigationAccessoryView.nextButton setCustomView:[UIView new]];
    return _navigationAccessoryView;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
