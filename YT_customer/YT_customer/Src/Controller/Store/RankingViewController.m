//
//  RankingViewController.m
//  YT_customer
//
//  Created by mac on 16/2/18.
//  Copyright © 2016年 sairongpay. All rights reserved.
//

#import "RankingViewController.h"
#import "FriendRankingViewController.h"
#import "NearbyViewController.h"
#import "CityViewController.h"

@interface RankingViewController () <ViewPagerDataSource, ViewPagerDelegate>
@property (nonatomic, copy) NSArray* classArray;
@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _classArray = @[ @"好友榜", @"附近榜",@"城市榜"];
    self.dataSource = self;
    self.delegate = self;
    [self reloadData];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController*)viewPager
{
    return _classArray.count;
}
- (NSString*)viewPager:(ViewPagerController*)viewPager titleForTabAtIndex:(NSUInteger)index
{
    return _classArray[index];
}

- (UIViewController *)viewPager:(ViewPagerController*)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index{
    if (index == 0) {
        FriendRankingViewController * friendConreoller = [[FriendRankingViewController alloc] init];
        return friendConreoller;
    }
    if (index == 1) {
        NearbyViewController *controller = [[NearbyViewController alloc] init];
        return controller;
    } else {
        CityViewController *controller = [[CityViewController alloc] init];
        return controller;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController*)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        case ViewPagerOptionTabWidth:
            return kDeviceWidth / _classArray.count;
        default:
            break;
    }
    
    return value;
}
- (UIColor*)viewPager:(ViewPagerController*)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor*)color
{
    
    switch (component) {
        case ViewPagerIndicator:
            return YTDefaultRedColor;
        case ViewPagerTabsView:
            return [UIColor colorWithWhite:0 alpha:0.15];
        case ViewPagerContent:
            return [UIColor clearColor];
        default:
            return color;
    }
}


- (void)didReceiveMemoryWarning {
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
