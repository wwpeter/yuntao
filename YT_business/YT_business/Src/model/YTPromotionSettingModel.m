#import "YTPromotionSettingModel.h"


@implementation YTPromotionSet


@end

@implementation YTPromotionSettingModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"promotionSet":@"data"};
}
@end

@implementation YTSubtractFullModel

@end

@implementation YTFullSubtract

#pragma mark -override
- (instancetype)initWithJSONDict:(NSDictionary*)dict
{
    self = [self init];
    if (self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self performSelector:@selector(injectJSONData:)
                   withObject:dict];
#pragma clang diagnostic pop
        [self setupSubtractFull];
    }
    return self;
}
- (void)setupSubtractFull
{
    if ([NSStrUtil notEmptyOrNull:self.rule]) {
        NSArray* curArray = [self.rule componentsSeparatedByString:@"/"];
        self.subtractFull = [[curArray firstObject] integerValue] / 100;
        self.subtractCur = [curArray[1] integerValue] /100;
        self.subtractMax = [[curArray lastObject] integerValue] / 100;
    }
}
@end