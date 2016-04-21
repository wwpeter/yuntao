#import "HbDetailRecommendView.h"
#import "YTDrainageDetailModel.h"
#import "NSStrUtil.h"

static const NSInteger kLeftPadding = 15;
static const NSInteger kStoreImageTag = 1000;

@implementation HbDetailRecommendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithRecommendShop:(NSArray *)recommendShop frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _recommendShops = recommendShop;
        [self configSubviewsWithRecommendShop:recommendShop];
    }
    return self;
}
#pragma mark - Event response
- (void)tapStoreImage:(UITapGestureRecognizer *)tap
{
    UIImageView* tapImageView = (UIImageView*)tap.view;
    NSInteger tapIndex = tapImageView.tag - kStoreImageTag;
    YTCommonShop* shop = [_recommendShops objectAtIndex:tapIndex];
    if (self.shopSelectBlock) {
        self.shopSelectBlock(shop);
    }
}

#pragma mark - subviews
- (void)configSubviewsWithRecommendShop:(NSArray *)recommendShop
{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    [self addSubview:self.titleLabel];
    
    UIScrollView *shopScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kLeftPadding, 50, viewWidth-kLeftPadding, 90)];
    shopScrollView.contentSize = CGSizeMake(recommendShop.count*80, 0);
    [self addSubview:shopScrollView];

    for (NSInteger i = 0; i<recommendShop.count; i++) {
        YTCommonShop *shop = [recommendShop objectAtIndex:i];
        CGFloat x = i*(65+kLeftPadding);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 65, 65)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = kStoreImageTag + i;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStoreImage:)]];
        [imageView setYTImageWithURL:[shop.img imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
        [shopScrollView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 65, 65, 20)];
        label.textColor = CCCUIColorFromHex(0x333333);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.text = shop.name;
        [shopScrollView addSubview:label];
    }
}

#pragma mark - Setter & Getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.bounds)-15, 40)];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text= @"优先投放商家";
    }
    return _titleLabel;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIColor *ccColor = [UIColor colorWithWhite:0.5 alpha:0.5f];
    UIBezierPath *bezierPath;
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(15, 40)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 40)];
    [ccColor setStroke];
    [bezierPath setLineWidth:0.5f];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
