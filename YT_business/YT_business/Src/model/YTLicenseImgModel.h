//
//  YTLicenseImgModel.h
//  YT_business
//
//  Created by chun.chen on 15/9/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTLicenseImg : YTBaseModel
@property (nonatomic,copy) NSString *url;
@end

@interface YTLicenseImgModel : YTBaseModel
@property (nonatomic,strong) YTLicenseImg *licenseImg;
@end
