#import "PromotionSettingHbCell.h"

NSString * const XLFormRowDescriptorTypePromotionSetting = @"XLFormRowDescriptorTypePromotionSetting";


@interface PromotionSettingHbCell ()
@property (strong, nonatomic) UILabel *hbTitleLabel;
@property (strong, nonatomic) UILabel *hbDescribeitleLabel;
@end

@implementation PromotionSettingHbCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[PromotionSettingHbCell class] forKey:XLFormRowDescriptorTypePromotionSetting];
}
#pragma mark - XLFormDescriptorCell

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 60;
}

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.hbTitleLabel];
    [self.contentView addSubview:self.hbDescribeitleLabel];
    [self setupLayout];

    self.accessoryView = [[UISwitch alloc] init];
    self.editingAccessoryView = self.accessoryView;
    [self.switchControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)update
{
    [super update];
     self.hbTitleLabel.text = self.rowDescriptor.title;
    PromotionHbDescribe *hbDescribe = (PromotionHbDescribe *)self.rowDescriptor.value;
    self.hbDescribeitleLabel.text = hbDescribe.hbDescribe;
    self.switchControl.on = hbDescribe.selected;
    self.switchControl.enabled = !self.rowDescriptor.isDisabled;
}
- (void)valueChanged
{
    PromotionHbDescribe *hbDescribe = (PromotionHbDescribe *)self.rowDescriptor.value;
    hbDescribe.selected = self.switchControl.on;
    self.rowDescriptor.value = hbDescribe;
}

- (UISwitch *)switchControl
{
    return (UISwitch *)self.accessoryView;
}
#pragma mark - Private methods
-(void)setupLayout
{
    [_hbTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(16);
        make.top.mas_equalTo(self.contentView).offset(12);
        make.right.mas_equalTo(self.contentView).offset(-70);
    }];
    [_hbDescribeitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_hbTitleLabel);
        make.top.mas_equalTo(_hbTitleLabel.bottom).offset(5);
    }];
}

#pragma mark - Setter & Getter
- (UILabel *)hbTitleLabel
{
    if (!_hbTitleLabel) {
        _hbTitleLabel = [[UILabel alloc] init];
        _hbTitleLabel.textColor = [UIColor blackColor];
        _hbTitleLabel.font = [UIFont systemFontOfSize:16];
        _hbTitleLabel.numberOfLines = 1;
    }
    return _hbTitleLabel;
}
- (UILabel *)hbDescribeitleLabel
{
    if (!_hbDescribeitleLabel) {
        _hbDescribeitleLabel = [[UILabel alloc] init];
        _hbDescribeitleLabel.textColor = CCCUIColorFromHex(0x999999);
        _hbDescribeitleLabel.font = [UIFont systemFontOfSize:14];
        _hbDescribeitleLabel.numberOfLines = 1;
    }
    return _hbDescribeitleLabel;
}

@end


@implementation PromotionHbDescribe

+ (PromotionHbDescribe *)promotionHbDescribeWithSelected:(BOOL)selected describe:(NSString *)describe
{
    return [[PromotionHbDescribe alloc] initWithSelected:selected describe:describe];
}
- (instancetype)initWithSelected:(BOOL)selected describe:(NSString *)describe
{
    self = [super init];
    if (self){
        _selected = selected;
        _hbDescribe = describe;
    }
    return self;

}
@end