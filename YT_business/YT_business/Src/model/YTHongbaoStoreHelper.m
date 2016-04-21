#import "YTHongbaoStoreHelper.h"
#import "YTHongbaoStoreModel.h"
#import "NSStrUtil.h"

@implementation YTHongbaoStoreHelper

static YTHongbaoStoreHelper* helper;
+ (YTHongbaoStoreHelper *)hongbaoStoreHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[YTHongbaoStoreHelper alloc] init];
    });
    return helper;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.hbArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSDictionary*)setupConfimOrder
{
    NSMutableArray *orders = [[NSMutableArray alloc] init];
    for (YTUsrHongBao *hongbao in self.hbArray) {
        BOOL isvalid = NO;
        for (NSInteger i = 0; i < orders.count; i++) {
            NSDictionary *dic = orders[i];
            NSString *shopId = dic[@"id"];
            if ([shopId isEqualToString:hongbao.shop.shopId]) {
                isvalid = YES;
                NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
                NSArray *shopBuyHongbaos = dic[@"shopBuyHongbaos"];
                NSMutableArray *mArray = [[NSMutableArray alloc] initWithArray:shopBuyHongbaos];
                NSString *imgUrl = hongbao.img;
                if ([NSStrUtil isEmptyOrNull:imgUrl]) {
                    imgUrl = @"";
                }
                NSDictionary *dictionary = @{@"id":hongbao.hongbaoId,
                                             @"name":hongbao.name,
                                             @"price" :@(hongbao.price),
                                             @"title":hongbao.title,
                                             @"img":imgUrl,
                                             @"cost":@(hongbao.cost),
                                            @"num":hongbao.buyNum};
                [mArray addObject:dictionary];
                mDic[@"shopBuyHongbaos"] = mArray;
                CGFloat price = [mDic[@"totalPrice"] floatValue];
                CGFloat totalPrice = (hongbao.price*hongbao.buyNum.integerValue) + price;
                mDic[@"totalPrice"] = @(totalPrice);
                [orders replaceObjectAtIndex:i withObject:mDic];
            }
        }
        if (!isvalid) {
            NSMutableDictionary *shopDic = [[NSMutableDictionary alloc] init];
            shopDic[@"sellerShopName"] = hongbao.shop.name;
            shopDic[@"id"] = hongbao.shop.shopId;
            shopDic[@"totalPrice"] = @(hongbao.price*hongbao.buyNum.integerValue);
            NSString *imgUrl = hongbao.img;
            if ([NSStrUtil isEmptyOrNull:imgUrl]) {
                imgUrl = @"";
            }
            NSDictionary *dictionary = @{@"id":hongbao.hongbaoId,
                                         @"name":hongbao.name,
                                         @"price" :@(hongbao.price),
                                         @"title":hongbao.title,
                                         @"img":imgUrl,
                                         @"cost":@(hongbao.cost),
                                         @"num":hongbao.buyNum};
            shopDic[@"shopBuyHongbaos"] = @[dictionary];
            [orders addObject:shopDic];
        }
    }
    NSDictionary *orderDic = @{@"data":@{@"totalPage":@1,
                                         @"records":orders}};
    return orderDic;
}
- (void)cleanOrder
{
     for (YTUsrHongBao *hongbao in self.hbArray) {
         hongbao.buyNum = [NSNumber numberWithInteger:0];
     }
    [self.hbArray removeAllObjects];
}
@end
