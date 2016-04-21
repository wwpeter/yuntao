#import "NSJSONSerialization+file.h"

#define FilePath(fileName) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:fileName]

@implementation NSJSONSerialization (file)

+(void)save:(id)object fileName:(NSString *)name
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"dic->%@",error);
    }
    BOOL succeed = [jsonData writeToFile:FilePath(name) atomically:YES];
    if (succeed) {
        NSLog(@"Save succeed");
    }else {
        NSLog(@"Save fail");
    }
}
+(id)loadObjectFileName:(NSString *)name
{
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:FilePath(name)];     /* Now try to deserialize the JSON object into a dictionary */
//    
//    NSLog(@"json data is %@",jsonData);
    if (jsonData == NULL) {
        return nil;
    }
    else {
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        if (jsonObject != nil && error == nil){
            return jsonObject;
        }
    }
    return nil;
}

@end
