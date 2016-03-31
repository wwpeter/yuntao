
#import "StoreSortMange.h"
#import "YTNetworkMange.h"
#import "NSJSONSerialization+file.h"
#import "YTCityZoneMange.h"

@implementation StoreSortMange

+ (id)storeSortAreaWithProvince:(NSString*)province city:(NSString*)city;
{
    NSArray* areas;
//    NSError* error;
//    NSString* regionpath = [[NSBundle mainBundle] pathForResource:@"yc_city" ofType:@"json"];
//    NSData* cityData = [[NSData alloc] initWithContentsOfFile:regionpath];
//    NSArray* citys = [NSJSONSerialization JSONObjectWithData:cityData options:kNilOptions error:&error];
    NSArray* chinaProvinces = [YTCityZoneMange allProvinces];
    NSRange range1 = [city rangeOfString:@"香港"];
    NSRange range2 = [city rangeOfString:@"澳门"];
    if (range1.length > 0) {
        // 数据源无香港澳门
        //        return chinaProvinces[chinaProvinces.count - 1];
    }
    if (range2.length > 0) {
        //        return [chinaProvinces lastObject];
    }
    for (NSDictionary* items in chinaProvinces) {
        NSString* pName = items[@"name"];
        if ([pName hasPrefix:province]) {
            NSArray* provinceCitys = items[@"next"];
            for (NSDictionary* dic in provinceCitys) {
                NSString* aCity = dic[@"name"];
                if ([province isEqualToString:city]) {
                    if ([aCity isEqualToString:@"市辖区"]) {
                        return dic[@"next"];
                    }
                }
                if ([aCity isEqualToString:city]) {
                    return dic[@"next"];
                }
            }
        }
        else {
            if ([pName isEqualToString:city]) {
                return [items[@"next"] firstObject][@"next"];
            }
        }
    }
    if (areas.count == 0) {
        // 没有数据返回默认杭州数据
        return [self storeSortAreaWithProvince:@"浙江省" city:@"杭州市"];
    } else {
        return areas;
    }
}
+ (void)updateStoreSortCat
{
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_Shopcat
                                                parameters:@{}
        success:^(id responseData) {
            id data = responseData[@"data"];
            if (data) {
                [NSJSONSerialization save:data fileName:kYCStoreCatDataFileName];
            }
        }
        failure:^(NSString* errorMessage){

        }];
}

@end
