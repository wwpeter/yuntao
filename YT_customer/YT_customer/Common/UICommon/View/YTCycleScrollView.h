//
//  YTCycleScrollView.h
//  YT_customer
//
//  Created by chun.chen on 15/9/28.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CycleSelectBlock)(NSInteger index);

@interface YTCycleScrollView : UIView

@property (nonatomic, strong) NSArray *imageURLsGroup;
@property (nonatomic, copy) CycleSelectBlock selectBlock;

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLsGroup:(NSArray *)imageURLsGroup;

- (void)timerPause;
- (void)timerStart;

@end

@interface CyclesCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@end