
#import "YTCityZoneMange.h"
#import "YTHttpClient.h"
#import "YTCityZoneModel.h"

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
    //[NSString stringWithFormat:@"http://test.user.api.yuntaohongbao.com/%@", getZoneListURL]
    [[YTHttpClient client] requestWithURL:getZoneListURL
        paras:requestParas
        success:^(AFHTTPRequestOperation* operation, NSObject* parserObject) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            YTCityZoneModel* responseModel = (YTCityZoneModel*)parserObject;
            [strongSelf configAreaDataList:responseModel];
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* requestErr){
        }];
}
- (void)configAreaDataList:(YTCityZoneModel*)cityZoneModel
{
    if (!cityZoneModel.zone.etag) {
        return;
    }
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
