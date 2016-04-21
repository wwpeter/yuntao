#import "YTBaseModel.h"

@interface YTHongbaoStoreHelper : NSObject

@property (nonatomic,strong) NSMutableArray *hbArray;

+ (YTHongbaoStoreHelper *)hongbaoStoreHelper;
- (NSDictionary*)setupConfimOrder;
- (void)cleanOrder;
@end
