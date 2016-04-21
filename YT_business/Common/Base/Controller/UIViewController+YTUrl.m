#import "UIViewController+YTUrl.h"
#import "YTHttpClient.h"
#import "MBProgressHUD+Add.h"
#import "YTLoginViewController.h"

static char* ytUrlusrInfo;

@implementation UIViewController (YTUrl)

- (void)setUsrInfo:(NSDictionary*)usrInfo
{
    objc_setAssociatedObject(self, &ytUrlusrInfo, usrInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)usrInfo
{
    return objc_getAssociatedObject(self, &ytUrlusrInfo);
}

- (void)postRequestParas:(NSDictionary*)requestParas requestURL:(NSString*)url success:(void (^)(AFHTTPRequestOperation* operation, YTBaseModel* parserObject))success
                 failure:(void (^)(NSString* errorMessage))failure;
{
    BOOL showLoading = [[requestParas objectForKey:loadingKey] boolValue];
    if (showLoading) {
        [MBProgressHUD showMessag:@"请稍后..." toView:self.view];
    }
    __weak typeof(self) wSelf = self;
    AFHTTPRequestOperation* operation = [[YTHttpClient client] requestWithURL:url
        paras:requestParas
        success:^(AFHTTPRequestOperation* operation, NSObject* parserObject) {
            if (showLoading) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            YTBaseModel* responseModel = (YTBaseModel*)parserObject;
            if ([responseModel.resultCode isEqualToString:@"NOT_LOGIN"]) {
                [wSelf actionShowLogin:url requestParas:requestParas];
            }
            else {
                // callback
                if (success) {
                    success(operation, responseModel);
                }
            }
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* requestErr) {
            if (showLoading) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:@"连接失败~" toView:self.view];
            }
            if (failure) {
                failure(@"连接失败~");
            }
        }];
    if (self.usrInfo) {
        operation.userInfo = self.usrInfo;
    }
}
- (void)actionShowLogin:(NSString*)reqUrlAfterAuth requestParas:(NSDictionary*)requestParas
{

    __weak typeof(self) wSelf = self;
    YTLoginViewController* loginVc = [[YTLoginViewController alloc] init];
    loginVc.successBlock = ^{
        if (!wSelf) {
            return;
        }
    };
    loginVc.failureBlock = ^{
        if (!wSelf) {
            return;
        }
    };
    UINavigationController* loginNav = [[UINavigationController alloc] initWithRootViewController:loginVc];
    [self.view.window.rootViewController presentViewController:loginNav animated:YES completion:NULL];
}

@end
