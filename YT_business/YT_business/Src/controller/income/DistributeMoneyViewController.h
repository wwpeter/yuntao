//
//  DistributeMoneyViewController.h
//  YT_business
//
//  Created by chun.chen on 15/12/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

typedef NS_ENUM(NSInteger, DistributeMoneyHBType) {
    /**< 拼手气红包*/
    DistributeMoneyHBTypeLuck,
    /**< 普通红包*/
    DistributeMoneyHBTypeNormal
};

#import "YTBaseViewController.h"

@interface DistributeMoneyViewController : YTBaseViewController
@property (nonatomic, assign)DistributeMoneyHBType hongbaoType;
@end
