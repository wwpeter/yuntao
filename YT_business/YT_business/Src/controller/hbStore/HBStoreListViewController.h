//
//  HBStoreListViewController.h
//  YT_business
//
//  Created by chun.chen on 15/6/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"

@protocol HBStoreListViewControllerDelegate;

typedef NS_ENUM(NSInteger, HBStoreViewControllerType) {
    HBStoreViewControllerTypeRecomm,
    HBStoreViewControllerTypeNearby
};

@interface HBStoreListViewController : YTBaseViewController

@property (assign, nonatomic) HBStoreViewControllerType controllerType;

@property (weak, nonatomic) id<HBStoreListViewControllerDelegate> delegate;

- (instancetype)initWithStoreViewControllerType:(HBStoreViewControllerType )controllerType;

@end

@protocol HBStoreListViewControllerDelegate <NSObject>
@required
- (void)hbStoreListViewControllerDidChangeStoreHbs:(HBStoreListViewController *)viewController;
@end