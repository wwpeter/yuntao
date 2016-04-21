
#import "YTUpdateShopInfoModel.h"


@implementation YTUpdateShopInfo

- (NSDictionary*)modelKeyJSONKeyMapper
{
    return @{@"shopCategory" : @"shopcat"};
}
#pragma mark -NSCoding
- (id)initWithCoder:(NSCoder*)aDecoder
{
    [self setShop:[aDecoder decodeObjectForKey:@"shop"]];
    [self setHjImg:[aDecoder decodeObjectForKey:@"hjImg"]];
    [self setShopCategory:[aDecoder decodeObjectForKey:@"shopCategory"]];
    [self setReceiveableHongbao:[aDecoder decodeObjectForKey:@"receiveableHongbao"]];
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.shop forKey:@"shop"];
    [aCoder encodeObject:self.hjImg forKey:@"hjImg"];
    [aCoder encodeObject:self.shopCategory forKey:@"shopCategory"];
    [aCoder encodeObject:self.receiveableHongbao forKey:@"receiveableHongbao"];
}
@end

@implementation YTUpdateShopInfoModel
- (NSDictionary*)modelKeyJSONKeyMapper
{
    return @{ @"shopInfo" : @"data" };
}
@end
