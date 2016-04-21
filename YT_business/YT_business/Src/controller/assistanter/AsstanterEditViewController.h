//
//  AsstanterEditViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "XLFormViewController.h"
@protocol AsstanterEditViewControllerDelegate;
@class YTAssistanter;
@interface AsstanterEditViewController : XLFormViewController

@property (strong, nonatomic)YTAssistanter *assistanter;
@property (weak, nonatomic) id<AsstanterEditViewControllerDelegate> delegate;
@end

@protocol AsstanterEditViewControllerDelegate <NSObject>
@required
- (void)assistanterEditSuccess:(AsstanterEditViewController *)viewController;

@end