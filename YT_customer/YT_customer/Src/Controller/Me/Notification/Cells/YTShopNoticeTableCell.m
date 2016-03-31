#import "YTShopNoticeTableCell.h"
#import "UIImageView+WebCache.h"
#import "NSStrUtil.h"
#import <JSBadgeView/JSBadgeView.h>
#import "YTXjswHbListModel.h"
#import "NSDate+TimeInterval.h"

static const NSInteger kDefaultPadding = 10;

@interface YTShopNoticeTableCell () {
    JSBadgeView *_badgeView;
}
@end

@implementation YTShopNoticeTableCell

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
- (void)configShopNoticeCellWithModel:(YTXjswHb *)xjswHb
{
    [self.shopImageView sd_setImageWithURL:[xjswHb.shop.img imageUrlWithWidth:200] placeholderImage:YTNormalPlaceImage];
    self.nameLabel.attributedText = [xjswHb.shop nameAttributeStr];
    self.rankImageView.image = [UIImage imageNamed:@"yt_star_level_10.png"];
    self.costLabel.text = [NSString stringWithFormat:@"￥%.2f/人",xjswHb.shop.cost/100.];
    self.catLabel.text = [NSString stringWithFormat:@"%@ %@", xjswHb.catName, [xjswHb.shop userLocationDistance]];
    if (xjswHb.shop.promotionType == 1) {
        self.discountLabel.attributedText = [xjswHb.shop discountAttributed];
    }  else  if (xjswHb.shop.promotionType == 2 && [NSStrUtil notEmptyOrNull:xjswHb.shop.curFullSubtract] && xjswHb.shop.conflictVer) {
        self.subtractLabel.text = [NSString stringWithFormat:@" 满%@减%@  ",@(xjswHb.shop.subtractFull),@(xjswHb.shop.subtractCur)];
    }else{
        self.subtractLabel.text = @"";
    }
    if (xjswHb.num == 0){
         _badgeView.badgeText = @"";
    }else {
        _badgeView.badgeText = [NSString stringWithFormat:@"%@",@(xjswHb.num)];
    }
   
    self.timeLabel.text = [NSDate timestampToYear:xjswHb.createdAt/1000];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
#pragma maek - SubViews
- (void)configureSubview
{
    [self.contentView addSubview:self.shopImageView];
    [self.contentView addSubview:self.rankImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.costLabel];
    [self.contentView addSubview:self.catLabel];
    [self.contentView addSubview:self.discountLabel];
    [self.contentView addSubview:self.subtractLabel];
    _badgeView = [[JSBadgeView alloc] initWithParentView:self.contentView alignment:JSBadgeViewAlignmentTopLeft];
    _badgeView.badgeTextFont = [UIFont systemFontOfSize:12];
    _badgeView.badgePositionAdjustment = CGPointMake(70, 14);
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_shopImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(kDefaultPadding);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_shopImageView).offset(2);
            make.right.mas_equalTo(-12);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(_shopImageView).offset(2);
            make.left.mas_equalTo(_shopImageView.right).offset(kDefaultPadding);
            make.right.mas_equalTo(-100);
        }];
        [_rankImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(_nameLabel.bottom).offset(8);
            make.left.mas_equalTo(_nameLabel);
            make.size.mas_equalTo(CGSizeMake(76, 12));
        }];
        [_costLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_rankImageView.right).offset(kDefaultPadding);
            make.top.mas_equalTo(_rankImageView);
            make.right.mas_equalTo(self.contentView);
        }];
        [_subtractLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.mas_equalTo(self.contentView).offset(-kDefaultPadding);
            make.top.mas_equalTo(_rankImageView);
            make.height.mas_equalTo(20);
        }];
        [_catLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_rankImageView);
            make.top.mas_equalTo(_rankImageView.bottom).offset(8);
            make.right.mas_equalTo(self.contentView).offset(-90);
        }];
        [_discountLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.mas_equalTo(self.contentView).offset(-kDefaultPadding);
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(120);
        }];
        self.didSetupConstraints = YES;
    }

    [super updateConstraints];
}

#pragma mark - Getters & Setters
- (UIImageView*)shopImageView
{
    if (!_shopImageView) {
        _shopImageView = [[UIImageView alloc] init];
        _shopImageView.clipsToBounds = YES;
        _shopImageView.layer.masksToBounds = YES;
        _shopImageView.layer.cornerRadius = 2;
        _shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _shopImageView;
}
- (UIImageView*)rankImageView
{
    if (!_rankImageView) {
        _rankImageView = [[UIImageView alloc] init];
    }
    return _rankImageView;
}
- (UILabel*)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = CCCUIColorFromHex(0x333333);
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}
- (UILabel*)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = CCCUIColorFromHex(0x666666);
        _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}
- (UILabel*)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.numberOfLines = 1;
        _costLabel.font = [UIFont systemFontOfSize:12];
        _costLabel.textColor = CCCUIColorFromHex(0x333333);
        _costLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _costLabel;
}
- (UILabel*)catLabel
{
    if (!_catLabel) {
        _catLabel = [[UILabel alloc] init];
        _catLabel.numberOfLines = 1;
        _catLabel.font = [UIFont systemFontOfSize:13];
        _catLabel.textColor = CCCUIColorFromHex(0x999999);
        _catLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _catLabel;
}
- (UILabel*)discountLabel
{
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.numberOfLines = 1;
        _discountLabel.font = [UIFont systemFontOfSize:15];
        _discountLabel.textColor = YTDefaultRedColor;
        _discountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _discountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _discountLabel;
}
- (UILabel*)subtractLabel
{
    if (!_subtractLabel) {
        _subtractLabel = [[UILabel alloc] init];
        _subtractLabel.layer.masksToBounds = YES;
        _subtractLabel.layer.borderWidth = 1;
        _subtractLabel.layer.borderColor = [YTDefaultRedColor CGColor];
        _subtractLabel.layer.cornerRadius = 3.0;
        _subtractLabel.numberOfLines = 1;
        _subtractLabel.font = [UIFont systemFontOfSize:13];
        _subtractLabel.textColor = YTDefaultRedColor;
        _subtractLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subtractLabel;
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
- (NSAttributedString*)nameAttributed
{
    UIImage* redImage = [UIImage imageNamed:@"yt_hongIcon.png"];
    NSTextAttachment* redAttachment = [[NSTextAttachment alloc] init];
    redAttachment.image = redImage;
    redAttachment.bounds = CGRectMake(10, -2, redImage.size.width, redImage.size.height);
    NSAttributedString* redAttachmentString =
        [NSAttributedString attributedStringWithAttachment:redAttachment];

    NSString* foldImageName = /* DISABLES CODE */ (2) == 1 ? @"yt_zheIcon.png" : @"yt_subtractIcon.png";
    UIImage* foldImage = [UIImage imageNamed:foldImageName];
    NSTextAttachment* foldAttachment = [[NSTextAttachment alloc] init];
    foldAttachment.image = foldImage;
    foldAttachment.bounds = CGRectMake(15, -2, foldImage.size.width, foldImage.size.height);
    NSAttributedString* foldpAttachmentString =
        [NSAttributedString attributedStringWithAttachment:foldAttachment];

    NSMutableAttributedString* attString =
        [[NSMutableAttributedString alloc] initWithString:@"金已银城电影"];
    [attString appendAttributedString:redAttachmentString];

    [attString appendAttributedString:foldpAttachmentString];
    return [[NSAttributedString alloc] initWithAttributedString:attString];
}
- (NSAttributedString*)discountAttributed
{
    NSString* discountStr =
        [NSString stringWithFormat:@"%.1f", 88 / 10.];
    NSMutableAttributedString* mutableAttributedStr =
        [[NSMutableAttributedString alloc]
            initWithString:[NSString stringWithFormat:@"%@折", discountStr]];
    [mutableAttributedStr addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:30]
                                 range:NSMakeRange(0, discountStr.length)];
    return [[NSAttributedString alloc]
        initWithAttributedString:mutableAttributedStr];
}
@end
