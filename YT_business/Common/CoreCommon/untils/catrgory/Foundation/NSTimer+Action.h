
#import <Foundation/Foundation.h>

@interface NSTimer (Action)

- (void)startTimer;           // 开始
- (void)pauseTimer;           // 暂停
- (void)resumeTimer;          // 继续
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
