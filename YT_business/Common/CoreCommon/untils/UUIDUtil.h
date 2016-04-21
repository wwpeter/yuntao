#import <Foundation/Foundation.h>

@interface UUIDUtil : NSObject

+ (void) save:(NSString *)service data:(id)data;
+ (id)   load:(NSString *)service;
+ (void) deleteData:(NSString *)service;
+ (NSString*) uuid;
@end
