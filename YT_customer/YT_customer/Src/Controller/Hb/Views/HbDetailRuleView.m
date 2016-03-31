#import "HbDetailRuleView.h"
#import "NSStrUtil.h"

static const NSInteger kDefaultPadding = 10;

@implementation HbDetailRuleView

- (instancetype)initWithFrame:(CGRect)frame rules:(NSArray *)rules
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    [self configSubViewWithRules:rules];
    return self;
}
- (instancetype)initWithRulesDesc:(NSString *)ruleDesc frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    NSArray *rules = [self hongbaoRules:ruleDesc];
    [self configSubViewWithRules:rules];
    return self;
}
- (void)configSubViewWithRules:(NSArray *)rules
{
    UIFont *textFont = [UIFont systemFontOfSize:14];
    CGFloat textMaxWidth = CGRectGetWidth(self.bounds) - 15;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, textMaxWidth, 15)];
    _titleLabel.numberOfLines = 1;
    _titleLabel.font = textFont;
    _titleLabel.textColor = CCCUIColorFromHex(0xfd5c63);
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_titleLabel];
    
     CGFloat ruleHeight = 15+kDefaultPadding;
    for (NSInteger i = 0; i<rules.count; i++) {
        NSString *rule = rules[i];
        CGFloat textHeight = [NSStrUtil stringHeightWithString:rule stringFont:textFont textWidth:textMaxWidth-10];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, ruleHeight, textMaxWidth-10,textHeight)];
        label.numberOfLines = 0;
        label.font = textFont;
        label.textColor = CCCUIColorFromHex(0x333333);
        label.text = rule;
        [self addSubview:label];
        ruleHeight += textHeight + kDefaultPadding;
    }
    self.rulesHeight = ruleHeight;
}
- (NSArray *)hongbaoRules:(NSString *)hongbaoRules
{
    NSMutableArray *ruleArr = [NSMutableArray array];
    NSArray *rules = [NSJSONSerialization JSONObjectWithData:[hongbaoRules dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *ruleDict in rules) {
        NSArray *descArr = [ruleDict objectForKey:@"descs"];
        if (descArr.count > 0) {
            for (NSString *ruleStr in descArr) {
                [ruleArr addObject:ruleStr];
            }
        }
    }
    return [[NSArray alloc] initWithArray:ruleArr];
}

- (CGSize)fitOptimumSize
{
    CGRect rect = self.frame;
    rect.size.height = self.rulesHeight;
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
