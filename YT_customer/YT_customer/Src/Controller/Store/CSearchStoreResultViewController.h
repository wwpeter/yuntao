//
//  CSearchStoreResultViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/8/27.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSearchStoreViewController.h"

@interface CSearchStoreResultViewController : UITableViewController

@property (nonatomic, assign)SearchResultModule searchResultModule;
@property (nonatomic, copy)NSString *keyword;
@end
