#import "UIViewController+ShopDetail.h"
#import "UIViewController+Helper.h"
#import "YTNetworkMange.h"
#import "UserLoginHeloper.h"
#import "ShopDetailViewController.h"
#import <objc/runtime.h>
#import "MBProgressHUD+Add.h"

static const void* ShopIdKey = &ShopIdKey;
static const void* ShopPromotionKey = &ShopPromotionKey;

@implementation UIViewController (ShopDetail)

- (NSNumber*)shopId
{
    return objc_getAssociatedObject(self, ShopIdKey);
}

- (void)setShopId:(NSNumber*)shopId
{
    objc_setAssociatedObject(self, ShopIdKey, shopId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)shopPromotion
{
    return [objc_getAssociatedObject(self, ShopPromotionKey) boolValue];
}

- (void)setShopPromotion:(BOOL)promotion
{
    objc_setAssociatedObject(self, ShopPromotionKey, @(promotion), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)showShopDetailWithShopId:(NSNumber *)shopId isPromotion:(BOOL)isPromotion
{
    [self setShopId:shopId];
    [self setShopPromotion:isPromotion];
    if ([UserLoginHeloper sharedMange].realyLogin) {
        ShopDetailViewController* shopDetailVC = [[ShopDetailViewController alloc] initWithShopId:shopId];
        shopDetailVC.isPromotion = isPromotion;
        shopDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopDetailVC animated:YES];
    }
    else {
        __weak __typeof(self) weakSelf = self;
        [self checkUserDidRealyLoginSuccess:^(BOOL isLogin) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (isLogin) {
                [strongSelf showShopDetailWithShopId:[strongSelf shopId] isPromotion:[strongSelf shopPromotion]];
            }
        } failure:^(NSString* errorMessage){

        }];
    }
}
- (void)checkUserDidRealyLoginSuccess:(void (^)(BOOL isLogin))success
                              failure:(void (^)(NSString* errorMessage))failure
{
    NSDictionary* parameters = @{};
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_UserIsLogin
        parameters:parameters
        success:^(id responseData) {
            BOOL isLogin = [responseData[@"data"] boolValue];
            [UserLoginHeloper sharedMange].realyLogin = isLogin;
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!isLogin) {
                [strongSelf userLogin];
            }
            if (success) {
                success(isLogin);
            }
        }
        failure:^(NSString* errorMessage) {
            [MBProgressHUD showMessag:errorMessage toView:self.view];
        }];
}
@end
