//
//  YTAddressSearchViewController.h
//  YT_business
//
//  Created by chun.chen on 15/8/8.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMapPOI;
@protocol YTAddressSearchViewControllerDelegate;

@interface YTAddressSearchViewController : UIViewController

@property (weak, nonatomic) id<YTAddressSearchViewControllerDelegate> delegate;

@end

@protocol YTAddressSearchViewControllerDelegate <NSObject>

@optional
- (void)addressSearchViewController:(YTAddressSearchViewController *)viewController didSelectPoi:(AMapPOI *)mapPoi;

@end
