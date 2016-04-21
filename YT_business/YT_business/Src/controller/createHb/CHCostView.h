//
//  CHCostView.h
//  YT_business
//
//  Created by chun.chen on 15/6/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @param selectIndex 建议售价 index=1  完成=2
 */
typedef void (^CostViewSelectBlock)(NSInteger selectIndex);

@interface CHCostView : UIView

@property (strong, nonatomic) UILabel *costLabel;
@property (strong, nonatomic) UIButton *doneButton;

@property (nonatomic, strong) CostViewSelectBlock selectBlock;

@end
