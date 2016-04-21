
#import "YTHbThrowView.h"
#import "UIView+DKAddition.h"

static const NSInteger kDefaultPadding = 15;

@interface YTHbThrowView ()
@property (strong, nonatomic) UIImageView* throwImageView;
@property (strong, nonatomic) UIImageView* pullImageView;
@property (strong, nonatomic) UIImageView* leadImageView;

@property (strong, nonatomic) UILabel* throwLabel;
@property (strong, nonatomic) UILabel* pullLabel;
@property (strong, nonatomic) UILabel* leadLabel;
@end

@implementation YTHbThrowView

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
- (void)configNumberTou:(NSInteger)tou ling:(NSInteger)ling yin:(NSInteger)yin
{
    // 字数过多 -3微调
    if (tou > 999) {
        self.throwLabel.text = @"999+";
        self.throwImageView.dk_width = 50;
        self.throwLabel.dk_width = 30;
        self.pullImageView.dk_x = self.throwImageView.dk_x + self.throwImageView.dk_width + kDefaultPadding - 3;
        self.leadImageView.dk_x = self.pullImageView.dk_x + self.pullImageView.dk_width + kDefaultPadding - 3;
        self.pullLabel.dk_x = self.pullImageView.dk_x + 18;
        self.leadLabel.dk_x = self.leadImageView.dk_x + 18;
    }
    else {
        self.throwLabel.text = [NSString stringWithFormat:@"%@", @(tou)];
    }
    if (ling > 999) {
        self.pullLabel.text = @"999+";
        self.pullImageView.dk_width = 50;
        self.pullLabel.dk_width = 30;
        self.leadImageView.dk_x = self.pullImageView.dk_x + self.pullImageView.dk_width + kDefaultPadding - 3;
        self.leadLabel.dk_x = self.leadImageView.dk_x + 18;
    }
    else {
        self.pullLabel.text = [NSString stringWithFormat:@"%@", @(ling)];
    }
    if (yin > 999) {
        self.leadLabel.text = @"999+";
        self.leadImageView.dk_width = 50;
        self.leadLabel.dk_width = 30;
    }
    else {
        self.leadLabel.text = [NSString stringWithFormat:@"%@", @(yin)];
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    UIImage* throwImage = [[UIImage imageNamed:@"hb_cell_tou.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:5];
    UIImage* pullImage = [[UIImage imageNamed:@"hb_cell_ling.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:5];
    UIImage* leadImage = [[UIImage imageNamed:@"hb_cell_yin.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:5];

    self.throwImageView = [[UIImageView alloc] initWithImage:throwImage];
    self.pullImageView = [[UIImageView alloc] initWithImage:pullImage];
    self.leadImageView = [[UIImageView alloc] initWithImage:leadImage];

    self.throwImageView.frame = CGRectMake(0, 0, 40, 15);
    self.pullImageView.frame = CGRectMake(50, 0, 40, 15);
    self.leadImageView.frame = CGRectMake(2 * 40 + 20, 0, 40, 15);

    [self addSubview:self.throwImageView];
    [self addSubview:self.pullImageView];
    [self addSubview:self.leadImageView];

    self.throwLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.throwImageView.dk_x + 18, 0, 22, 15)];
    self.throwLabel.numberOfLines = 1;
    self.throwLabel.font = [UIFont systemFontOfSize:12];
    self.throwLabel.textColor = CCCUIColorFromHex(0x50b3dc);
    self.throwLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.throwLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.throwLabel];

    self.pullLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.pullImageView.dk_x + 18, 0, 22, 15)];
    self.pullLabel.numberOfLines = 1;
    self.pullLabel.font = [UIFont systemFontOfSize:12];
    self.pullLabel.textColor = CCCUIColorFromHex(0xffae00);
    self.pullLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.pullLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.pullLabel];

    self.leadLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leadImageView.dk_x + 18, 0, 22, 15)];
    self.leadLabel.numberOfLines = 1;
    self.leadLabel.font = [UIFont systemFontOfSize:12];
    self.leadLabel.textColor = CCCUIColorFromHex(0xfd5c63);
    self.leadLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.leadLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.leadLabel];
}

@end
