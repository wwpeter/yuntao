//
//  StoryBoardUtilities.h
//  DangKe
//
//  Created by lv on 15/4/25.
//  Copyright (c) 2015年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const YT_MainStoryboard;

@interface StoryBoardUtilities : NSObject

+ (id)viewControllerForMainStoryboard:(id)controllerClass;
+ (id)viewControllerForStoryboardName:(NSString*)storyboardName class:(id)controllerClass;

@end
