//
//  SGGridMenu.h
//  DangKe
//
//  Created by lv on 15/4/16.
//  Copyright (c) 2015年 lv. All rights reserved.
//

#import "SGBaseMenu.h"

@interface SGGridMenu : SGBaseMenu

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles images:(NSArray *)images;

- (void)triggerSelectedAction:(void(^)(NSInteger))actionHandle;

@end
