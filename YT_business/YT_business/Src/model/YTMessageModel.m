

#import "YTMessageModel.h"

@implementation YTMessageModel

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _title = title;
        _message = message;
    }
    return self;
}
@end
