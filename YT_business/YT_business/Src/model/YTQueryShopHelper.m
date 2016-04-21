#import "YTQueryShopHelper.h"

@implementation YTQueryShopHelper
static YTQueryShopHelper* helper;
+ (YTQueryShopHelper*)queryShopHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[YTQueryShopHelper alloc] init];
    });
    return helper;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.shopArray = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
