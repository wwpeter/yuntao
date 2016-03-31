
#import "UserInfomationModel.h"
#import "NSDictionary+SafeAccess.h"
#import "SDWebImageManager.h"

@implementation UserInfomationModel

- (instancetype)initWithUserDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        NSLog(@"dictionary is %@",dictionary);
        self.uid = dictionary[@"id"];
        NSAssert(dictionary[@"id"], @"uid can't be nil");
        self.userAvatar = [dictionary stringForKey:@"avatar"];
        self.userMobile = [dictionary stringForKey:@"mobile"];
        self.userName = [dictionary stringForKey:@"userName"];
        self.payPwd = [dictionary stringForKey:@"payPwd"];
        self.vipShopId = [dictionary stringForKey:@"vipShopId"];
    }
    return self;
}
- (void)saveUserDefaults
{
    NSUserDefaults* userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setObject:self.uid forKey:iYCUserIdKey];
    [userInfo setObject:self.userAvatar forKey:iYCUserAvatarKey];
    [userInfo setObject:self.userMobile forKey:iYCUserMobileKey];
    [userInfo setObject:self.userName forKey:iYCUserNameKey];
    [userInfo setObject:self.payPwd forKey:iYCUserPayPwdKey];
    [userInfo setObject:self.vipShopId forKey:iYCUserVipShopIdKey];
    [userInfo setObject:[NSDate date] forKey:iYCUserUpdateDateKey];
    [userInfo synchronize];
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.userAvatar]
                                                        options:0
                                                       progress:nil
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (data && finished)
         {
             [userInfo setObject:data forKey:iYCUserImageKey];
             [userInfo synchronize];
         }
     }];
}
+ (void)removerUserDefaults
{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo removeObjectForKey:iYCUserIdKey];
    [userInfo removeObjectForKey:iYCUserAvatarKey];
    [userInfo removeObjectForKey:iYCUserMobileKey];
    [userInfo removeObjectForKey:iYCUserNameKey];
    [userInfo removeObjectForKey:iYCUserUpdateDateKey];
    [userInfo removeObjectForKey:iYCUserImageKey];
    [userInfo removeObjectForKey:iYCUserPayPwdKey];
    [userInfo removeObjectForKey:iYCUserVipShopIdKey];
    [userInfo synchronize];
}

@end
