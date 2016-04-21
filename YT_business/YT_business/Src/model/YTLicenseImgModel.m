//
//  YTLicenseImgModel.m
//  YT_business
//
//  Created by chun.chen on 15/9/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTLicenseImgModel.h"

@implementation YTLicenseImg

@end

@implementation YTLicenseImgModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"licenseImg":@"data"};
}
@end
