#import "StoreWaiteAuditViewController.h"
#import "RESideMenu.h"
#import "UIBarButtonItem+Addition.h"
#import "UIImage+HBClass.h"
#import "UIViewController+Helper.h"

@interface StoreWaiteAuditViewController ()

@end

@implementation StoreWaiteAuditViewController

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
- (void)callServiceButtonClicked:(id)sender
{
    [self callPhoneNumber:@"400-1177-677"];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    UIImageView *waitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face_pay_waiting_02.png"]];
    [self.view addSubview:waitImageView];
    
    UILabel *waitLabel = [[UILabel alloc] init];
    waitLabel.font = [UIFont systemFontOfSize:20];
    waitLabel.textColor = [UIColor blackColor];
    waitLabel.textAlignment = NSTextAlignmentCenter;
    waitLabel.numberOfLines = 1;
    waitLabel.text = @"等待审核";
    [self.view addSubview:waitLabel];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.textColor = CCCUIColorFromHex(0x999999);
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.text = @"您的入驻申请正在受理中，我们会在1个小时内完成审核。您也可以联系客服加快审核进程";
    [self.view addSubview:messageLabel];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.layer.masksToBounds = YES;
    callBtn.layer.cornerRadius = 4;
    callBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [callBtn setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
    [callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(callServiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callBtn];
    
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
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(waitLabel.bottom).offset(15);
    }];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(messageLabel.bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(180, 44));
    }];
}

@end
