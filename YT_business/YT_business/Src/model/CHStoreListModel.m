#import "CHStoreListModel.h"

@implementation CHStoreListModel

- (instancetype)initWithStoreListDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.storeId = @1;
        self.storeName = @"名字名字";
        self.cost = @"88";
        self.address = @"区域区域";
        self.sort = @"分类一一";
        self.rank = 10;
        self.distanceStr = @"111.1km";
        self.selectAtIndex = -1;
        self.costStr = [NSString stringWithFormat:@"￥%@/%@",self.cost,@"人"];
        [self setupNameAttributed];
    }
    return self;
}

- (void)setupNameAttributed
{
    UIImage *redImage = [UIImage imageNamed:@"yt_hongIcon.png"];
    NSTextAttachment* redAttachment = [[NSTextAttachment alloc] init];
    redAttachment.image = redImage;
    redAttachment.bounds = CGRectMake(10, -2, redImage.size.width, redImage.size.height);
    NSAttributedString* redAttachmentString = [NSAttributedString attributedStringWithAttachment:redAttachment];
    
    UIImage *foldImage = [UIImage imageNamed:@"yt_zheIcon.png"];
    NSTextAttachment* foldAttachment = [[NSTextAttachment alloc] init];
    foldAttachment.image = foldImage;
    foldAttachment.bounds = CGRectMake(15, -2, foldImage.size.width, foldImage.size.height);
    NSAttributedString* foldpAttachmentString = [NSAttributedString attributedStringWithAttachment:foldAttachment];
    
    
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:self.storeName];
    [attString appendAttributedString:redAttachmentString];
    [attString appendAttributedString:foldpAttachmentString];
    self.nameAttributed = attString;
}
@end
