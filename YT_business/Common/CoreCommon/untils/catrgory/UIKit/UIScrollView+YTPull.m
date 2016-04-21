//
//  UIScrollView+YTPull.m
//  YT_business
//
//  Created by yandi on 15/6/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "UIScrollView+YTPull.h"

@implementation UIScrollView (YTPull)
- (void)addYTPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    [self addPullToRefreshWithActionHandler:actionHandler];
}

- (void)addYTInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler {
    [self addInfiniteScrollingWithActionHandler:actionHandler];
}
@end
