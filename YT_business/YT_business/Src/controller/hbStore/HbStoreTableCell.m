
#import "YTTradeModel.h"
#import "HbStoreTableCell.h"
#import "XLFormRowNavigationAccessoryView.h"
#import "NSStrUtil.h"

static const NSInteger kTopPadding = 10;
static const NSInteger kLeftPadding = 15;

@interface HbStoreTableCell ()
<
UITextFieldDelegate
> {
    YTUsrHongBao *usrHongbao;
}

@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIView *fieldBackView;
@property (strong, nonatomic) UIImageView *fieldbackImageView;

@property (nonatomic) XLFormRowNavigationAccessoryView * navigationAccessoryView;
@end

@implementation HbStoreTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureSubview];
    }
    return self;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(hbStoreTableCell:textFieldShouldBeginEditing:)]) {
        [_delegate hbStoreTableCell:self textFieldShouldBeginEditing:textField];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    usrHongbao.buyNum = [NSNumber numberWithInteger:[textField.text integerValue]];
    if ([self.delegate respondsToSelector:@selector(hbStoreTableCell:hbStoreModel:textFieldDidEndEditing:)]) {
        [_delegate hbStoreTableCell:self hbStoreModel:usrHongbao textFieldDidEndEditing:textField];
    }
}
#pragma mark - Event response
- (void)addButtonDidClicked:(id)sender
{
    NSInteger buyNumInt = usrHongbao.buyNum.integerValue;
    buyNumInt ++;
    usrHongbao.buyNum = [NSNumber numberWithInteger:buyNumInt];
    
    self.textFiled.text = [NSString stringWithFormat:@"%@",usrHongbao.buyNum];
    if ([self.delegate respondsToSelector:@selector(hbStoreTableCell:didAddhbStoreModel:)]) {
        [_delegate hbStoreTableCell:self didAddhbStoreModel:usrHongbao];
    }
}
- (void)minusButtonDidClicked:(id)sender
{
    if (usrHongbao.buyNum.integerValue == 0) {
        return;
    }
    NSInteger buyNumInt = usrHongbao.buyNum.integerValue;
    buyNumInt --;
    usrHongbao.buyNum = [NSNumber numberWithInteger:buyNumInt];
    self.textFiled.text = [NSString stringWithFormat:@"%@",usrHongbao.buyNum];
    if ([self.delegate respondsToSelector:@selector(hbStoreTableCell:didMinushbStoreModel:)]) {
        [_delegate hbStoreTableCell:self didMinushbStoreModel:usrHongbao];
    }
}
- (void)askButtonDidClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(hbStoreTableCellAskAction:)]) {
        [_delegate hbStoreTableCellAskAction:self];
    }
}
- (void)doneButtonDidClicked:(id)sender
{
    [self.textFiled resignFirstResponder];
}
#pragma mark - Public methods
- (void)configHbStoreTableListModel:(YTUsrHongBao *)hongbao
{
    usrHongbao = hongbao;
    self.describeLabel.text = hongbao.shop.name;
    self.costLabel.attributedText = [hongbao costAttributeStr];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 价值%.2f元",hongbao.name,hongbao.cost/100.];
    [self.hbImageView setYTImageWithURL:[hongbao.img imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
    if (hongbao.buyNum.integerValue > 0) {
        self.textFiled.text = [NSString stringWithFormat:@"%@",hongbao.buyNum];
    } else{
        self.textFiled.text = @"";
    }
    if ([[YTUsr usr].shop.catId isEqualToString:hongbao.shop.catId]) {
        [self didShowSameMessage:YES];
    }else {
        [self didShowSameMessage:NO];
    }
}
#pragma mark - Private methods
- (void)didShowSameMessage:(BOOL)show
{
    self.askButton.hidden = self.sameLabel.hidden = !show;
    self.fieldBackView.hidden = show;
}
#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.hbImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.describeLabel];
    [self.contentView addSubview:self.lineImageView];
    [self.contentView addSubview:self.costLabel];
    [self.contentView addSubview:self.askButton];
    [self.contentView addSubview:self.sameLabel];
    [self.contentView addSubview:self.fieldBackView];
    [self.fieldBackView addSubview:self.fieldbackImageView];
    [self.fieldBackView addSubview:self.textFiled];
    [self.fieldBackView addSubview:self.addButton];
    [self.fieldBackView addSubview:self.minusButton];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(kTopPadding);
            make.left.mas_equalTo(self.contentView).offset(kLeftPadding);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_hbImageView).offset(5);
            make.left.mas_equalTo(_hbImageView.right).offset(kTopPadding);
            make.right.mas_equalTo(self.contentView);
        }];
        [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.bottom).offset(kTopPadding);
            make.left.right.mas_equalTo(_nameLabel);
        }];
        [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_hbImageView);
            make.top.mas_equalTo(_hbImageView.bottom).offset(kTopPadding);
            make.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
        [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_hbImageView);
            make.top.mas_equalTo(_lineImageView).offset(kLeftPadding);
            make.right.mas_equalTo(self.contentView).offset(-110).priorityLow();
        }];
        [_askButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kTopPadding);
            make.top.mas_equalTo(_lineImageView).offset(18);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        [_sameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_askButton);
            make.right.mas_equalTo(_askButton.left).offset(-5);
        }];
        [_fieldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-kTopPadding);
            make.top.mas_equalTo(_lineImageView).offset(kTopPadding);
            make.size.mas_equalTo(CGSizeMake(98, 30));
        }];
        [_fieldbackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_fieldBackView);
        }];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(_fieldBackView);
            make.width.mas_equalTo(30);
        }];
        [_minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(_fieldBackView);
            make.width.mas_equalTo(30);
        }];
        [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_addButton.right).offset(3);
            make.left.mas_equalTo(_minusButton.left);
            make.top.bottom.mas_equalTo(_fieldBackView);
        }];
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Setter & Getter
- (UIView *)fieldBackView
{
    if (!_fieldBackView) {
        _fieldBackView = [[UIView alloc] init];
    }
    return _fieldBackView;
}
- (UIImageView *)hbImageView
{
    if (!_hbImageView) {
        _hbImageView = [[UIImageView alloc] init];
        _hbImageView.layer.masksToBounds = YES;
        _hbImageView.layer.cornerRadius = 2;
//        _hbImageView.layer.shouldRasterize = YES;
//        _hbImageView.layer.rasterizationScale = 2.0;
        _hbImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _hbImageView;
}
- (UIImageView *)lineImageView
{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    }
    return _lineImageView;
}
- (UIImageView *)fieldbackImageView
{
    if (!_fieldbackImageView) {
        _fieldbackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hb_store_textBackground.png"]];
    }
    return _fieldbackImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}
- (UILabel *)describeLabel
{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.textColor = CCCUIColorFromHex(0x999999);
        _describeLabel.font = [UIFont systemFontOfSize:13];
        _describeLabel.numberOfLines = 1;
    }
    return _describeLabel;
}
- (UILabel *)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.textColor = CCCUIColorFromHex(0x999999);
        _costLabel.font = [UIFont systemFontOfSize:13];
        _costLabel.numberOfLines = 1;
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
        _textFiled.font = [UIFont systemFontOfSize:13];
        _textFiled.textAlignment = NSTextAlignmentCenter;
        _textFiled.delegate = self;
        _textFiled.inputAccessoryView =self.navigationAccessoryView;
    }
    return _textFiled;
}
- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"hb_store_addButton.png"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}
- (UIButton *)minusButton
{
    if (!_minusButton) {
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusButton setImage:[UIImage imageNamed:@"hb_store_minusButton.png"] forState:UIControlStateNormal];
        [_minusButton addTarget:self action:@selector(minusButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minusButton;
}

- (UILabel *)sameLabel
{
    if (!_sameLabel) {
        _sameLabel = [[UILabel alloc] init];
        _sameLabel.textColor = CCCUIColorFromHex(0x999999);
        _sameLabel.font = [UIFont systemFontOfSize:14];
        _sameLabel.numberOfLines = 1;
        _sameLabel.textAlignment = NSTextAlignmentRight;
        _sameLabel.text = @"同行红包";
        _sameLabel.hidden = YES;
    }
    return _sameLabel;
}
- (UIButton *)askButton
{
    if (!_askButton) {
        _askButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_askButton setImage:[UIImage imageNamed:@"hb_store_askButton.png"] forState:UIControlStateNormal];
        [_askButton addTarget:self action:@selector(askButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _askButton.hidden = YES;
    }
    return _askButton;
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
