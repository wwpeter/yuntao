//
//  PromotionHbSignBuyView.h
//  YT_business
//
//  Created by chun.chen on 15/6/12.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PromotionHbSignBuyViewDelegate;
@interface PromotionHbSignBuyView : UIView

@property (strong, nonatomic) UILabel *costLabel;

@property (strong, nonatomic) UITextField *textFiled;
@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *minusButton;
@property (strong, nonatomic) UILabel *sameLabel;
@property (strong, nonatomic) UIButton *askButton;
@property (assign, nonatomic) BOOL disableField;
@property (assign, nonatomic) BOOL displaySameOccupation
;
@property (weak, nonatomic) id<PromotionHbSignBuyViewDelegate> delegate;

@end
@protocol PromotionHbSignBuyViewDelegate <NSObject>
@optional
- (void)promotionHbSignBuyView:(PromotionHbSignBuyView *)view textFieldDidEndEditing:(UITextField *)textField;
- (void)promotionHbSignBuyView:(PromotionHbSignBuyView *)view textFieldShouldBeginEditing:(UITextField *)textField;
- (void)promotionHbSignBuyViewDidAddHb:(PromotionHbSignBuyView *)view;
- (void)promotionHbSignBuyViewDidMinushb:(PromotionHbSignBuyView *)view;
- (void)promotionHbSignBuyViewAskAction:(PromotionHbSignBuyView *)view;
@end
