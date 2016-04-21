//
//  YTNavigationController.m
//  YT_business
//
//  Created by chun.chen on 15/6/1.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTNavigationController.h"
#import "UIBarButtonItem+Addition.h"

@interface YTNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation YTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self steupAppearance];
    
    __weak YTNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)steupAppearance
{
    // 配置导航栏
    //    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor],
                                                            NSShadowAttributeName : [NSShadow new] }];
        [self.navigationBar setTintColor:[UIColor redColor]];
//    [[UIBarButtonItem appearance]
//     setBackButtonBackgroundImage:[UIImage imageNamed:@"yt_navigation_backBtn_normal.png"]
//     forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:DKNavbackbarImage forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearanceWhenContainedIn:[MFMessageComposeViewController class], nil] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

//    [[UITabBar appearance] setSelectedImageTintColor:CCColorFromRGB(21, 174, 237)];
    
}

// Hijack the push method to disable the gesture

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1)
    {
        UIImage *norImage = [UIImage imageNamed:@"yt_navigation_backBtn_normal.png"];
        UIImage *higlImage = [UIImage imageNamed:@"yt_navigation_backBtn_high.png"];
        viewController.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomImage:norImage highlightImage:higlImage target:self action:@selector(didLeftBarButtonItemAction:)];
        
    }

}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        // disable interactivePopGestureRecognizer in the rootViewController of navigationController
        if ([[navigationController.viewControllers firstObject] isEqual:viewController]) {
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            // enable interactivePopGestureRecognizer
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (void)didLeftBarButtonItemAction:(id)sender
{
    [super popViewControllerAnimated:YES];
}

@end
