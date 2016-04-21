//
//  DrainageTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/6/8.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTDrainage;

@interface DrainageTableCell : UITableViewCell

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *storeImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *costLabel;
@property (strong, nonatomic) UILabel *statusLabel;

- (void)configDrainageCellWithModel:(YTDrainage *)drainage;

@end
