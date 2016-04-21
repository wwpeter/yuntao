//
//  PromotionHbNumberView.h
//  YT_business
//
//  Created by chun.chen on 15/6/11.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTPromotionHongbao;

@interface PromotionHbNumberView : UIView

@property (strong, nonatomic)UILabel *consumeLabel;
@property (strong, nonatomic)UILabel *provideLabel;
@property (strong, nonatomic)UILabel *thanLabel;

@property (strong, nonatomic)UILabel *consumeBottomLabel;
@property (strong, nonatomic)UILabel *provideBottomLabel;
@property (strong, nonatomic)UILabel *thanBottomLabel;


- (void)configPromotionHbNumberViewWithModel:(YTPromotionHongbao *)promotionHongbao;

@end
