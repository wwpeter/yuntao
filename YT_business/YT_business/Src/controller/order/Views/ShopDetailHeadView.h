//
//  ShopDetailHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/7/8.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopDetailAddressView;
@class YTUpdateShopInfoModel;
@class ShopDetailSignView;

@protocol ShopDetailHeadViewDelegate;

@interface ShopDetailHeadView : UIView

@property (strong, nonatomic)UIImageView *backImageView;
@property (strong, nonatomic)UIImageView *insideImageView;
@property (strong, nonatomic)UIImageView *outsideImageView;
@property (strong, nonatomic)UIImageView *rankImageView;

@property (strong, nonatomic)UILabel *shopNameLabel;
@property (strong, nonatomic)UILabel *costLabel;
@property (strong, nonatomic)ShopDetailAddressView *addressView;
@property (strong, nonatomic)ShopDetailSignView *timeView;
@property (strong, nonatomic)ShopDetailSignView *parkView;

@property (weak, nonatomic) id<ShopDetailHeadViewDelegate> delegate;

@property (strong, nonatomic) YTUpdateShopInfoModel *shopInfoModel;

- (instancetype)initWithShopInfoModel:(YTUpdateShopInfoModel *)shopInfoModel frame:(CGRect)frame;
- (void)configShopDetailHeadViewWithModel:(YTUpdateShopInfoModel *)shopInfoModel;

@end


@interface ShopDetailSignView : UIView
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (assign, nonatomic) CGFloat leftMargin;
@end


@protocol ShopDetailHeadViewDelegate <NSObject>
@optional
- (void)shopDetailHeadView:(ShopDetailHeadView*)headView didClickedIndex:(NSInteger)index;

@end

