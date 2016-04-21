//
//  HbSelectListViewController.h
//  YT_business
//
//  Created by chun.chen on 15/6/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HbSelectListViewControllerDelegate;

@interface HbSelectListViewController : UITableViewController

@property (weak, nonatomic) id<HbSelectListViewControllerDelegate> delegate;
@end

@protocol HbSelectListViewControllerDelegate <NSObject>
@required
- (void)hbSelectListViewControllerDidChangeStoreHbs:(HbSelectListViewController *)viewController;

@end