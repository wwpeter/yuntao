//
//  YTRegisterAddressSelViewController.h
//  YT_business
//
//  Created by yandi on 15/6/23.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class AMapPOI;

@protocol YTRegisterAddressSelViewControllerDelegate;
@interface YTRegisterAddressSelViewController : UIViewController

@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;
@property (weak, nonatomic) id<YTRegisterAddressSelViewControllerDelegate> delegate;

@end


@protocol YTRegisterAddressSelViewControllerDelegate <NSObject>
@optional
- (void)registerAddressSelViewController:(YTRegisterAddressSelViewController *)viewController didSelectPoi:(AMapPOI *)mapPoi;
@end