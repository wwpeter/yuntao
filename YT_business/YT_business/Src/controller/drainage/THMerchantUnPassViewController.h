//
//  THMerchantUnPassViewController.h
//  YT_counterman
//
//  Created by chun.chen on 15/6/21.
//  Copyright (c) 2015年 杭州赛融网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MerchantUnPassMode) {
    // 商家审核不通过
    MerchantUnPassModeHbSlodOut,
    // 红包审核不通过
    MerchantUnPassModeHb
};

@interface THMerchantUnPassViewController : UITableViewController
@property (assign, nonatomic)MerchantUnPassMode unPassMode;
@property (strong, nonatomic) NSString *unId;
@property (strong, nonatomic) NSArray *dataArray;

@end
