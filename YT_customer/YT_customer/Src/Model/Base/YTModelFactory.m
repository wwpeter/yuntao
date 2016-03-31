#import "YTModelFactory.h"
#import "YCApi.h"
#import "YTCreateUserAuthModel.h"
#import "YTAuthResultModel.h"
#import "YTResultHbModel.h"
#import "YTResultHbDetailModel.h"
#import "YTActivityModel.h"
#import "YTNoticeModel.h"
#import "YTXjswHbListModel.h"
#import "YTPublishListModel.h"
#import "YTOpenPsqHbModel.h"
#import "YTPsqptHbListModel.h"
#import "YTAccountModel.h"
#import "YTAccountDetailModel.h"
#import "YTBankModel.h"
#import "UserInfomationModel.h"

@implementation YTModelFactory
+ (YTBaseModel*)modelWithURL:(NSString*)url responseJson:(NSDictionary*)jsonDict
{
    JSONModelError* initError;
    if ([url isEqualToString:YC_Request_SetPayPasswd]) {
        UserInfomationModel* userInfoModel = [[UserInfomationModel alloc] initWithUserDictionary:jsonDict[@"data"]];
        [userInfoModel saveUserDefaults];
    }
    else if ([url isEqualToString:YC_Request_CreateUserAuthCode]) {
        return [[YTCreateUserAuthModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_UserAuthCodeResult]) {
        return [[YTAuthResultModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_QueryHongbaoList]) {
        return [[YTResultHbModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_HongbaoDetail]) {
        return [[YTResultHbDetailModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_Activity]) {
        return [[YTActivityModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_MessageList]) {
        return [[YTNoticeModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_GetXjswHbList]) {
        return [[YTXjswHbListModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_GetPublishList]) {
        return [[YTPublishListModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_ChangeHbStatus]) {
        return [[YTOpenPsqHbModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_GetPsqptHbListByPublishId]) {
        return [[YTPsqptHbListModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_QueryMemberAcount]) {
        return [[YTAccountModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_SaveBank]) {
        return [[YTSaveBank alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_MyBankList]) {
        return [[YTBankModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    else if ([url isEqualToString:YC_Request_MemberBillDetailList]) {
        return [[YTAccountDetailModel alloc] initWithDictionary:jsonDict error:&initError];
    }
    return [[YTBaseModel alloc] initWithDictionary:jsonDict error:&initError];
}
@end
