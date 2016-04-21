#import "YTBarPayModel.h"

@implementation YTBarPayOrder

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"orderId":@"id"};
}
@end

@implementation YTBarPaySet

@end

@implementation YTBarPayModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"barPaySet":@"data"};
}
@end
