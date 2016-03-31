#import "CStoreReceiveSelectListTableCell.h"
#import "HbIntroModel.h"

@implementation CStoreReceiveSelectListTableCell


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
- (void)configStoreReceiveSelectListTableListModel:(HbIntroModel *)hbModel;
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 价值%@元",hbModel.hbName,hbModel.price];
}
#pragma mark - Private methods
#pragma mark - Event response

#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.costLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.centerY.mas_equalTo(self.contentView);
        }];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_costLabel.left).offset(-10);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(16);
            make.right.mas_equalTo(_numberLabel.left).offset(20);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];

    self.costLabel.preferredMaxLayoutWidth = 60;
    self.numberLabel.preferredMaxLayoutWidth = 60;
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
- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textColor = [UIColor blackColor];
        _numberLabel.font = [UIFont boldSystemFontOfSize:15];
        _numberLabel.numberOfLines = 1;
        _numberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numberLabel;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
