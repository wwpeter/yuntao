//
//  RGSelectTimeView.h
//  YT_business
//
//  Created by chun.chen on 15/6/4.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSelectTimeView : UIView

@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

- (void)showSelectTimeView;
- (void)hideSelectTimeView;

@end
