//
//  ShopDetailHeadView.h
//  YT_customer
//
//  Created by chun.chen on 15/8/1.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopDetailAddressView;
@class ShopDetailSignView;
@class ShopDetailModel;

@protocol ShopDetailHeadViewDelegate;

@interface ShopDetailHeadView : UIView

@property (strong, nonatomic) UIImageView* backImageView;
@property (strong, nonatomic) UIImageView* rankImageView;

@property (strong, nonatomic) UIButton* hjButton;

@property (strong, nonatomic) UILabel* shopNameLabel;
@property (strong, nonatomic) UILabel* costLabel;
@property (strong, nonatomic) UILabel* discountLabel;
@property (strong, nonatomic) UILabel* zheLabel;
@property (strong, nonatomic) UILabel* subtractTimeLabel;

@property (strong, nonatomic) ShopDetailAddressView* addressView;
@property (strong, nonatomic) ShopDetailSignView* timeView;
@property (strong, nonatomic) ShopDetailSignView* parkView;
@property (weak, nonatomic) id<ShopDetailHeadViewDelegate> delegate;

- (instancetype)initWithShopDetailModel:(ShopDetailModel*)shopModel Frame:(CGRect)frame;
- (void)configShopDetailHeadViewWithModel:(ShopDetailModel*)shopModel;
@end

@interface ShopDetailSignView : UIView
@property (strong, nonatomic) UIImageView* iconImageView;
@property (strong, nonatomic) UILabel* messageLabel;
@property (assign, nonatomic) CGFloat leftMargin;
@end

@protocol ShopDetailHeadViewDelegate <NSObject>
@optional
- (void)shopDetailHeadView:(ShopDetailHeadView*)headView didClickedIndex:(NSInteger)index;

@end