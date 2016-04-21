//
//  CHSearchStoreView.h
//  YT_business
//
//  Created by chun.chen on 15/6/5.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHSearchStoreViewDelegate;

static const NSInteger kMaxStoreCount = 10;

@interface CHSearchStoreView : UIView <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *searchField;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) id<CHSearchStoreViewDelegate> delegate;

- (void)addShopItem:(YTShop*)shop;
- (void)addShopItems:(NSArray*)items;
- (void)removeShopItemAtIndex:(NSInteger)index;
- (void)removeShop:(YTShop*)shop;

@end

@interface StoreButton : UIButton

@property (strong, nonatomic)NSString *shopId;

@end

@protocol CHSearchStoreViewDelegate <NSObject>
@required
- (void)searchStoreView:(CHSearchStoreView *)view didRemoverItem:(StoreButton*)storeButton;
@optional
- (void)searchStoreView:(CHSearchStoreView *)view textFieldShouldBeginEditing:(UITextField *)textField;
- (void)searchStoreView:(CHSearchStoreView *)view textFieldDidBeginEditing:(UITextField *)textField;
- (void)searchStoreView:(CHSearchStoreView *)view textFieldShouldEndEditing:(UITextField *)textField;
- (void)searchStoreView:(CHSearchStoreView *)view textFieldDidEndEditing:(UITextField *)textField;
- (void)searchStoreView:(CHSearchStoreView *)view shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)searchStoreView:(CHSearchStoreView *)view textFieldShouldClear:(UITextField *)textField;
- (void)searchStoreView:(CHSearchStoreView *)view textFieldShouldReturn:(UITextField *)textField;

@end
