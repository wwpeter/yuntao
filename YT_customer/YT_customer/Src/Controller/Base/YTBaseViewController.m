#import "YTBaseViewController.h"
#import "NSStrUtil.h"
#import "MBProgressHUD+Add.h"
#import "YTNetworkMange.h"
#import "YTModelFactory.h"

@interface YTBaseViewController ()

@end

@implementation YTBaseViewController
#pragma mark - Life cycle
- (id)init
{
    if ((self = [super init])) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xEEEEEE);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -actionFetchRequest
- (void)actionFetchRequest:(YTRequestModel *)request result:(YTBaseModel *)parserObject
              errorMessage:(NSString *)errorMessage
{
    
}
#pragma mark -doLogin
- (void)authFromLoginWithReqURL:(NSString*)reqURL
{
    
}
#pragma mark -cancelLoginEvent
- (void)cancelLoginEvent {
    
}

//
- (void)setRequestURL:(NSString*)url
{
    _requestURL = url;
    BOOL showLoading = [[self.requestParas objectForKey:loadingKey] boolValue];
    BOOL isLoadingMore = [[self.requestParas objectForKey:isLoadingMoreKey] boolValue];
    if (showLoading) {
        [MBProgressHUD showMessag:@"请稍后..." toView:self.view];
    }
    NSMutableDictionary* transferParas = [NSMutableDictionary dictionaryWithDictionary:[self.requestParas mutableCopy]];
    [transferParas removeObjectForKey:loadingKey];
    [transferParas removeObjectForKey:isLoadingMoreKey];
    
    YTRequestModel* requestModel = [[YTRequestModel alloc] initWithUrl:url isLoadingMore:isLoadingMore];
    __weak typeof(self) wSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:url parameters:transferParas success:^(id responseData) {
        if (showLoading) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            YTBaseModel* responseModel = [YTModelFactory modelWithURL:url
                                                 responseJson:responseData];
            responseModel.isLoadingMore = isLoadingMore;
            if ([responseModel.resultCode isEqualToString:@"NOT_LOGIN"]) {
                [wSelf authFromLoginWithReqURL:url];
            } else {
                // callback
                [wSelf actionFetchRequest:requestModel result:responseModel errorMessage:nil];
            }
        }else {
            [wSelf actionFetchRequest:requestModel result:nil errorMessage:@""];
        }
    } failure:^(NSString *errorMessage) {
        if (showLoading) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        [wSelf actionFetchRequest:requestModel result:nil errorMessage:errorMessage];
    }];
}
@end
