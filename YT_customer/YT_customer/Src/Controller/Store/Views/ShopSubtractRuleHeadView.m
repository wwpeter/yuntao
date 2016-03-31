
#import "ShopSubtractRuleHeadView.h"
#import "ShopSubtractRuleSectionHeadView.h"
#import "NSStrUtil.h"
#import "UIView+DKAddition.h"
#import "SubtractFullModel.h"

@implementation ShopSubtractRuleHeadView

- (instancetype)initWithRulesDesc:(NSArray *)texts frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    self.backgroundColor = [UIColor whiteColor];
    [self configSubViewWithRules:texts];
    return self;
}
- (void)configSubViewWithRules:(NSArray *)texts
{
    [self addSubview:self.headView];
    UIFont* textFont = [UIFont systemFontOfSize:14];
    CGFloat textMaxWidth = CGRectGetWidth(self.bounds) - 15;
//    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:ruleDesc.other];
//    [mutableArr insertObject:ruleDesc.range atIndex:0];
    CGFloat ruleHeight = 10 + self.headView.dk_bottom;
    for (NSInteger i = 0; i < texts.count; i++) {
        NSString* rule = texts[i];
        CGFloat textHeight = [NSStrUtil stringHeightWithString:rule stringFont:textFont textWidth:textMaxWidth - 10];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(12, ruleHeight, textMaxWidth - 10, textHeight)];
        label.numberOfLines = 0;
        label.font = textFont;
        label.textColor = CCCUIColorFromHex(0x333333);
        label.text = [NSString stringWithFormat:@"• %@", rule];
        [self addSubview:label];
        ruleHeight += textHeight + 15;
    }
    self.rulesHeight = ruleHeight;
}
- (NSArray*)fullSubtractRules:(NSString*)hongbaoRules
{
    NSMutableArray* ruleArr = [NSMutableArray array];
    NSArray* rules = [NSJSONSerialization JSONObjectWithData:[hongbaoRules dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary* ruleDict in rules) {
        NSArray* descArr = [ruleDict objectForKey:@"descs"];
        if (descArr.count > 0) {
            for (NSString* ruleStr in descArr) {
                [ruleArr addObject:ruleStr];
            }
        }
    }
    return @[ @"是空间的链接卡萨圣诞节啊看来房价阿卡丽；附近阿卡丽；", @"水电费回家阿克拉对方会尽快的法律和垃圾开发法即可", @"爱上了大家阿里可视对讲阿卡丽上点击阿喀琉斯的骄傲是可怜的健康啦" ];
    //    return [[NSArray alloc] initWithArray:ruleArr];
}

- (CGSize)fitOptimumSize
{
    CGRect rect = self.frame;
    rect.size.height = self.rulesHeight;
    self.frame = rect;

    return rect.size;
}

#pragma mark - Setter & Getter
- (ShopSubtractRuleSectionHeadView*)headView
{
    if (!_headView) {
        _headView = [[ShopSubtractRuleSectionHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 45)];
        _headView.showBottomLine = YES;
        _headView.title = @"规则说明";
    }
    return _headView;
}

- (void)drawRect:(CGRect)rect
{

    UIColor* ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath* bezierPath;

    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}
@end
