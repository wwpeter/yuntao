//
//  CHProposeCostViewController.m
//  YT_business
//
//  Created by chun.chen on 15/6/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "CHProposeCostViewController.h"

@interface CHProposeCostViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *costField;
@end

@implementation CHProposeCostViewController
#pragma mark - Life cycle
- (id)init {
    if ((self = [super init])) {
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
        self.navigationItem.title = @"编辑价格";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    
    [self initializePageSubviews];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.costField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.costField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)keyboardWillShow:(NSNotification*)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber* duration = (note.userInfo)[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber* curve = (note.userInfo)[UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    [UIView commitAnimations];
}

#pragma mark - Navigation
- (void)didLeftBarButtonItemAction:(id)sender
{
    
}
- (void)didRightBarButtonItemAction:(id)sender
{
    [_delegate proposeCostController:self inputCost:_costField.text];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    UILabel *sellLabel = [[UILabel alloc] init];
    sellLabel.font = [UIFont systemFontOfSize:15];
    sellLabel.textColor = CCCUIColorFromHex(0x333333);
    sellLabel.textAlignment = NSTextAlignmentCenter;
    sellLabel.text = @"建议售价";
    [self.view addSubview:sellLabel];
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_propose_costField.png"]];
    [self.view addSubview:textImageView];
    [self.view addSubview:self.costField];
    
    UIView *tipView = [[UIView alloc] init];
    tipView.backgroundColor = CCCUIColorFromHex(0xfff7d8);
    [self.view addSubview:tipView];
    
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = CCCUIColorFromHex(0x888888);
    tipLabel.numberOfLines = 2;
    NSString *tips = @"红包建议售价不得高于红包价值的10%(如价值100元的红包，售价不得高于10元)";
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:tips];
    [str addAttribute:NSForegroundColorAttributeName value:CCCUIColorFromHex(0xfd5c62) range:NSMakeRange(15, 3)];
    tipLabel.attributedText = str;

    [tipView addSubview:tipLabel];
    
    CGFloat textBaclHeight = KDeviceHeight - kNavigationFullHeight - 216;
    
    [sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textBaclHeight/2 - 10);
        make.left.right.mas_equalTo(self.view);
    }];
    
    [textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textBaclHeight/2 + 20);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(160, 48));
    }];
    [_costField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(textImageView);
        make.left.mas_equalTo(textImageView).offset(55);
        make.right.mas_equalTo(textImageView);
    }];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-216);
        make.height.mas_equalTo(50);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(tipView);
    }];
}
#pragma mark - Getters & Setters
- (UITextField *)costField
{
    if (!_costField) {
        _costField = [[UITextField alloc] init];
        _costField.tintColor = [UIColor redColor];
        _costField.borderStyle = UITextBorderStyleNone;
        _costField.returnKeyType = UIReturnKeyDone;
        _costField.keyboardType = UIKeyboardTypeDecimalPad;
        _costField.enablesReturnKeyAutomatically = YES;
        _costField.delegate = self;
        _costField.text = @"0";
        
    }
    return _costField;
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
