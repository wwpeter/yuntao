//
//  VipManageDistributeView.h
//  YT_business
//
//  Created by chun.chen on 15/12/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^VipManageDistributeViewSelectBlock)(NSInteger selectIndex);

@interface VipManageDistributeView : UIView
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, copy) VipManageDistributeViewSelectBlock selectBlock;

- (void)show;
- (void)dismiss;
@end
