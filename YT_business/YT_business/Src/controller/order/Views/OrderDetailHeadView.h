//
//  OrderDetailHeadView.h
//  YT_business
//
//  Created by chun.chen on 16/1/11.
//  Copyright © 2016年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTOrder;
@interface OrderDetailHeadView : UIView
@property (nonatomic, strong)UIImageView *statusImageView;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UILabel *amountLabel;
@property (nonatomic, strong)UILabel *payLabel;

- (void)configDetailWithModel:(YTOrder *)order;
@end
