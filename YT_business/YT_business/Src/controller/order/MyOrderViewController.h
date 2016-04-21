//
//  MyOrderViewController.h
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "ViewPagerController.h"
#import "UIBarButtonItem+Addition.h"

@interface MyOrderViewController : ViewPagerController
typedef NS_ENUM(NSInteger,ShowView) {
    LeftView,
    RightView
    
};
@property (assign,nonatomic) ShowView showView;






@end
