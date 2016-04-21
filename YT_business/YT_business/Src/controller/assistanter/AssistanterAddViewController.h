//
//  AssistanterAddViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "XLFormViewController.h"
@protocol AssistanterAddViewControllerDelegate;

@interface AssistanterAddViewController : XLFormViewController
@property (weak, nonatomic) id<AssistanterAddViewControllerDelegate> delegate;
@end

@protocol AssistanterAddViewControllerDelegate <NSObject>
@required
- (void)assistanterAddSuccess:(AssistanterAddViewController *)viewController;

@end