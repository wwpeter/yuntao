#import "ShopDetailModel.h"
#import "NSStrUtil.h"
#import "SingleHbModel.h"
#import "SubtractFullModel.h"
#import "NSDate+Utilities.h"
#import "NSDate+TimeInterval.h"

@implementation ShopDetailModel
- (instancetype)initWithShopDetailDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        NSDictionary* dateDic = dictionary[@"data"];
        NSDictionary* shopDic = dateDic[@"shop"];

        self.shopName = shopDic[@"name"];
        self.shopId = shopDic[@"id"];
        self.level = @10;
        self.equalPrice = shopDic[@"custFee"];
        self.shopAddress = shopDic[@"address"];
        self.shopPhone = shopDic[@"mobile"];
        self.startDate = [NSString
            stringWithFormat:@"%@", shopDic[@"startTime"]];
        self.endDate = [NSString
            stringWithFormat:@"%@", shopDic[@"endTime"]];
        self.parking = shopDic[@"parkingSpace"];
        self.shopHongbaoRule = shopDic[@"shopHongbaoRule"];
        self.hbList = [[NSMutableArray alloc] init];
        self.backImgUrl = shopDic[@"img"];
        self.longitude = [shopDic[@"lon"] doubleValue];
        self.latitude = [shopDic[@"lat"] doubleValue];
        self.receiveableHongbao = dateDic[@"receiveableHongbao"];
        self.userHongbaos = dateDic[@"inThisShopUserHongbao"][@"records"];
        self.discount = [dateDic[@"discount"] integerValue];
        self.isDiscount = self.discount == 100 ? NO : YES;
        self.isHongbao = [shopDic[
            @"isHongbao"] boolValue];
        self.status = [shopDic[@"status"] integerValue];
        self.hjImages = dateDic[@"hjImg"];
        for (id object in dateDic[@"receiveableHongbao"]) {
            SingleHbModel* single =
                [[SingleHbModel alloc] initWithSingleHbDictionary:object];
            [self.hbList addObject:single];
        }
        self.promotionType =
            [shopDic[@"promotionType"] integerValue];
        ;
        self.isPromotion = (self.promotionType == 1 && self.isDiscount) || self.promotionType == 2;
        self.curFullSubtract = shopDic[@"curFullSubtract"];
        self.fullSubRuleDesStr = shopDic[@"fullSubRuleDes"];
        self.fullSubtract = shopDic[@"fullSubtract"];
        self.conflictVer = [shopDic[@"conflictVer"] boolValue];
        [self setupShopSubtract];
        self.subtractInTime = [self isSubtractInTime];
        [self setupNameAttributedWithHb:self.isHongbao];
        [self setupSubtractAttributed];
        [self setupSubtractTimeAttributed];
    }
    return self;
}
- (void)setupShopSubtract
{
    if ([NSStrUtil isEmptyOrNull:self.fullSubtract] || !self.conflictVer) {
        return;
    }
    NSArray* fullSubtracts = [NSStrUtil jsonObjecyWithString:self.fullSubtract];
    NSMutableArray* subtractMutableArray =
        [[NSMutableArray alloc] initWithCapacity:fullSubtracts.count];
    NSMutableArray* fullRules = [[NSMutableArray alloc] init];
    NSMutableArray* inDateRules = [[NSMutableArray alloc] init];
    for (NSDictionary* dic in fullSubtracts) {
        SubtractFullModel* subtract =
            [[SubtractFullModel alloc] initWithSubtractFullDictionary:dic];
        [subtractMutableArray addObject:subtract];
        [fullRules addObjectsFromArray:subtract.rules];
        if ([self valideteInDate:subtract.startDateStr endDate:subtract.endDateStr]) {
            [inDateRules addObjectsFromArray:subtract.rules];
        }
    }
    self.fullSubtracts = [[NSArray alloc] initWithArray:subtractMutableArray];
    self.fullAllRules = [[NSArray alloc] initWithArray:fullRules];
    self.fullInDateRules = [[NSArray alloc] initWithArray:inDateRules];

    if ([NSStrUtil isEmptyOrNull:self.fullSubRuleDesStr]) {
        return;
    }
    NSDictionary* desDict =
        [NSStrUtil jsonObjecyWithString:self.fullSubRuleDesStr];
    self.fullSubRuleDes = [SubtractFullDes modelObjectWithDictionary:desDict];
    if ([NSStrUtil isEmptyOrNull:self.curFullSubtract]) {
        return;
    }
    NSArray* curArray = [self.curFullSubtract componentsSeparatedByString:@"/"];
    self.subtractFull = [[curArray firstObject] integerValue] / 100;
    self.subtractCur = [curArray[1] integerValue] / 100;
    self.subtractMax = [[curArray lastObject] integerValue] / 100;
}

- (void)setupNameAttributedWithHb:(BOOL)isHb
{
    UIImage* redImage = [UIImage imageNamed:@"yt_hongIcon.png"];
    NSTextAttachment* redAttachment = [[NSTextAttachment alloc] init];
    redAttachment.image = redImage;
    redAttachment.bounds = CGRectMake(10, -2, redImage.size.width, redImage.size.height);
    NSAttributedString* redAttachmentString =
        [NSAttributedString attributedStringWithAttachment:redAttachment];

    NSString* foldImageName = self.promotionType == 1 ? @"yt_zheIcon.png" : @"yt_subtractIcon.png";
    UIImage* foldImage = [UIImage imageNamed:foldImageName];
    NSTextAttachment* foldAttachment = [[NSTextAttachment alloc] init];
    foldAttachment.image = foldImage;
    foldAttachment.bounds = CGRectMake(15, -2, foldImage.size.width, foldImage.size.height);
    NSAttributedString* foldpAttachmentString =
        [NSAttributedString attributedStringWithAttachment:foldAttachment];

    NSMutableAttributedString* attString =
        [[NSMutableAttributedString alloc] initWithString:self.shopName];
    if (isHb) {
        [attString appendAttributedString:redAttachmentString];
    }
    if (self.isPromotion) {
        [attString appendAttributedString:foldpAttachmentString];
    }
    self.nameAttributed =
        [[NSAttributedString alloc] initWithAttributedString:attString];
}
- (void)setupSubtractAttributed
{
    if (self.promotionType != 2 || !self.subtractInTime || !self.nowSubtract) {
        return;
    }
    NSString* manStr =
        [NSString stringWithFormat:@"%@", @(self.nowSubtract.subtractFull)];
    NSString* jianStr =
        [NSString stringWithFormat:@"%@", @(self.nowSubtract.subtractCur)];
    NSString* promotionStr =
        [NSString stringWithFormat:@"每满%@减%@", manStr, jianStr];
    NSMutableAttributedString* mutableAttributedStr =
        [[NSMutableAttributedString alloc] initWithString:promotionStr];
    [mutableAttributedStr addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:50]
                                 range:NSMakeRange(2, manStr.length)];
    [mutableAttributedStr
        addAttribute:NSFontAttributeName
               value:[UIFont systemFontOfSize:50]
               range:NSMakeRange(promotionStr.length - jianStr.length,
                         jianStr.length)];
    self.subtractAttributed = [[NSAttributedString alloc]
        initWithAttributedString:mutableAttributedStr];
}
- (void)setupSubtractTimeAttributed
{
    if (self.promotionType != 2 || !self.subtractInTime || !self.nowSubtract) {
        return;
    }
    UIImage* timeImage = [UIImage imageNamed:@"yt_subtractTime.png"];
    NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
    attachment.image = timeImage;
    attachment.bounds = CGRectMake(0, -2, timeImage.size.width, timeImage.size.height);

    NSAttributedString* attachmentString =
        [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString* timeAttributedString =
        [[NSMutableAttributedString alloc]
            initWithAttributedString:attachmentString];
    NSString* timeStr = [NSString
        stringWithFormat:@"%@ %@",
        [self.nowSubtract.dateStr
                             stringByReplacingOccurrencesOfString:@"/"
                                                       withString:@"至"],
        [self.nowSubtract.time
                             stringByReplacingOccurrencesOfString:@"/"
                                                       withString:@"-"]];
    NSAttributedString* timeText =
        [[NSMutableAttributedString alloc] initWithString:timeStr];
    [timeAttributedString appendAttributedString:timeText];
    self.subtractTimeAttributed = [[NSAttributedString alloc]
        initWithAttributedString:timeAttributedString];
}
- (BOOL)isSubtractInTime
{
    if (!self.conflictVer) {
        return NO;
    }
    NSDate* nowDate = [NSDate date];
    NSString* nowTimeStr =
        [NSString stringWithFormat:@"%02ld%02ld", (long)nowDate.hour, (long)nowDate.minute];
    NSInteger nowTimeInt = [nowTimeStr integerValue];
    for (SubtractFullModel* subtract in self.fullSubtracts) {
        if (![self valideteInDate:subtract.startDateStr
                          endDate:subtract.endDateStr]) {
            continue;
        }
        for (SubtractFullRule* fullRule in subtract.rules) {
            NSString* firstTime =
                [fullRule.startTime stringByReplacingOccurrencesOfString:@":"
                                                              withString:@""];
            ;
            NSString* lastTime =
                [fullRule.endTime stringByReplacingOccurrencesOfString:@":"
                                                            withString:@""];
            NSInteger firstTimeInt = [firstTime integerValue];
            NSInteger lastTimeInt = [lastTime integerValue];
            if (firstTimeInt > nowTimeInt || lastTimeInt < nowTimeInt) {
                continue;
            }
            self.nowSubtract = fullRule;
            return YES;
        }
    }
    return NO;
}
- (BOOL)valideteInDate:(NSString*)startDate endDate:(NSString*)endDate
{
    NSDate* nowDate = [NSDate date];
    NSString* nowDateStr =
        [NSString stringWithFormat:@"%@%02ld%02ld", @(nowDate.year), (long)nowDate.month,
                  (long)nowDate.day];
    NSInteger nowDateInt = [nowDateStr integerValue];

    NSString* firstDate =
        [startDate stringByReplacingOccurrencesOfString:@"-"
                                             withString:@""];
    ;
    NSString* lastDate =
        [endDate stringByReplacingOccurrencesOfString:@"-"
                                           withString:@""];
    NSInteger firstDateInt = [firstDate integerValue];
    NSInteger lastDateInt = [lastDate integerValue];
    if (firstDateInt > nowDateInt || lastDateInt < nowDateInt) {
        return NO;
    }
    return YES;
}
- (void)validateFullSubtractTime
{
    self.subtractInTime = [self isSubtractInTime];
}
@end
