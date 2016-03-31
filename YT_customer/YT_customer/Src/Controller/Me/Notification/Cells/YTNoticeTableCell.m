#import "YTNoticeTableCell.h"
#import "YTNoticeModel.h"
#import "NSDate+TimeInterval.h"
#import "YTPublishListModel.h"

@implementation YTNoticeTableCell

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
- (void)configNoticeCellWithModel:(YTNotice*)notice
{
    self.mesLabel.text = notice.message;
    self.timeLabel.text = [NSDate timestampToTimeSting:notice.sendTime / 1000 dateFormar:@"yyyy-MM-dd hh:mm"];
    self.dotsImageView.hidden = YES;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)configNoticeCellWithPublishModel:(YTPublish*)publish
{
    self.mesLabel.text = publish.content;
    self.timeLabel.text = [NSDate timestampToTimeSting:publish.createdAt / 1000 dateFormar:@"yyyy-MM-dd hh:mm"];
    if ([publish.currUserReadYN isEqualToString:@"Y"]) {
        self.dotsImageView.hidden = YES;
    }
    else {
        self.dotsImageView.hidden = NO;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
#pragma maek - SubViews
- (void)configureSubview
{
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.dotsImageView];
    [self.contentView addSubview:self.mesLabel];
    [self.contentView addSubview:self.timeLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {

        [_headImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.and.top.mas_equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(25, 22));
        }];

        [_dotsImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_headImageView.right).offset(-6);
            make.top.mas_equalTo(_headImageView).offset(-2);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        [_mesLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(_headImageView);
            make.left.mas_equalTo(_headImageView.right).offset(10);
            make.right.mas_equalTo(-10); // need
        }];

        [_timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(_mesLabel.bottom).offset(5);
            make.left.right.mas_equalTo(_mesLabel);
            make.bottom.mas_equalTo(-10); // need
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

    self.mesLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds) - 30 - 15 - 10;
}
#pragma mark - Setter & Getter
- (UIImageView*)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.clipsToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.image = [UIImage imageNamed:@"zhq_notify_list_icon"];
    }
    return _headImageView;
}
- (UIImageView*)dotsImageView
{
    if (!_dotsImageView) {
        _dotsImageView = [[UIImageView alloc] init];
        _dotsImageView.clipsToBounds = YES;
        _dotsImageView.layer.masksToBounds = YES;
        _dotsImageView.layer.cornerRadius = 4;
        _dotsImageView.backgroundColor = [UIColor redColor];
    }
    return _dotsImageView;
}
- (UILabel*)mesLabel
{
    if (!_mesLabel) {
        _mesLabel = [[UILabel alloc] init];
        _mesLabel.textColor = CCCUIColorFromHex(0x333333);
        _mesLabel.font = [UIFont systemFontOfSize:14];
        _mesLabel.numberOfLines = 0;
    }
    return _mesLabel;
}
- (UILabel*)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = CCCUIColorFromHex(0x999999);
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.numberOfLines = 1;
    }
    return _timeLabel;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//
//    CGContextSetRGBFillColor(contextRef, 250, 0, 0, 1.0);
//    // Draw a circle (filled)
//    CGContextFillEllipseInRect(contextRef, CGRectMake(35, 16, 5, 5));
//    // Draw a circle (border only)
////    CGContextStrokeEllipseInRect(contextRef, CGRectMake(100, 100, 25, 25));
//    CGContextFillPath(contextRef);
//}
@end
