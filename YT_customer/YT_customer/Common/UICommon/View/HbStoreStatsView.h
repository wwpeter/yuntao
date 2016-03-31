//
//  HbStoreStatsView.h
//  YT_business
//
//  Created by chun.chen on 15/6/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HbStoreStatsViewDelegate;

@interface HbStoreStatsView : UIView
@property (strong, nonatomic) UIButton *doneButton;
@property (strong, nonatomic) NSString *badgeText;
@property (strong, nonatomic) NSString *cost;
@property (strong, nonatomic) NSString *buttonTitle;

@property (weak, nonatomic) id<HbStoreStatsViewDelegate> delegate;

@end

@protocol HbStoreStatsViewDelegate <NSObject>
@optional
- (void)hbStoreStatsView:(HbStoreStatsView *)view clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
