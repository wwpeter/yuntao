//
//  RegisterInfomationTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/11/25.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterInfomationTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, copy) NSString *photoText;
@property (nonatomic, strong) UIImage *photoImage;
@end
