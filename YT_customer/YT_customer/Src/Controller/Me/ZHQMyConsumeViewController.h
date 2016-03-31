//
//  ZHQMyConsumeViewController.h
//  YT_customer
//
//  Created by 郑海清 on 15/6/15.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHQMeConsumeModel.h"
#import "ZHQMyConsumeCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Utilities.h"
#import "PaySuccessViewController.h"
#import "StoryBoardUtilities.h"
#import "PaySuccessModel.h"

@interface ZHQMyConsumeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *consumeTable;

@property (strong, nonatomic) NSMutableArray *consumeArr;



@end
