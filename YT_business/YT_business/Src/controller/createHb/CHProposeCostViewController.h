//
//  CHProposeCostViewController.h
//  YT_business
//
//  Created by chun.chen on 15/6/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHProposeCostControllerDelegate;

@interface CHProposeCostViewController : UIViewController

@property (weak, nonatomic) id<CHProposeCostControllerDelegate> delegate;

@end

@protocol CHProposeCostControllerDelegate <NSObject>

@required
- (void)proposeCostController:(CHProposeCostViewController *)controller inputCost:(NSString *)cost;
@end