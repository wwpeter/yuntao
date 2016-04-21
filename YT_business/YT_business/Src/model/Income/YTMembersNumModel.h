//
//  YTMembersNumModel.h
//  YT_business
//
//  Created by chun.chen on 15/12/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTMembersNum : YTBaseModel
@property (nonatomic, copy)NSString *membersNum;
@end

@interface YTMembersNumModel : YTBaseModel
@property (nonatomic, strong) YTMembersNum *members;
@end
