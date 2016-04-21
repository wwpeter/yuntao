#import "DealRecordDetailSalesTableCell.h"

@implementation DealRecordDetailSalesTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.describeLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(80);
            make.centerY.mas_equalTo(self.contentView);
        }];
        [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(_titleLabel.right).offset(5).priorityHigh();
            make.centerY.mas_equalTo(self.contentView);
        }];
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Getters & Setters
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = CCCUIColorFromHex(0x666666);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}
- (UILabel *)describeLabel
{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.numberOfLines = 1;
        _describeLabel.font = [UIFont systemFontOfSize:15];
        _describeLabel.textColor = CCCUIColorFromHex(0x333333);
        _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _describeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _describeLabel;
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(15, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [[UIColor colorWithWhite:0.5 alpha:0.5] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
