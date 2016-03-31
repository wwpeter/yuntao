//
//  CSearchStoreViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/8/27.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SearchResultModule) {
    // 搜索商户
    SearchResultModuleStore,
    // 搜索红包
    SearchResultModuleHb
};

@interface CSearchStoreViewController : UIViewController
@property (nonatomic, assign)SearchResultModule searchResultModule;
@end
