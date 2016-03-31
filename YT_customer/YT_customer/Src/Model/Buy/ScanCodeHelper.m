#import "ScanCodeHelper.h"

NSString* const kScanCodeShopId = @"shopId";
NSString* const kScanCodeOpenType = @"openType";
NSString* const kScanCodeModule = @"module";
NSString* const kScanCodePromotion = @"promotion";
NSString* const kScanCodeDiscount = @"discount";
NSString* const kScanCodePromotionType = @"promotionType";

@implementation ScanCodeHelper
- (instancetype)initWithResultUrlString:(NSString*)string
{
    if (self = [super init]) {
        self.resultString = string;
//        NSURL* scanUrl = [NSURL URLWithString:string];
//        NSArray* urls = [scanUrl.query componentsSeparatedByString:@"&"];
        NSString *shopInfoStr = [[string componentsSeparatedByString:@"?"] lastObject];
        NSArray* urls = [shopInfoStr componentsSeparatedByString:@"&"];
        if (urls.count < 3) {
            self.isYtCode = NO;
        }
        else {
            self.isYtCode = YES;
            for (NSString* text in urls) {
                NSRange range = [text rangeOfString:@"="];
                if (range.location == NSNotFound) {
                    continue;
                }
                NSArray* textArray = [text componentsSeparatedByString:@"="];
                NSString* firstText = [textArray firstObject];
                NSString* lastText = [textArray lastObject];
                if ([firstText isEqualToString:kScanCodeShopId]) {
                    [self setupScanShopId:lastText];
                }
                else if ([firstText isEqualToString:kScanCodeOpenType]) {
                    [self setupScanOpenType:lastText];
                }
                else if ([firstText isEqualToString:kScanCodeModule]) {
                    [self setupScanModule:lastText];
                }
                else if ([firstText isEqualToString:kScanCodePromotion]) {
                    self.promotion = [lastText integerValue];
                }
                else if ([firstText isEqualToString:kScanCodeDiscount]) {
                    self.discount = [lastText integerValue];
                }
                else if ([firstText isEqualToString:kScanCodePromotionType]) {
                    [self setupScanPromotionType:lastText];
                }
            }
        }
    }
    return self;
}

- (void)setupScanModule:(NSString*)module
{
    if ([module isEqualToString:@"SCAN_USE_HONGBAO"]) {
        self.moudel = ScanCodeModuleUseHb;
    }
    else if ([module isEqualToString:@"GIVE_HONGBAO"]) {
        self.moudel = ScanCodeModuleGiveHb;
    }
    else if ([module isEqualToString:@"SHOP_INFO"]) {
        self.moudel = ScanCodeModuleShopInfo;
    }
    else {
        self.isYtCode = NO;
    }
}
- (void)setupScanOpenType:(NSString*)openType
{
    if ([openType isEqualToString:@"REST"]) {
        self.moudel = ScanCodeOpenTypeNative;
    }
    else if ([openType isEqualToString:@"H5"]) {
        self.moudel = ScanCodeOpenTypeH5;
    }
}
- (void)setupScanShopId:(NSString*)shop
{
    NSNumberFormatter* f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    self.shopId = [f numberFromString:shop];
}
- (void)setupScanPromotionType:(NSString*)promotionType
{
    self.promotionType = [promotionType integerValue];
    BOOL validateDiscount = self.promotionType == 1 && self.discount != 100;
    self.isPromotion = validateDiscount || (self.promotionType == 2);
}
@end
