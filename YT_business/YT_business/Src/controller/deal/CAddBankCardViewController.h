//
//  CAddBankCardViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"
@protocol CAddBankCardViewControllerrDelegate;
@class YTBank;
@interface CAddBankCardViewController : YTBaseViewController

@property (weak, nonatomic) id<CAddBankCardViewControllerrDelegate> delegate;

@end


@protocol CAddBankCardViewControllerrDelegate <NSObject>

@required
- (void)addBankCardViewController:(CAddBankCardViewController *)controller success:(YTBank *)bank;
@end
