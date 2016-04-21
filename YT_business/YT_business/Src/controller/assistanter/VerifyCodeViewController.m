#import "VerifyCodeViewController.h"
#import "QRCodeReaderViewController.h"
#import "MBProgressHUD+Add.h"
#import "UIAlertView+TTBlock.h"
#import "HbPaySuccessViewController.h"
#import "StoryBoardUtilities.h"
#import "UIBarButtonItem+Addition.h"
#import "CDealRecordInputViewController.h"
#import "YTHttpClient.h"

@interface VerifyCodeViewController ()
@property (strong, nonatomic)QRCodeReaderViewController *readerVC;
@end

@implementation VerifyCodeViewController

#pragma mark - Life cycle
- (void)dealloc
{
    [NOTIFICENTER removeObserver:self];
}
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"验证红包";
    self.view.backgroundColor =  CCCUIColorFromHex(0xeeeeee);
    
    _readerVC = [[QRCodeReaderViewController alloc] init];
    _readerVC.modalPresentationStyle = UIModalPresentationFormSheet;
    _readerVC.hidesBottomBarWhenPushed = YES;
    __weak typeof(self) weakSelf = self;
    [_readerVC setCompletionWithBlock:^(NSString* resultAsString) {
        [weakSelf setupScanResultString:resultAsString];
    }];
    [_readerVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self addChildViewController:self.readerVC];
    [self.view addSubview:self.readerVC.view];
    [self.readerVC didMoveToParentViewController:self];
    
    UIImage *image = [UIImage imageNamed:@"face_pay_inputNumber.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:image highlightImage:image target:self action:@selector(readerRightBarButtonItemAction:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)setupScanResultString:(NSString*)string
{
    
    if ([self.delegate respondsToSelector:@selector(verifyCodeViewController:didverifyResult:)]) {
        [_delegate verifyCodeViewController:self didverifyResult:string];
    }
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)scanningFail:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
    wSelf(wSelf);
    [alert setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [wSelf.readerVC startScanning];
        }
    }];
    [alert show];

}
#pragma mark - Navigation
- (void)readerRightBarButtonItemAction:(id)sender
{
    CDealRecordInputViewController *dealRecordInputVC = [[CDealRecordInputViewController alloc] init];
    dealRecordInputVC.inputMode = DealRecordInputModeVerify;
    [self.navigationController pushViewController:dealRecordInputVC animated:YES];
}
@end
