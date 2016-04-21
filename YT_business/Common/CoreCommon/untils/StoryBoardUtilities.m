//
//  StoryBoardUtilities.m
//  DangKe
//
//  Created by lv on 15/4/25.
//  Copyright (c) 2015年 lv. All rights reserved.
//

#import "StoryBoardUtilities.h"
#import <objc/runtime.h>

NSString* const YT_MainStoryboard = @"Main";

@implementation StoryBoardUtilities

+ (id)viewControllerForMainStoryboard:(id)controllerClass
{
    return [self viewControllerForStoryboardName:YT_MainStoryboard class:controllerClass];
}

+ (id)viewControllerForStoryboardName:(NSString*)storyboardName class:(id)controllerClass
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    NSString* className = nil;
    
    if ([controllerClass isKindOfClass:[NSString class]])
        className = [NSString stringWithFormat:@"%@", controllerClass];
    else
        className = [NSString stringWithFormat:@"%s", class_getName([controllerClass class])];
    
    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@", className]];
    return viewController;
}

@end
