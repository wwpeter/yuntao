#import "YTHbShopModel.h"
#import "UserMationMange.h"
#import "NSStrUtil.h"

@implementation YTHbShopModel
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.isSubtract = [self validShopSubtract];
    }
    return self;
}
+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"id" : @"shopId",
    }];
}
- (NSAttributedString*)nameAttributeStr
{
    UIImage* redImage = [UIImage imageNamed:@"yt_hongIcon.png"];
    NSTextAttachment* redAttachment = [[NSTextAttachment alloc] init];
    redAttachment.image = redImage;
    redAttachment.bounds = CGRectMake(10, -2, redImage.size.width, redImage.size.height);
    NSAttributedString* redAttachmentString = [NSAttributedString attributedStringWithAttachment:redAttachment];

    NSString* foldImageName =
    self.promotionType == 1 ? @"yt_zheIcon.png" : @"yt_subtractIcon.png";
    UIImage* foldImage = [UIImage imageNamed:foldImageName];
    NSTextAttachment* foldAttachment = [[NSTextAttachment alloc] init];
    foldAttachment.image = foldImage;
    foldAttachment.bounds = CGRectMake(15, -2, foldImage.size.width, foldImage.size.height);
    NSAttributedString* foldpAttachmentString = [NSAttributedString attributedStringWithAttachment:foldAttachment];

    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:self.name];
//    if (self.isHongbao) {
//        [attString appendAttributedString:redAttachmentString];
//    }
    [attString appendAttributedString:redAttachmentString];
    if (self.promotionType > 0) {
        [attString appendAttributedString:foldpAttachmentString];
    }
    return [[NSAttributedString alloc] initWithAttributedString:attString];
}
- (NSAttributedString*)discountAttributed
{
    if (self.discount == 100) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    NSString* discountStr = [NSString stringWithFormat:@"%.1f", self.discount / 10.];
    NSMutableAttributedString* mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@折", discountStr]];
    [mutableAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(0, discountStr.length)];
    return [[NSAttributedString alloc] initWithAttributedString:mutableAttributedStr];
}
- (NSString *)userLocationDistance
{
    //第一个坐标
    CLLocation* current = [UserMationMange sharedInstance].userLocation;
    NSString* distanceStr = @"";
    if (self.lat != 0 && current.coordinate.latitude != 0) {
        //第二个坐标
        CLLocation* before = [[CLLocation alloc] initWithLatitude:self.lat longitude:self.lon];
        // 计算距离
        CLLocationDistance meters = [current distanceFromLocation:before];
        if (meters > 0) {
            if (meters > 100) {
                CGFloat distance = meters / 1000;
                if (distance > 9999) {
                    distanceStr = @">9999km";
                }
                else {
                    distanceStr = [NSString stringWithFormat:@"%.2fkm", distance];
                }
            }
            else {
                distanceStr = [NSString stringWithFormat:@"%.2fm", meters];
            }
        }
    }
    return distanceStr;
}

- (BOOL)validShopSubtract
{
    if ([NSStrUtil isEmptyOrNull:self.fullSubtract] || !self.conflictVer) {
        return NO;
    }
    
    if ([NSStrUtil isEmptyOrNull:self.curFullSubtract]) {
        return NO;
    }
    NSArray* curArray = [self.curFullSubtract componentsSeparatedByString:@"/"];
    self.subtractFull = [[curArray firstObject] integerValue] / 100;
    self.subtractCur = [curArray[1] integerValue] /100;
    self.subtractMax = [[curArray lastObject] integerValue] / 100;
    return YES;
}


@end
