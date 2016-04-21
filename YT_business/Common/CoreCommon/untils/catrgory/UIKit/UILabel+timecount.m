#import "UILabel+timecount.h"
#import "NSStrUtil.h"

@implementation UILabel (timecount)

- (void)timeCountdown:(NSInteger)seconds;
{
    self.text = [NSStrUtil timeformatFromSeconds:seconds];
    __block NSInteger timeout= seconds; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.text = @"已结束";
            });
            
        }else{
            //            NSInteger bseconds = timeout % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.text =[NSStrUtil timeformatFromSeconds:timeout];
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


@end
