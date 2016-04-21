//
//  CSelectBankViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/20.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"
@protocol CSelectBankViewControllerDelegate;
@interface CSelectBankViewController : YTBaseViewController

@property (nonatomic, copy)NSString *selectBankName;
@property (weak, nonatomic) id<CSelectBankViewControllerDelegate> delegate;
@end

@protocol CSelectBankViewControllerDelegate <NSObject>

@required
- (void)selectBankViewController:(CSelectBankViewController *)controller disSelectBankName:(NSString *)bankName;
@end