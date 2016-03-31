
#import <UIKit/UIKit.h>
typedef void (^TTActionSheetCompletionBlock)(UIActionSheet *alertView, NSInteger buttonIndex);

@interface UIActionSheet (TTBlock)<UIActionSheetDelegate>

- (void)setCompletionBlock:(TTActionSheetCompletionBlock)completionBlock;
- (TTActionSheetCompletionBlock)completionBlock;

@end
