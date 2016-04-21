#import "MoneyHongbaoReceiveTableCell.h"
#import "YTPsqptHbListModel.h"
#import "NSDate+Utilities.h"

static const NSInteger kDefaultPadding = 15;

@implementation MoneyHongbaoReceiveTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
#pragma mark - Public methods
- (void)configKMoneyHongbaoReceiveCellWithModel:(YTPsqptHb *)psqptHb
{
    [self.headImageView setYTImageWithURL:[psqptHb.img imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
    self.nameLabel.text = psqptHb.mobile;
    self.costLabel.text = [NSString stringWithFormat:@"￥%.2f", psqptHb.money / 100.];
    NSDate* createdDate = [NSDate dateWithTimeIntervalSince1970:psqptHb.createdAt / 1000];
    if ([createdDate isToday]) {
        self.timeLabel.text = [YTTaskHandler outDateStrWithTimeStamp:psqptHb.createdAt withStyle:@"HH:mm"];
    }
    else {
        self.timeLabel.text = [YTTaskHandler outDateStrWithTimeStamp:psqptHb.createdAt withStyle:@"yyyy-MM-dd HH:mm"];
    }

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
#pragma maek - SubViews
- (void)configureSubview
{
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.costLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {

        [_headImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(kDefaultPadding);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [_costLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.mas_equalTo(-kDefaultPadding);
            make.centerY.mas_equalTo(self.contentView);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_headImageView.right).offset(kDefaultPadding);
            make.top.mas_equalTo(_headImageView);
            make.right.mas_equalTo(_costLabel.left).priorityHigh();
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.mas_equalTo(_nameLabel);
            make.top.mas_equalTo(_nameLabel.bottom).offset(5);
        }];

        self.didSetupConstraints = YES;
    }

    [super updateConstraints];
}

#pragma mark - Getters & Setters
- (UIImageView*)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.clipsToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 40 / 2;
    }
    return _headImageView;
}
- (UILabel*)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}
- (UILabel*)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = CCCUIColorFromHex(0x666666);
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.numberOfLines = 1;
    }
    return _timeLabel;
}
- (UILabel*)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.textColor = CCCUIColorFromHex(0x333333);
        _costLabel.font = [UIFont systemFontOfSize:18];
        _costLabel.numberOfLines = 1;
        _costLabel.textAlignment = NSTextAlignmentRight;
    }
    return _costLabel;
}

@end
