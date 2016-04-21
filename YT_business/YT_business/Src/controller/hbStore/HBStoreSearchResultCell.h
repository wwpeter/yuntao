//
//  HBStoreSearchResultCell.h
//  YT_business
//
//  Created by chun.chen on 15/9/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTUsrHongBao;

@interface HBStoreSearchResultCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *hbImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *describeLabel;
@property (strong, nonatomic) UILabel *costLabel;

- (void)configHbStoreSearchResultModel:(YTUsrHongBao *)hongbao;

@end
