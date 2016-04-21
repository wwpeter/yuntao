//
//  UIScrollView+YTPull.h
//  YT_business
//
//  Created by yandi on 15/6/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"

@interface UIScrollView (YTPull)
- (void)addYTPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addYTInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
@end
