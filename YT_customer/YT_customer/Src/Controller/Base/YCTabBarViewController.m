//
//  YCTabBarViewController.m
//  YT_customer
//
//  Created by chun.chen on 15/6/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YCTabBarViewController.h"
#import "StoreSortMange.h"

@interface YCTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation YCTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    for (UITabBarItem* tabBarItem in self.tabBar.items) {
        switch (tabBarItem.tag) {
        case 0: {
            tabBarItem.selectedImage = [UIImage imageNamed:@"ye_tabbar_activity_select.png"];
        } break;
        case 1: {
            tabBarItem.selectedImage = [UIImage imageNamed:@"ye_tabbar_hb_select.png"];
        } break;
        case 2: {
            tabBarItem.selectedImage = [UIImage imageNamed:@"ye_tabbar_store_select.png"];
        } break;
        case 3: {
            tabBarItem.selectedImage = [UIImage imageNamed:@"ye_tabbar_me_select.png"];
        } break;

        default:
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
