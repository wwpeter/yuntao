//
//  LeftSideDrawerHelper.h
//  YT_business
//
//  Created by chun.chen on 15/7/1.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTNavigationController.h"

@interface LeftSideDrawerHelper : NSObject

@property (nonatomic, strong) NSMutableArray *viewControllers;

+ (LeftSideDrawerHelper*)sideDrawerHelper;
- (void)businessLeftViewContrllers;
- (void)replaceNavigationControllerWithIndex:(NSInteger)index;
@end
