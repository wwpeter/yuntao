#import "StoreAuditFailViewController.h"
#import "RESideMenu.h"
#import "UIBarButtonItem+Addition.h"
#import "UIImage+HBClass.h"
#import "UIViewController+Helper.h"

@interface StoreAuditFailViewController ()

@end

@implementation StoreAuditFailViewController

#pragma mark - Life cycle
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商户信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoSideLefttarget:self action:@selector(presentLeftMenuViewController:)];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Event response
- (void)submitButtonClicked:(id)sender
{
    [self showContentViewControllerAtIndex:7];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    UIImageView *waitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hbReviewFail_02.png"]];
    [self.view addSubview:waitImageView];
    
    UILabel *waitLabel = [[UILabel alloc] init];
    waitLabel.font = [UIFont systemFontOfSize:20];
    waitLabel.textColor = [UIColor blackColor];
    waitLabel.textAlignment = NSTextAlignmentCenter;
    waitLabel.numberOfLines = 1;
    waitLabel.text = @"审核未通过";
    [self.view addSubview:waitLabel];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.textColor = CCCUIColorFromHex(0x999999);
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 1;
    messageLabel.text = [YTUsr usr].shop.auditComment;
    [self.view addSubview:messageLabel];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 4;
    [submitBtn setTitle:@"重新提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfa5e66)] forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];

    
    [waitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    [waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(waitImageView.bottom).offset(25);
    }];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(waitLabel.bottom).offset(15);
    }];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(messageLabel.bottom).offset(30);
        make.height.mas_equalTo(45);
    }];
}

@end
