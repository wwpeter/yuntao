//
//  DistributePayHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/12/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistributePayHeadView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, copy)NSString *detailText;
@property (nonatomic, copy)NSAttributedString *detailAttributedString;
@end
