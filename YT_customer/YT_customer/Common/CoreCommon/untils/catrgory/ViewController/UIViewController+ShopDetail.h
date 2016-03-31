//
//  UIViewController+ShopDetail.h
//  YT_customer
//
//  Created by chun.chen on 15/10/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ShopDetail)
- (void)checkUserDidRealyLoginSuccess:(void (^)(BOOL isLogin))success
                              failure:(void (^)(NSString* errorMessage))failure;
- (void)showShopDetailWithShopId:(NSNumber *)shopId isPromotion:(BOOL)isPromotion;
@end
