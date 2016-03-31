#import "YTCityZoneMange.h"
#import "YTNetworkMange.h"
#import "YTCityZoneModel.h"
#import "YTModelFactory.h"

@implementation YTCityZoneMange
+ (YTCityZoneMange*)sharedMange
{
    static YTCityZoneMange* sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];

    if (self) {
    }
    return self;
}
+ (NSArray*)allProvinces
{
    NSMutableArray* mutableArr = [[NSMutableArray alloc] init];
    NSString* path = ArchiveFilePath(iYTCityZoneData);
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        mutableArr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
    else {
        mutableArr = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YT_DefaultCityZone.plist" ofType:nil]];
    }

    return [[mutableArr reverseObjectEnumerator] allObjects];
}
- (void)fetchAreaData
{
    NSString* etag = [[NSUserDefaults standardUserDefaults] objectForKey:iYTUserCizyZoneEtagKey] ?: @"";
    NSDictionary* requestParas = @{ @"etag" : etag };
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_GetZoneList
        parameters:requestParas
        success:^(id responseData) {

            if (![responseData isKindOfClass:[NSDictionary class]]) {
                return;
            }
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            YTCityZoneModel* responseModel = [[YTCityZoneModel alloc] initWithDictionary:responseData error:nil];
            [strongSelf configAreaDataList:responseModel];
        }
        failure:nil];
}
- (void)configAreaDataList:(YTCityZoneModel*)cityZoneModel
{
    [[NSUserDefaults standardUserDefaults] setObject:cityZoneModel.zone.etag forKey:iYTUserCizyZoneEtagKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (cityZoneModel.zone.areaVoList.count < 1) {
        return;
    }
    NSArray* chinaAreas = [cityZoneModel.zone.areaVoList firstObject][@"next"];
    NSLog(@"ArchiveFilePath = %@", ArchiveFilePath(iYTCityZoneData));
    [chinaAreas writeToFile:ArchiveFilePath(iYTCityZoneData) atomically:YES];
}
@end
