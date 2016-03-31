#import <Foundation/Foundation.h>

// 储存文件名
static NSString *const kYCStoreCatDataFileName  = @"YcCat";

@interface NSJSONSerialization (file)

+(void)save:(id)object fileName:(NSString *)name;
+(id)loadObjectFileName:(NSString *)name;

@end
