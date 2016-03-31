//
//  ZHQMyConsumeCell.h
//  YT_customer
//
//  Created by 郑海清 on 15/6/15.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHQMeConsumeModel.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Utilities.h"

@interface ZHQMyConsumeCell : UITableViewCell
@property (strong, nonatomic) UIImageView *hbImg;
@property (strong, nonatomic) UIView *backView;

@property (strong, nonatomic) UILabel *hbTitle;
@property (strong, nonatomic) UILabel *totalLableStatic;
@property (strong, nonatomic) UILabel *totalPrice;
@property (strong, nonatomic) UIImageView *arrorImg;
@property (strong, nonatomic) UIImageView *dottedLine;
@property (strong, nonatomic) UILabel *hbStatus;
@property (strong, nonatomic) UILabel *hbDate;
@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;


- (void)configConsumeCellWithModel:(ZHQMeConsumeModel *)introModel;

@end
