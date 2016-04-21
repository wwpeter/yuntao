//
//  DealRecordDetailUserHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/11/13.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealRecordDetailUserHeadView : UIView
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *name;
@end
