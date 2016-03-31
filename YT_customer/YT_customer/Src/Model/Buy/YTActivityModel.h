//
//  YTActivityModel.h
//  YT_customer
//
//  Created by chun.chen on 15/9/29.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseModel.h"
@protocol YTActivity
@end
@interface YTActivity : YTBaseModel
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *activityId;
@end

@interface YTActivityModel : YTBaseModel
@property (nonatomic,strong) NSArray<YTActivity> *activites;
@end
