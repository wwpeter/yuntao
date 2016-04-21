//
//  CHSearchResponseView.h
//  YT_business
//
//  Created by chun.chen on 15/6/7.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHSearchResponseViewDelegate;


@interface CHSearchResponseView : UIView<UITableViewDataSource,UITableViewDelegate>

// 选择商户
@property (strong, nonatomic) UITableView *tableView;
// 数据
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSString *keyword;
@property (weak, nonatomic) id<CHSearchResponseViewDelegate> delegate;

@end

@protocol CHSearchResponseViewDelegate <NSObject>
@required
- (void)searchResponseViewDidSignTap:(CHSearchResponseView *)view;
@optional
- (void)searchResponseView:(CHSearchResponseView *)view didScroll:(UIScrollView *)scrollView;
- (void)searchResponseView:(CHSearchResponseView *)view didSelectStore:(YTShop *)shop;
@end