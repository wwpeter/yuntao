
#import "YTAssistanterModel.h"

@implementation YTAssistanter

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"assistanterId":@"id"};
}

@end

@implementation YTAssistanterModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"assistanters":@"data"};
}
@end
