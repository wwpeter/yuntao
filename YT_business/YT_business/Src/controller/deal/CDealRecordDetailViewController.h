//
//  CDealRecordDetailViewController.h
//  YT_business
//
//  Created by chun.chen on 15/6/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTBaseViewController.h"

@class YTTrade;

typedef void (^RecordDetailRefundBlock)();


@interface CDealRecordDetailViewController : YTBaseViewController
@property (nonatomic,strong) YTTrade *trade;
@property (nonatomic,copy) RecordDetailRefundBlock refundBlock;
@end
