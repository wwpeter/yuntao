#import "ShopDetailSubtractPayTableCell.h"
#import "UIImage+HBClass.h"
#import "SubtractFullModel.h"

@interface ShopDetailSubtractPayTableCell ()

@property (nonatomic, strong) UIImageView* horizontalLine;
@end

@implementation ShopDetailSubtractPayTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
- (void)configShopDetailSubtractPayTimes:(NSArray*)fullRules
{
    for (NSInteger i = 0; i < fullRules.count; i++) {
        SubtractFullRule* fullRule = fullRules[i];
        NSString* subtractStr = [NSString stringWithFormat:@"%@-%@ 每满%@减%@元 最高减%@元", fullRule.startTime, fullRule.endTime, @(fullRule.subtractFull), @(fullRule.subtractCur), @(fullRule.subtractMax)];
        if (i == 0) {
            self.firstTimeView.timeLabel.text = subtractStr;
        }
        else if (i == 1) {
            self.secondTimeView.timeLabel.text = subtractStr;
            self.secondTimeView.hidden = NO;
        }
        else if (i == 2) {
            self.thirdTimeView.timeLabel.text = subtractStr;
            self.thirdTimeView.hidden = NO;
        }
        else {
        }
    }
    self.horizontalLine.hidden = fullRules.count == 0 ? YES : NO;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
#pragma mark - Event response
- (void)payButtonClicked:(id)sender
{
    if (self.payBlock) {
        self.payBlock(PreferencePayTypeSubtract);
    }
}
- (void)tapContentView:(UITapGestureRecognizer *)tap
{
    if (self.selectBlock) {
        self.selectBlock();
    }
}
#pragma maek - SubViews
- (void)configureSubview
{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.buyLabel];
    [self.contentView addSubview:self.payButton];
    [self.contentView addSubview:self.horizontalLine];
    [self.contentView addSubview:self.firstTimeView];
    [self.contentView addSubview:self.secondTimeView];
    [self.contentView addSubview:self.thirdTimeView];
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)]];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(18);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [_payButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(_iconImageView);
            make.size.mas_equalTo(CGSizeMake(120, 36));
        }];
        [_buyLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_iconImageView.right).offset(10);
            make.centerY.mas_equalTo(_iconImageView);
            make.right.mas_equalTo(_payButton.left).priorityLow();
        }];
        [_horizontalLine mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(58);
            make.left.mas_equalTo(45);
            make.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
        [_firstTimeView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(_horizontalLine.bottom).offset(3);
            make.height.mas_equalTo(26);
        }];
        [_secondTimeView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(_firstTimeView.bottom);
            make.left.right.and.height.mas_equalTo(_firstTimeView);
        }];
        [_thirdTimeView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(_secondTimeView.bottom);
            make.left.right.and.height.mas_equalTo(_firstTimeView);
        }];

        self.didSetupConstraints = YES;
    }

    [super updateConstraints];
}
#pragma mark - Setter & Getter
- (UIImageView*)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_subtractIcon.png"]];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}
- (UILabel*)buyLabel
{
    if (!_buyLabel) {
        _buyLabel = [[UILabel alloc] init];
        _buyLabel.textColor = [UIColor blackColor];
        _buyLabel.font = [UIFont systemFontOfSize:15];
        _buyLabel.numberOfLines = 1;
        _buyLabel.attributedText = [self buyAttributedString];
    }
    return _buyLabel;
}
- (UIButton*)payButton
{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.layer.masksToBounds = YES;
        _payButton.layer.cornerRadius = 2;
        _payButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0x8bb934)] forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_payButton setTitle:@"优惠买单" forState:UIControlStateNormal];
    }
    return _payButton;
}
- (UIImageView*)horizontalLine
{
    if (!_horizontalLine) {
        _horizontalLine = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    }
    return _horizontalLine;
}
- (SubtractPayTimeView*)firstTimeView
{
    if (!_firstTimeView) {
        _firstTimeView = [[SubtractPayTimeView alloc] init];
    }
    return _firstTimeView;
}
- (SubtractPayTimeView*)secondTimeView
{
    if (!_secondTimeView) {
        _secondTimeView = [[SubtractPayTimeView alloc] init];
        _secondTimeView.hidden = YES;
    }
    return _secondTimeView;
}
- (SubtractPayTimeView*)thirdTimeView
{
    if (!_thirdTimeView) {
        _thirdTimeView = [[SubtractPayTimeView alloc] init];
        _thirdTimeView.hidden = YES;
    }
    return _thirdTimeView;
}
- (NSAttributedString *)buyAttributedString
{
    UIImage* ruleImage = [UIImage imageNamed:@"yt_full_rule_icon.png"];
    NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
    attachment.image = ruleImage;
    attachment.bounds = CGRectMake(2, -2, ruleImage.size.width, ruleImage.size.height);
    NSAttributedString* ruleAttachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString* fullAttributedString = [[NSMutableAttributedString alloc] initWithString:@"满减优惠"];
    NSAttributedString* fullText = [[NSMutableAttributedString alloc] initWithString:@" 优惠说明"];
    [fullAttributedString appendAttributedString:ruleAttachmentString];
    [fullAttributedString appendAttributedString:fullText];
    NSRange range = NSMakeRange(6, 4);
    [fullAttributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:12]
                                 range:range];
    [fullAttributedString addAttribute:NSForegroundColorAttributeName
                                 value:CCCUIColorFromHex(0x999999)
                                 range:range];
    return [[NSAttributedString alloc] initWithAttributedString:fullAttributedString];
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

@implementation SubtractPayTimeView

- (instancetype)init
{
    self = [super init];
    if (!self)
        return nil;
    [self configSubViews];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    [self configSubViews];
    return self;
}
#pragma mark - Event response

#pragma mark - Subviews
- (void)configSubViews
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.timeImageView];
    [self addSubview:self.timeLabel];
    [_timeImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(45);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_timeImageView.right).offset(3);
        make.centerY.mas_equalTo(_timeImageView);
        make.right.mas_equalTo(self);
    }];
}

#pragma mark - Setter & Getter
- (UIImageView*)timeImageView
{
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_subtractTime02.png"]];
    }
    return _timeImageView;
}
- (UILabel*)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = CCCUIColorFromHex(0x999999);
        _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _timeLabel;
}

@end
