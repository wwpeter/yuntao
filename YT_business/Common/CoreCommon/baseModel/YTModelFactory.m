
#import "YTLoginModel.h"
#import "YTTradeModel.h"
#import "YTOrderModel.h"
#import "YTModelFactory.h"
#import "YTDrainageModel.h"
#import "YTCategoryModel.h"
#import "YTPromotionModel.h"
#import "YTRefundOrderModel.h"
#import "YTHongbaoStoreModel.h"
#import "YTDrainageDetailModel.h"
#import "YTCityMatch.h"
#import "YTQueryShopModel.h"
#import "YTUpdateShopInfoModel.h"
#import "YTPromotionSettingModel.h"
#import "YTHongbaoPayModel.h"
#import "YTNotifyModel.h"
#import "YTAssistanterModel.h"
#import "YTHongbaoDetailModel.h"
#import "YTBarPayModel.h"
#import "YTAccountModel.h"
#import "YTTradeRefundModel.h"
#import "YTBankModel.h"
#import "YTAccountDetailModel.h"
#import "YTSellHongbaoIndexModel.h"
#import "YTBuyHongbaoIndexModel.h"
#import "YTWechatPayModel.h"
#import "YTLicenseImgModel.h"
#import "YTScanUserAuthPayModel.h"
#import "YTUserAuthResultModel.h"
#import "YTVipIncomeModel.h"
#import "YTCityZoneModel.h"
#import "YTUploadPicModel.h"
#import "YTVipManageModel.h"
#import "YTChooseHbTempModel.h"
#import "YTMembersNumModel.h"
#import "YTPsqptHbListModel.h"

@implementation YTModelFactory
+ (YTBaseModel*)modelWithURL:(NSString*)url responseJson:(NSDictionary*)jsonDict
{
    if ([url isEqualToString:loginURL] ||
        [url isEqualToString:saleLoginURL] ||
        [url isEqualToString:registerURL] ||
        [url isEqualToString:updatePwdForForgetURL] ||
        [url isEqualToString:saleUpdatePwdForForgetURL] ||
        [url isEqualToString:userInfoURL] ||
        [url isEqualToString:steupPayPasswdURL]) {
        return [[YTLoginModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:shopInfoURL]) {
        return [[YTUpdateShopInfoModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:tradeURL] || [url isEqualToString:saleTradeURL]) {
        return [[YTTradeModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:accountDetailListURL]) {
        return [[YTAccountDetailModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:drainageListURL]) {
        return [[YTDrainageModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:saleHongbaoDetailURL]) {
        return [[YTDrainageDetailModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:buyedHongbaoURL] || [url isEqualToString:setBuyHongbaoStatusListURL]) {
        return [[YTPromotionModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:getPromoteSetURL]) {
        return [[YTPromotionSettingModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:recomentHongbaoURL] || [url isEqualToString:queryHongbaoListURL] || [url isEqualToString:toChooseXjswhbListURL]) {
        return [[YTHongbaoStoreModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:orderHongbaoURL]) {
        return [[YTOrderModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:refundHongbaoURL]) {
        return [[YTRefundOrderModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:getShopCategoryURL]) {
        return [[YTCategoryModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:cityMatchURL]) {
        return [[YTCityMatchModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:queryShopListURL]) {
        return [[YTQueryShopModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:buyHongbaoUseAlipayURL] || [url isEqualToString:continueAlipayURL] || [url isEqualToString:publishAlipayURL]) {
        return [[YTHongbaoPayModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:messageListURL]) {
        return [[YTNotifyModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:shopSaleListURL]) {
        return [[YTAssistanterModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:hongbaoInfoURL]) {
        return [[YTHongbaoDetailModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:bizBarPayURL] ||
        [url isEqualToString:saleBarPayURL] ||
        [url isEqualToString:weiXinBarPayURL] ||
        [url isEqualToString:saleWeiXinBarPayURL]) {
        return [[YTBarPayModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:queryAccountURL]) {
        return [[YTAccountModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:bizBarCancelPayURL] ||
        [url isEqualToString:saleCancelPayURL] ||
        [url isEqualToString:cancelWeiXinBarPayURL] ||
        [url isEqualToString:saleCancelWeiXinBarPayURL]) {
        return [[YTTradeRefundModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:bankListURL] || [url isEqualToString:myBankListURL]) {
        return [[YTBankModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:saveBankURL]) {
        return [[YTSaveBank alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:drainageHongbaoIndexURL]) {
        return [[YTSellHongbaoIndexModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:buyHongbaoIndexURL]) {
        return [[YTBuyHongbaoIndexModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:buyHongbaoUseWeiXinURL] ||
        [url isEqualToString:continueWeixinURL] ||
        [url isEqualToString:publishWeixinpayURL]) {
        return [[YTWechatPayModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:updateLicenseImgURL]) {
        return [[YTLicenseImgModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:scanUserAuthCodePayURL] ||
        [url isEqualToString:saleScanUserAuthCodePayURL]) {
        return [[YTScanUserAuthPayModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:userAuthCodeResultURL] ||
        [url isEqualToString:saleUserAuthCodeResultURL]) {
        return [[YTUserAuthResultModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:vipShopIndexURL]) {
        return [[YTVipIncomeModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:getZoneListURL]) {
        return [[YTCityZoneModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:registerUploadPicURL]) {
        return [[YTUploadPicModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:getPublishListURL]) {
        return [[YTVipManageModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:saveChooseHbTempURL]) {
        return [[YTChooseHbTempModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:getMembersNumURL]) {
        return [[YTMembersNumModel alloc] initWithJSONDict:jsonDict];
    }
    else if ([url isEqualToString:getPsqptHbListByPublishIdURL]) {
        return [[YTPsqptHbListModel alloc] initWithJSONDict:jsonDict];
    }
    return [[YTBaseModel alloc] initWithJSONDict:jsonDict];
}
@end
