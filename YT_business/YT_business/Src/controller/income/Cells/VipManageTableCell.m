#import "VipManageTableCell.h"
#import "UIView+DKAddition.h"
#import "UIImageView+WebCache.h"
#import "NSStrUtil.h"
#import "YTVipManageModel.h"
#import "NSDate+TimeInterval.h"

static const NSInteger kDefaultPadding = 15;
static const NSInteger kRightWidth = 100;

@interface VipManageTableCell ()

@end

@implementation VipManageTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}

- (void)configVipManageCellWithModel:(YTVipManage*)vipManage;
{
    self.throwsView.hidden = self.detailLabel.hidden = YES;
    self.timeLabel.text = [YTTaskHandler outDateStrWithTimeStamp:vipManage.createdAt withStyle:@"yyyy-MM-dd HH:mm"];
    self.sendLabel.attributedText = [vipManage sendAttributedString];
    if (vipManage.hongbaoLx == YTDistributeHongbaoTypeXjhb) {
        [self.hbImageView setYTImageWithURL:[vipManage.hongbao.img imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
        self.nameLabel.text = vipManage.hongbao.name;
        self.costLabel.text = [NSString stringWithFormat:@"￥%.2f", vipManage.hongbao.cost / 100.];
        self.throwsView.hidden = NO;
        [self.throwsView configNumberTou:vipManage.hongbao.tou ling:vipManage.hongbao.ling yin:vipManage.hongbao.yin];
    }
    else if (vipManage.hongbaoLx == YTDistributeHongbaoTypeNotice) {
        self.detailLabel.hidden = NO;
        self.hbImageView.image = [UIImage imageNamed:@"distribute_pushNormal.png"];
        self.nameLabel.text = @"免费广告";
        self.detailLabel.text = vipManage.content;
        self.costLabel.text = @"";
    }
    else {
        self.detailLabel.hidden = NO;
        self.hbImageView.image = [UIImage imageNamed:@"distribute_hbNormal.png"];
        self.detailLabel.text = [NSString stringWithFormat:@"已领完%@/%@个", @(vipManage.getNum), @(vipManage.hongbaoNum)];
        self.costLabel.text = [NSString stringWithFormat:@"￥%.2f", vipManage.totalSum / 100.];
        self.nameLabel.text = vipManage.hongbaoLx == YTDistributeHongbaoTypePthb ? @"普通红包" : @"拼手气红包";
    }
}
#pragma maek - SubViews
- (void)configureSubview
{
    UIView* belongView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
    [self.contentView addSubview:belongView];

    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultPadding, 0, 120, 30)];
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textColor = CCCUIColorFromHex(0x666666);
    [belongView addSubview:self.timeLabel];

    self.sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeLabel.dk_right, 0, kDeviceWidth - _timeLabel.dk_right - kDefaultPadding, 30)];
    self.sendLabel.numberOfLines = 1;
    self.sendLabel.font = [UIFont systemFontOfSize:13];
    self.sendLabel.textColor = CCCUIColorFromHex(0x666666);
    self.sendLabel.textAlignment = NSTextAlignmentRight;
    [belongView addSubview:self.sendLabel];

    self.hbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDefaultPadding, belongView.dk_bottom + 12, 45, 45)];
    self.hbImageView.clipsToBounds = YES;
    self.hbImageView.layer.masksToBounds = YES;
    self.hbImageView.layer.cornerRadius = 2;
    self.hbImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.hbImageView];

    self.costLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - kRightWidth - kDefaultPadding, _hbImageView.dk_y, kRightWidth, 22)];
    self.costLabel.numberOfLines = 1;
    self.costLabel.font = [UIFont systemFontOfSize:20];
    self.costLabel.textColor = CCCUIColorFromHex(0xfd5c63);
    self.costLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.costLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.costLabel];

    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_hbImageView.dk_right + kDefaultPadding, _hbImageView.dk_y, kDeviceWidth - _hbImageView.dk_right - kRightWidth - kDefaultPadding, 20)];
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.nameLabel];

    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.dk_x, _nameLabel.dk_bottom + 5, kDeviceWidth - _hbImageView.dk_right, 20)];
    self.detailLabel.numberOfLines = 1;
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.textColor = CCCUIColorFromHex(0x666666);
    [self.contentView addSubview:self.detailLabel];

    self.throwsView = [[YTHbThrowView alloc] initWithFrame:CGRectMake(_nameLabel.dk_x, _detailLabel.dk_y, kDeviceWidth - _hbImageView.dk_right, 24)];
    [self.contentView addSubview:self.throwsView];
    self.throwsView.hidden = YES;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath* bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 30)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 30)];
    [[UIColor colorWithWhite:0.5f alpha:0.5] setStroke];
    [bezierPath setLineWidth:0.5f];
    [bezierPath stroke];
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
@end
