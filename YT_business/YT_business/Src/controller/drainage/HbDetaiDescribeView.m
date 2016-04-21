#import "HbDetaiDescribeView.h"
#import "NSStrUtil.h"
#import "UIView+DKAddition.h"

@implementation HbDetaiDescribeView

- (instancetype)initWithFrame:(CGRect)frame describeTextHeight:(CGFloat)height
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
   
    return self;
}
- (instancetype)initWithDescribe:(NSString *)describe frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    [self configSubViewWithDescribe:describe];
    return self;

}
- (void)configSubViewWithDescribe:(NSString *)describe
{
    UIFont *textFont = [UIFont systemFontOfSize:14];
    CGFloat textMaxWidth = CGRectGetWidth(self.bounds) - 15;
    
    CGFloat describeTextHeight = [NSStrUtil stringHeightWithString:describe stringFont:textFont textWidth:textMaxWidth-10];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, textMaxWidth, 15)];
    _titleLabel.numberOfLines = 1;
    _titleLabel.font = textFont;
    _titleLabel.textColor = CCCUIColorFromHex(0xfd5c63);
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_titleLabel];
    
    _describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, textMaxWidth-10,describeTextHeight)];
    _describeLabel.numberOfLines = 0;
    _describeLabel.font = textFont;
    _describeLabel.textColor = CCCUIColorFromHex(0x333333);
    _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _describeLabel.text = describe;
    [self addSubview:_describeLabel];
}
- (CGSize)fitOptimumSize;
{
    CGRect rect = self.frame;
    rect.size.height = _describeLabel.dk_bottom+10;
    self.frame = rect;
    
    return rect.size;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
