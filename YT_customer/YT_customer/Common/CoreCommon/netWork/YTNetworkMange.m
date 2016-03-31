#import "YTNetworkMange.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "UserLoginHeloper.h"
#import "DeviceUtil.h"

@implementation YTNetworkMange

+ (YTNetworkMange*)sharedMange
{
    static YTNetworkMange* sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [YTNetworkMange manager];
    });
    return sharedManager;
}
#pragma mark -override initWithBaseURL
- (instancetype)initWithBaseURL:(NSURL*)url
{
    if (self = [super initWithBaseURL:url]) {
        self.requestSerializer.timeoutInterval = 20;
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/javascript", @"text/json", @"text/html", @"text/plain", nil];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        //     self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        [self.requestSerializer setValue:[DeviceUtil deviceUserAgent] forHTTPHeaderField:@"User-Agent"];
        [self.requestSerializer setValue:@"hongbaoApp" forHTTPHeaderField:@"reqFrom"];
    }
    return self;
}
- (void)getInfoDataWithServiceUrl:(NSString*)urlString
                       parameters:(NSDictionary*)parameters
                          success:(void (^)(id responseData))success
                          failure:(void (^)(NSString* errorMessage))failure
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    NSString *httpUrl = [NSString stringWithFormat:@"%@%@",YC_WSSERVICE_HTTP,urlString];
    [self GET:httpUrl
      parameters:parameters
         success:^(AFHTTPRequestOperation* operation, id responseObject) {
             NSLog(@"---------------------****GET %@ Success****-----------------------", httpUrl);
             //        NSLog(@"Get operation is :%@",operation);
             
             NSInteger responseCode = [responseObject[@"code"] integerValue];
             _errorCode = responseCode;
            [YCApi saveCookiesWithUrlString:httpUrl];
             if (responseCode == 200) {
                 if (success) {
                     success(responseObject);
                 }
             }
             else {
                 NSLog(@"***********************Get %@ fail = %@ *************************", httpUrl, @(responseCode));
                 NSString* errorStr = responseObject[@"message"];
                 NSLog(@"GET ERROR is :%@", errorStr);
                 if (failure) {
                     failure(errorStr);
                 }
                 NSLog(@"******************************fail END************************************************");
             }
             
         }
         failure:^(AFHTTPRequestOperation* operation, NSError* error) {
             NSLog(@"---------------------****ERROR****-----------------------");
             NSLog(@"operation is :%@", operation);
             NSLog(@"error is :%@", error);
             _errorCode = [error code];
            [YCApi saveCookiesWithUrlString:httpUrl];
             if (failure) {
                 failure(@"服务连接失败");
             }
             NSLog(@"******************************GET ERROR END************************************************");
         }];
}
- (void)postResultWithServiceUrl:(NSString*)urlString
                      parameters:(NSDictionary*)parameters
                         success:(void (^)(id responseData))success
                         failure:(void (^)(NSString* errorMessage))failure
{
    NSString *httpUrl = [NSString stringWithFormat:@"%@%@",YC_WSSERVICE_HTTP,urlString];
    httpUrl = [httpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        NSLog(@"httpUrl = %@ ",httpUrl);
        NSLog(@"post parameters:%@", parameters);
    __weak __typeof(self)weakSelf = self;
    [self POST:httpUrl
          parameters:parameters
             success:^(AFHTTPRequestOperation* operation, id responseObject) {
#ifdef DEBUG
// NSLog(@"post responseObject:%@", responseObject);
#endif
                [YCApi saveCookiesWithUrlString:httpUrl];
                 NSInteger responseCode = [responseObject[@"success"] integerValue];
                 _errorCode = responseCode;
                 if (responseCode == 1) {
                        NSLog(@"---------------------****POST %@ Success****-----------------------", urlString);
                     if (success) {
                         success(responseObject);
                     }
                 }
                 else {
                     NSLog(@"*********************** %@ fail \n %@ *************************", urlString, responseObject[@"message"]);
                     NSString *resultCode = responseObject[@"resultCode"];
                     if ([resultCode isEqualToString:@"NOT_LOGIN"]) {
                         [weakSelf userAfreshLogin];
                     }
                     NSString* errorStr = responseObject[@"message"];
                     if (failure) {
                         failure(errorStr);
                     }
                     NSLog(@"******************************fail END************************************************");
                 }
             }
             failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                 NSLog(@"***********************POST error *************************");
                 NSLog(@"POST ERROR:operation :%@", operation);
                 NSLog(@"POST ERROR: :%@", error);
                 _errorCode = [error code];
                [YCApi saveCookiesWithUrlString:httpUrl];
                 if (failure) {
                     failure(@"连接失败");
                 }
                 NSLog(@"******************************POST ERROR END************************************************");
             }];
}
- (void)postResultWithServiceUrl:(NSString *)urlString
                      parameters:(NSDictionary *)parameters
                     singleImage:(UIImage *)image
                       imageName:(NSString *)imageName
                         success:(void (^) (id responseData))success
                         failure:(void (^) (NSString *errorMessage))failure
{
    NSString *httpUrl = [NSString stringWithFormat:@"%@%@",YC_WSSERVICE_HTTP,urlString];
    httpUrl = [httpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [self POST:httpUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (image) {
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",imageName];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
            NSLog(@"date length : %@",@(imageData.length));
            [formData appendPartWithFileData :imageData name:imageName fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSInteger responseCode = [responseObject[@"success"] integerValue];
        _errorCode = responseCode;
        [YCApi saveCookiesWithUrlString:httpUrl];
        if (responseCode == 1) {
            NSLog(@"---------------------****POST Image  %@ Success****-----------------------", urlString);
            if (success) {
                success(responseObject);
            }
        }
        else {
            NSLog(@"*********************** %@ fail %@ *************************", urlString, @(responseCode));
            NSString* errorStr = responseObject[@"message"];
            NSLog(@"post errorStr:%@", errorStr);
            if (failure) {
                failure(errorStr);
            }
            NSLog(@"******************************fail END************************************************");
        }
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"***********************POST Image error *************************");
        NSLog(@"POST Image  ERROR:operation :%@", operation);
        NSLog(@"POST Image  ERROR: :%@", error);
        _errorCode = [error code];
        [YCApi saveCookiesWithUrlString:httpUrl];
        if (failure) {
            failure(@"服务连接失败");
        }
        NSLog(@"******************************POST Image  ERROR END************************************************");
    }];
}
- (void)postFromWithImages:(NSArray*)images
                   success:(void (^)(id responseData))success
                   failure:(void (^)(NSString* errorMessage))failure
{
    
}
- (void)userAfreshLogin
{
    [[UserLoginHeloper sharedMange] userLoginSuccess:^{
        
    } failure:^{
        
    }];
}
@end
