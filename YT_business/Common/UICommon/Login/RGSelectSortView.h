//
//  RGSelectSortView.h
//  YT_business
//
//  Created by chun.chen on 15/6/4.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^hasSelectedCategoryBlock)(YTCategory *catgory);

@class YTCategoryModel;
@interface RGSelectSortView : UIView
@property (nonatomic,strong) YTCategoryModel *categoryModel;
@property (nonatomic,copy) hasSelectedCategoryBlock selectedCategoryBlock;

- (void)showSelectSortView;
- (void)hideSelectSortView;
@end
