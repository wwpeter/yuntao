#import "CStoreIntroModel.h"
#import "UserMationMange.h"
#import "NSStrUtil.h"
#import "SubtractFullModel.h"

@implementation CStoreIntroModel
- (instancetype)initWithStoreIntroDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        self.storeId = dictionary[@"id"];
        self.imageUrl = dictionary[@"img"];
        self.storeName = dictionary[@"name"];
        self.cost = dictionary[@"custFee"];
        self.address = dictionary[@"address"];
        self.sort = dictionary[@"catName"];
        ;
        self.rank = 10;
        self.selectAtIndex = -1;
        self.costStr = [NSString
            stringWithFormat:@"￥%.2f/%@", self.cost.floatValue / 100, @"人"];
        self.discount = [dictionary[@"discount"] integerValue];
        self.isHongbao = [dictionary[@"isHongbao"] boolValue];
        self.latitude = [dictionary[@"lat"] floatValue];
        self.longitude = [dictionary[@"lon"] floatValue];
        self.isDiscount = self.discount == 100 ? NO : YES;
        self.promotionType = [dictionary[@"promotionType"] integerValue];
        self.isPromotion = (self.promotionType==1 && self.isDiscount) || self.promotionType == 2;
        self.curFullSubtract = dictionary[@"curFullSubtract"];
        self.fullSubtract = dictionary[@"fullSubtract"];
        self.conflictVer = [dictionary[@"conflictVer"] boolValue];
        [self setupUserDistance];
        [self setupShopSubtract];
        [self setupNameAttributed];
        [self setupDiscountAttributed];
    }
    return self;
}
- (void)setupUserDistance
{
    //第一个坐标
    CLLocation* current = [UserMationMange sharedInstance].userLocation;
    if (self.latitude != 0 && current.coordinate.latitude != 0) {
        //第二个坐标
        CLLocation* before = [[CLLocation alloc] initWithLatitude:self.latitude
                                                        longitude:self.longitude];
        // 计算距离
        CLLocationDistance meters = [current distanceFromLocation:before];
        if (meters > 0) {
            if (meters > 100) {
                CGFloat distance = meters / 1000;
                if (distance > 9999) {
                    self.distanceStr = @">9999km";
                }
                else {
                    self.distanceStr = [NSString stringWithFormat:@"%.2fkm", distance];
                }
            }
            else {
                self.distanceStr = [NSString stringWithFormat:@"%.2fm", meters];
            }
        }
        else {
            self.distanceStr = @" ";
        }
        self.distance = meters;
    }
    else {
        self.distance = 0;
        self.distanceStr = @" ";
    }
}
- (void)setupShopSubtract
{
    if ([NSStrUtil isEmptyOrNull:self.fullSubtract] || !self.conflictVer) {
        return;
    }
    NSArray* fullSubtracts = [NSStrUtil jsonObjecyWithString:self.fullSubtract];
    NSMutableArray* subtractMutableArray = [[NSMutableArray alloc] initWithCapacity:fullSubtracts.count];
    for (NSDictionary* dic in fullSubtracts) {
        SubtractFullModel* subtract = [[SubtractFullModel alloc] initWithSubtractFullDictionary:dic];
        [subtractMutableArray addObject:subtract];
    }
    self.fullSubtracts = [[NSArray alloc] initWithArray:subtractMutableArray];

    if ([NSStrUtil isEmptyOrNull:self.curFullSubtract]) {
        return;
    }
    NSArray* curArray = [self.curFullSubtract componentsSeparatedByString:@"/"];
    self.subtractFull = [[curArray firstObject] integerValue] / 100;
    self.subtractCur = [curArray[1] integerValue] /100;
    self.subtractMax = [[curArray lastObject] integerValue] / 100;
}
- (void)setupNameAttributed
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
        [[NSMutableAttributedString alloc] initWithString:self.storeName];
    if (self.isHongbao) {
        [attString appendAttributedString:redAttachmentString];
    }
    if (self.isPromotion) {
        [attString appendAttributedString:foldpAttachmentString];
    }
    self.nameAttributed =
        [[NSAttributedString alloc] initWithAttributedString:attString];
}
- (void)setupDiscountAttributed
{
    if (self.promotionType != 1 || !self.isDiscount) {
        return;
    }
    NSString* discountStr =
        [NSString stringWithFormat:@"%.1f", self.discount / 10.];
    NSMutableAttributedString* mutableAttributedStr =
        [[NSMutableAttributedString alloc]
            initWithString:[NSString stringWithFormat:@"%@折", discountStr]];
    [mutableAttributedStr addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:40]
                                 range:NSMakeRange(0, discountStr.length)];
    self.discountAttributed = [[NSAttributedString alloc]
        initWithAttributedString:mutableAttributedStr];
}
@end
