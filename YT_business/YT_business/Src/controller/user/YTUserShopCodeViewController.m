#import "YTUserShopCodeViewController.h"
#import "CIFilterEffect.h"
#import "MBProgressHUD+Add.h"
#import "YTUpdateShopInfoModel.h"
#import "UIActionSheet+TTBlock.h"
#import "RESideMenu.h"
#import "UIBarButtonItem+Addition.h"
#import "UIImage+HBClass.h"

@interface YTUserShopCodeViewController ()

@property (strong, nonatomic) UIImageView* qrcodeImageView;
@property (strong, nonatomic) UIActivityIndicatorView* activityIndicator;
@end

@implementation YTUserShopCodeViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"二维码";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoSideLefttarget:self action:@selector(presentLeftMenuViewController:)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializePageSubviews];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -fetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    [self.activityIndicator stopAnimating];
    if (parserObject.success) {
        YTUpdateShopInfoModel* shopModel = (YTUpdateShopInfoModel*)parserObject;
        _qrcodeImageView.image = [self shopCodeImageWithCodeString:shopModel.shopInfo.shopHtmlUrl];
        [YTUsr usr].shop.shopHtmlUrl = shopModel.shopInfo.shopHtmlUrl;
    }
    else {
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
}
#pragma mark - Private methods
- (void)fetchQrCodeData
{
    [self.activityIndicator startAnimating];
    self.requestParas = @{ @"shopId" : [YTUsr usr].shop.shopId };
    self.requestURL = shopInfoURL;
}
- (UIImage *)shopCodeImageWithCodeString:(NSString *)codeStr
{
    UIImage*qrImage = [[[CIFilterEffect alloc] initWithQRCodeString:codeStr width:200] qrCodeImage];
    UIImage *logoImage = [UIImage imageNamed:@"yt_logo_60.png"];
    UIImage *codeImage = [UIImage addWatermarkImage:logoImage backgroundImage:qrImage];
    return codeImage;
}
- (void)codeViewlongpressed:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"保存二维码" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存" otherButtonTitles:nil];
        __weak __typeof(self) weakSelf = self;
        [sheet setCompletionBlock:^(UIActionSheet* alertView, NSInteger buttonIndex) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (buttonIndex == 0) {
                UIImageWriteToSavedPhotosAlbum(strongSelf.qrcodeImageView.image, strongSelf,
                    @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        }];
        [sheet showInView:self.view];
    }
    else if (sender.state == UIGestureRecognizerStateBegan) {
    }
}
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    NSString* hudText = error ? @"图片保存失败" : @"保存成功";
    [MBProgressHUD alertMessage:hudText autoDisappear:YES parentView:self.view afterDelay:2.5f font:[UIFont systemFontOfSize:15] mode:MBProgressHUDModeText animationType:MBProgressHUDAnimationFade];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    UIView* codeView = [[UIView alloc] init];
    codeView.clipsToBounds = YES;
    codeView.backgroundColor = [UIColor whiteColor];
    codeView.layer.masksToBounds = YES;
    codeView.layer.borderWidth = 1;
    UIColor* ccColor = CCCUIColorFromHex(0xcccccc);
    codeView.layer.borderColor = [ccColor CGColor];
    codeView.layer.cornerRadius = 3.0;
    [self.view addSubview:codeView];

    UIImageView* horizontalLine = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [codeView addSubview:horizontalLine];

    UILabel* messageLabel = [[UILabel alloc] init];
    messageLabel.font = [UIFont systemFontOfSize:16];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 1;
    messageLabel.text = @"我的商户二维码";
    [codeView addSubview:messageLabel];
    [codeView addSubview:self.qrcodeImageView];
    [codeView addSubview:self.activityIndicator];

    [codeView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(codeView.height);
    }];

    [messageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.top.mas_equalTo(codeView);
        make.height.mas_equalTo(50);
    }];
    [horizontalLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(codeView);
        make.top.mas_equalTo(50);
        make.height.mas_equalTo(1);
    }];
    [_qrcodeImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.mas_equalTo(codeView);
        make.centerY.mas_equalTo(codeView).offset(25);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.mas_equalTo(_qrcodeImageView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    NSString* qrStr = [YTUsr usr].shop.shopHtmlUrl;
    if ([NSStrUtil isEmptyOrNull:qrStr]) {
        [self fetchQrCodeData];
    }
    else {
        _qrcodeImageView.image = [self shopCodeImageWithCodeString:qrStr];
    }

    UILongPressGestureRecognizer* longgesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(codeViewlongpressed:)];
    [longgesture setMinimumPressDuration:1];
    [codeView addGestureRecognizer:longgesture];
}

- (UIImageView*)qrcodeImageView
{
    if (!_qrcodeImageView) {
        _qrcodeImageView = [[UIImageView alloc] init];
        _qrcodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _qrcodeImageView;
}
- (UIActivityIndicatorView*)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}
@end
