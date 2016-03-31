#import "YTXjswHbListModel.h"
#import "UserMationMange.h"

@implementation YTXjswHb
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"xjId"}];
}
@end

@implementation YTXjswHbListSet

@end

@implementation YTXjswHbListModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data":@"hbListSet"}];
}
@end
