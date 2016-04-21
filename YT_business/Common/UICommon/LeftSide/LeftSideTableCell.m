#import "LeftSideTableCell.h"

static const NSInteger kDefaultPadding = 25;

@interface LeftSideTableCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic)UIImageView *arrowImageView;
@property (strong, nonatomic)UIImageView *lineImageView;

@end
@implementation LeftSideTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(kDefaultPadding);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_iconImageView.right).offset(15);
            make.centerY.mas_equalTo(_iconImageView);
            // 7+kDefaultPadding
            make.right.mas_equalTo(self.contentView).offset(-(kDefaultPadding+7));
        }];
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-kDefaultPadding);
            make.centerY.mas_equalTo(_iconImageView);
            make.size.mas_equalTo(CGSizeMake(7, 12));

        }];
        [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(kDefaultPadding);
            make.right.mas_equalTo(self.contentView).offset(-kDefaultPadding);
            make.bottom.mas_equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.lineImageView];
}

#pragma mark - Setter & Getter
- (void)setDisplayLine:(BOOL)displayLine
{
    _displayLine = displayLine;
    _lineImageView.hidden = !displayLine;
}
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_leftSideIcon_arrow.png"]];
    }
    return _arrowImageView;
}
- (UIImageView *)lineImageView
{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_leftSide_downline.png"]];
    }
    return _lineImageView;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
