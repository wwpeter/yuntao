//
//  ApplyUntil.m
//  DangKe
//
//  Created by lv on 15/5/18.
//  Copyright (c) 2015年 lv. All rights reserved.
//

#import "ApplyUntil.h"
#import "UIAlertView+TTBlock.h"
#import "MBProgressHUD+Add.h"

static NSString* const YT_AppleID = @"1018504199";
//static NSString* const YT_AppleID = @"980170516";

@implementation ApplyUntil

+ (NSNumber*)bigAppid
{
    return @1;
}
+ (NSNumber*)appid
{
    return @4;
}
+ (NSNumber*)plat
{
    return @1;
}
+ (NSNumber*)channel
{
    return @1;
}
+ (NSNumber*)gap
{
    return @0;
}

+ (NSString*)version
{
    NSDictionary* bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleShortVersionString"];
}
+ (NSString*)build
{
    NSDictionary* bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:(NSString*)kCFBundleVersionKey];
}
+ (NSString*)bundleId
{
    NSDictionary* bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:(NSString*)kCFBundleIdentifierKey];
}
+ (NSString*)bundleName
{
    NSDictionary* bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:(NSString*)kCFBundleNameKey];
}
+ (NSString *)applicationName
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"];
}
/*
+ (void)checkVersionUpdate:(UIView*)view
{
    if (view) {
        [MBProgressHUD showMessag:@"请稍后..." toView:view];
    }
    NSString* storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", YT_AppleID];
    NSURL* storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"POST"];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {

                               if ([data length] > 0 && !error) { // Success

                                   NSDictionary* appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if (view) {
                                           [MBProgressHUD hideHUDForView:view animated:YES];
                                       }

                                       // All versions that have been uploaded to the AppStore
                                       NSArray* versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                                       if (![versionsInAppStore count]) { // No versions of app in AppStore
                                           return;
                                       }
                                       else {

                                           NSString* currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];

                                           if ([[self version] compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {

                                               [self showAlertWithAppStoreVersion:currentAppStoreVersion];
                                           }
                                           else {
                                               if (!view) {
                                                   return;
                                               }
                                               [[[UIAlertView alloc]
                                                       initWithTitle:@""
                                                             message:@"当前已为最新版本"
                                                            delegate:nil
                                                   cancelButtonTitle:@"关闭"
                                                   otherButtonTitles:nil] show];
                                           }
                                       }

                                   });
                               }

                           }];
}
 */

+ (void)showAlertWithAppStoreVersion:(NSString*)currentAppStoreVersion
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                        message:[NSString stringWithFormat:@" %@ %@", [ApplyUntil bundleName], currentAppStoreVersion]
                                                       delegate:self
                                              cancelButtonTitle:@"稍后"
                                              otherButtonTitles:@"立即更新", nil];

    [alertView setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString* iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", YT_AppleID];
            NSURL* iTunesURL = [NSURL URLWithString:iTunesString];
            [[UIApplication sharedApplication] openURL:iTunesURL];
        }
    }];
    [alertView show];
}
@end
