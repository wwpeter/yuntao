//
//  ApplySuccessViewController.m
//  YT_business
//
//  Created by 郑海清 on 15/6/12.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "ApplySuccessViewController.h"


@implementation ApplySuccessViewController


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"done") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YTPaySuccessViewDelegate
- (void)paySuccessView:(YTPaySuccessView *)view clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.applySuccessView];
    [_applySuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}
#pragma mark - Getters & Setters
- (YTPaySuccessView *)applySuccessView
{
    if (!_applySuccessView) {
        _applySuccessView = [[YTPaySuccessView alloc] init];
        _applySuccessView.buyButton.hidden = YES;
        _applySuccessView.titleLabel.text = @"退款申请成功";
        _applySuccessView.describeLabel.text = @"我们会尽快进行审核 \n审核通过后会将款项退换到原支付方";
        _applySuccessView.iconImageView.image = [UIImage imageNamed:@"zh_apply_success"];
        _applySuccessView.delegate = self;
    }
    return _applySuccessView;
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
