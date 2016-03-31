
#import "UIActionSheet+TTBlock.h"
#import <objc/runtime.h>

@implementation UIActionSheet (TTBlock)

- (void)setCompletionBlock:(TTActionSheetCompletionBlock)completionBlock {
    objc_setAssociatedObject(self, @selector(completionBlock), completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (completionBlock == NULL) {
        self.delegate = nil;
    }
    else {
        self.delegate = self;
    }
}

- (TTActionSheetCompletionBlock)completionBlock {
    return objc_getAssociatedObject(self, @selector(completionBlock));
}

#pragma mark - UIAlertViewDelegate

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.completionBlock) {
        self.completionBlock(self, buttonIndex);
    }
}

@end
