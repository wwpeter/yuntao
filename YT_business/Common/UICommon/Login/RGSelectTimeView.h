//
//  RGSelectTimeView.h
//  YT_business
//
//  Created by chun.chen on 15/6/4.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^setOpendaysBlock)(NSString *opendayStr);
typedef void(^setOpenTimeBlock)(BOOL isOpen,NSString *timeStr);

@interface RGSelectTimeView : UIView
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSMutableArray *days;
@property (nonatomic,copy) setOpendaysBlock opendaysBlock;
@property (nonatomic,copy) setOpenTimeBlock opentimeBlock;

- (void)showSelectTimeView;
- (void)hideSelectTimeView;

@end
