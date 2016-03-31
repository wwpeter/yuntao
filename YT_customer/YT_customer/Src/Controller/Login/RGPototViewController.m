//
//  RGPototViewController.m
//  YT_business
//
//  Created by chun.chen on 15/6/4.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "RGPototViewController.h"
#import "UIActionSheet+TTBlock.h"

@interface RGPototViewController ()

@end

@implementation RGPototViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"yt_navigation_delete.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    
}

- (void)didRightBarButtonItemAction:(id)sender
{
    UIActionSheet *sheet  = [[UIActionSheet alloc] initWithTitle:@"要删除这张照片吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    [sheet setCompletionBlock:^(UIActionSheet *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            if ([self.delegate respondsToSelector:@selector(photoBrowser:deletePhotoAtIndex:)]) {
                [self.delegate photoBrowser:self deletePhotoAtIndex:self.currentIndex];
            }
        }
    }];
    [sheet showInView:self.view];
    
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
