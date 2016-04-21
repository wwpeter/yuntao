//
//  CreateHbViewController.h
//  YT_business
//
//  Created by chun.chen on 15/6/5.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "XLFormViewController.h"

typedef void (^createHbBlock)();


@interface CreateHbViewController : XLFormViewController
@property (nonatomic,copy) createHbBlock successBlock;
@end
