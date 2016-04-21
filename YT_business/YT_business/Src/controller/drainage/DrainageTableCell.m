
#import "YTDrainageModel.h"
#import "DrainageTableCell.h"
#import "UIView+DKAddition.h"
#import "DrainageIntroModel.h"
#import "UIImageView+WebCache.h"
#import "NSStrUtil.h"

static const NSInteger kDefaultPadding = 10;
static const NSInteger kRightPadding = 85;

@interface DrainageTableCell ()

@property (strong, nonatomic) UIView *throwsView;
@property (strong, nonatomic) UIImageView *throwImageView;
@property (strong, nonatomic) UIImageView *pullImageView;
@property (strong, nonatomic) UIImageView *leadImageView;

@property (strong, nonatomic) UILabel *throwLabel;
@property (strong, nonatomic) UILabel *pullLabel;
@property (strong, nonatomic) UILabel *leadLabel;
@end

@implementation DrainageTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self configureSubview];
    }
    return self;
}

- (void)configDrainageCellWithModel:(YTDrainage *)drainage
{
    self.nameLabel.text = drainage.name;
    if (drainage.status == 3) {
        self.backImageView.image = [UIImage imageNamed:@"hb_cell_background_red.png"];
    } else{
        self.backImageView.image = [UIImage imageNamed:@"hb_cell_background_gray.png"];
    }
    
    self.costLabel.text = [NSString stringWithFormat:@"￥%.2f",drainage.cost/100.];
    self.statusLabel.text = [YTTaskHandler outDrainageStatusStrWithStatus:drainage.status];
    [self.storeImageView setYTImageWithURL:[drainage.img imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
    
    [self configNumberLabels:drainage];
}
- (void)configNumberLabels:(YTDrainage *)drainage
{
    // 字数过多 -3微调
    if (drainage.tou > 999) {
        self.throwLabel.text = @"999+";
        self.throwImageView.dk_width = 50;
        self.throwLabel.dk_width = 30;
        self.pullImageView.dk_x = self.throwImageView.dk_x + self.throwImageView.dk_width +kDefaultPadding-3;
        self.leadImageView.dk_x = self.pullImageView.dk_x + self.pullImageView.dk_width +kDefaultPadding-3;
        self.pullLabel.dk_x = self.pullImageView.dk_x + 18;
         self.leadLabel.dk_x = self.leadImageView.dk_x + 18;
    } else {
        self.throwLabel.text = [NSString stringWithFormat:@"%d",drainage.tou];
    }
    if (drainage.ling > 999) {
        self.pullLabel.text = @"999+";
         self.pullImageView.dk_width = 50;
        self.pullLabel.dk_width = 30;
        self.leadImageView.dk_x = self.pullImageView.dk_x + self.pullImageView.dk_width +kDefaultPadding-3;
        self.leadLabel.dk_x = self.leadImageView.dk_x + 18;
    } else {
        self.pullLabel.text = [NSString stringWithFormat:@"%d",drainage.ling];
    }
    if (drainage.yin > 999) {
        self.leadLabel.text = @"999+";
        self.leadImageView.dk_width = 50;
        self.leadLabel.dk_width = 30;
    } else {
        self.leadLabel.text = [NSString stringWithFormat:@"%d",drainage.yin];
    }
}

#pragma maek - SubViews
-(void)configureSubview
{
    CGFloat backWidth = kDeviceWidth - 20;
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDefaultPadding, 0, backWidth, 70)];
    [self.contentView addSubview:self.backImageView];
    
    self.storeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2*kDefaultPadding, 15, 40, 40)];
    self.storeImageView.clipsToBounds = YES;
    self.storeImageView.layer.masksToBounds = YES;
    self.storeImageView.layer.cornerRadius = 2;
    self.storeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.storeImageView];
    CGFloat nameX = 3*kDefaultPadding+40;
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, 15, backWidth-nameX-kRightPadding, 16)];
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.nameLabel];
    
    self.costLabel = [[UILabel alloc] initWithFrame:CGRectMake(backWidth-kRightPadding, 15, kRightPadding, 22)];
    self.costLabel.numberOfLines = 1;
    self.costLabel.font = [UIFont systemFontOfSize:20];
    self.costLabel.textColor = CCCUIColorFromHex(0xfd5c63);
    self.costLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.costLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.costLabel];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(backWidth-kRightPadding, 15+28, kRightPadding, 22)];
    self.statusLabel.numberOfLines = 1;
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textColor = CCCUIColorFromHex(0x666666);
    self.statusLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.statusLabel];
    
    self.throwsView = [[UIView alloc] initWithFrame:CGRectMake(nameX, 15+28, backWidth-nameX-kRightPadding, 23)];
    [self.contentView addSubview:self.throwsView];
    
    UIImage *throwImage = [[UIImage imageNamed:@"hb_cell_tou.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:5];
    UIImage *pullImage = [[UIImage imageNamed:@"hb_cell_ling.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:5];
    UIImage *leadImage = [[UIImage imageNamed:@"hb_cell_yin.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:5];

    self.throwImageView = [[UIImageView alloc] initWithImage:throwImage];
    self.pullImageView = [[UIImageView alloc] initWithImage:pullImage];
    self.leadImageView = [[UIImageView alloc] initWithImage:leadImage];
    
    self.throwImageView.frame = CGRectMake(0, 0, 40, 15);
     self.pullImageView.frame = CGRectMake(50, 0, 40, 15);
     self.leadImageView.frame = CGRectMake(2*40+20, 0, 40, 15);
    
    [self.throwsView addSubview:self.throwImageView];
    [self.throwsView addSubview:self.pullImageView];
    [self.throwsView addSubview:self.leadImageView];
    
    self.throwLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.throwImageView.dk_x+18, 0, 22, 15)];
    self.throwLabel.numberOfLines = 1;
    self.throwLabel.font = [UIFont systemFontOfSize:12];
    self.throwLabel.textColor = CCCUIColorFromHex(0x50b3dc);
    self.throwLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.throwLabel.textAlignment = NSTextAlignmentCenter;
    [self.throwsView addSubview:self.throwLabel];
    
    self.pullLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.pullImageView.dk_x+18, 0, 22, 15)];
    self.pullLabel.numberOfLines = 1;
    self.pullLabel.font = [UIFont systemFontOfSize:12];
    self.pullLabel.textColor = CCCUIColorFromHex(0xffae00);
    self.pullLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.pullLabel.textAlignment = NSTextAlignmentCenter;
    [self.throwsView addSubview:self.pullLabel];
    
    self.leadLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leadImageView.dk_x+18, 0, 22, 15)];
    self.leadLabel.numberOfLines = 1;
    self.leadLabel.font = [UIFont systemFontOfSize:12];
    self.leadLabel.textColor = CCCUIColorFromHex(0xfd5c63);
    self.leadLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.leadLabel.textAlignment = NSTextAlignmentCenter;
    [self.throwsView addSubview:self.leadLabel];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
