//
//  PromotionTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/6/11.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTPromotionHongbao;

@interface PromotionTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

/**
 *  发放
 */
@property (strong, nonatomic) UILabel *provideLabel;
/**
 *  剩余
 */
@property (strong, nonatomic) UILabel *thanLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UIImageView *hbImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *describeLabel;


- (void)configPromotionTableIntroModel:(YTPromotionHongbao *)promotionHongbao;

@end
