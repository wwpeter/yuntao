//
//  DealRecordDetailRemarkView.h
//  YT_business
//
//  Created by chun.chen on 15/11/13.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealRecordDetailRemarkView : UIView
@property (nonatomic, strong)UILabel *remarkLabel;
@property (nonatomic, copy)NSString *remark;

+ (CGFloat)remarkHeight:(NSString *)remark;
@end
