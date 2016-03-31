
#import <UIKit/UIKit.h>

typedef void (^RWAlertViewCompletionBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (TTBlock)<UIAlertViewDelegate>

- (void)setCompletionBlock:(RWAlertViewCompletionBlock)completionBlock;
- (RWAlertViewCompletionBlock)completionBlock;

@end
