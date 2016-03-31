//
//  CStoreReceiveSelectListViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CStoreReceiveSelectControllerDelegate;

@interface CStoreReceiveSelectListViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *selectHbModels;
@property (weak, nonatomic) id<CStoreReceiveSelectControllerDelegate> delegate;

- (instancetype)initWithSelectHbModels:(NSArray *)models;


@end

@protocol CStoreReceiveSelectControllerDelegate <NSObject>
@required
- (void)hbSelectListViewController:(CStoreReceiveSelectListViewController *)viewController didChangeStoreHbModels:(NSArray *)models;

@end