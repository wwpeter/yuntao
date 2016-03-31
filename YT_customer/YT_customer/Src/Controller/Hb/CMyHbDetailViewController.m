#import "CMyHbDetailViewController.h"
#import "HbDetailModel.h"
#import "UIView+DKAddition.h"
#import "NSStrUtil.h"
#import "HbDetailRuleView.h"
#import "UIImageView+WebCache.h"
#import "PromotionHbStatsView.h"
#import "CHbDetailAddressView.h"
#import "CHbDetailQrCodeView.h"
#import "UIImageView+WebCache.h"
#import "YTYellowBackgroundView.h"
#import "MBProgressHUD+Add.h"
#import "YTNetworkMange.h"
#import "CIFilterEffect.h"
#import "ShareActionView.h"
#import "HbDetailHeadView.h"
#import "HbDetailNotesView.h"
#import "UIActionSheet+TTBlock.h"
#import <MapKit/MapKit.h>
#import "UIViewController+Helper.h"

static const NSInteger kDefaultTopPadding = 15;

@interface CMyHbDetailViewController () <UIActionSheetDelegate>
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) YTYellowBackgroundView* yellowView;

@end

@implementation CMyHbDetailViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_hbtype == HbDetailTypeMyHb) {
        [self loadMyHbDetailData];
    }else {
        if (_detailModel) {
            [self initializePageSubviews];
        }else{
            [self loadHbDetailData];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Data
- (void)loadHbDetailData
{
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    NSDictionary* parameters = @{ @"hongbaoId" : self.hbId };
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_HongbaoInfo
                                                parameters:parameters
                                                   success:^(id responseData) {
                                                       __strong __typeof(weakSelf) strongSelf = weakSelf;
                                                       strongSelf.detailModel = [[HbDetailModel alloc] initWithHbDetailDictionary:responseData[@"data"]];
                                                       [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                                                       [strongSelf initializePageSubviews];
                                                   }
                                                   failure:^(NSString* errorMessage) {
                                                       [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                       [MBProgressHUD showError:errorMessage toView:weakSelf.view];
                                                   }];
}
- (void)loadMyHbDetailData
{
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    NSDictionary* parameters = @{ @"id" : self.hbId };
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_MyHongbaoDetail
        parameters:parameters
        success:^(id responseData) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.detailModel = [[HbDetailModel alloc] initWithHbDetailDictionary:responseData[@"data"]];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf initializePageSubviews];
        }
        failure:^(NSString* errorMessage) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [MBProgressHUD showError:errorMessage toView:weakSelf.view];
        }];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
#pragma mark - Private methods
// 拨打电话
- (void)callPhoneNumber:(NSString*)phoneNum
{
    UIWebView* callWebview = [[UIWebView alloc] init];
    NSString* callString = [NSString stringWithFormat:@"tel:%@", phoneNum];
    NSURL* telURL = [NSURL URLWithString:callString];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
- (void)shareHbWithUrl:(NSString*)url
{
    NSString *shareText = [NSString stringWithFormat:@"送你一张%@的%@，赶快来抢吧",_detailModel.shopName,_detailModel.hbName];
    ShareDataModel* shareData = [[ShareDataModel alloc] initWithTitle:@"云淘红包-淘品质超值大红包 " url:url imageUrl:_detailModel.imageUrl shareText:shareText];
    [ShareActionView showShareMenuWithSheetView:self title:@"赶紧转赠给好友吧~" shareData:shareData selectedHandle:NULL];
}
- (void)shopNavi
{
    CLLocationCoordinate2D to = CLLocationCoordinate2DMake(self.detailModel.latitude, self.detailModel.longitude);
    [self openNavigation:to destinationNamen:self.detailModel.shopName];
}
// 红包详情信息
- (void)setupDeatilView
{
    CGFloat detailMaxWidth = CGRectGetWidth(self.scrollView.bounds);
    HbDetailHeadView* headView = nil;
    if (_hbtype == HbDetailTypeMyHb) {
        headView = [[HbDetailHeadView alloc] initWithDisplayTime:YES frame:CGRectMake(0, 0, detailMaxWidth, 200 + 70 + 35)];
    }
    else {
        headView = [[HbDetailHeadView alloc] initWithDisplayTime:NO frame:CGRectMake(0, 0, detailMaxWidth, 200 + 70)];
    }
    [headView configDetailHeadViewWithHongBao:self.detailModel];
    [self.scrollView addSubview:headView];

    // 地址
    CHbDetailAddressView* addressView = [[CHbDetailAddressView alloc] initWithFrame:CGRectMake(0, headView.dk_bottom + kDefaultTopPadding, detailMaxWidth, 100)];
    addressView.shopLabel.text = self.detailModel.shopName;
    addressView.addressLabel.text = self.detailModel.address;
    __weak __typeof(self) weakSelf = self;
    addressView.selectBlock = ^(NSInteger selectIndex) {
        if (selectIndex == 0) {
            [weakSelf callPhoneNumber:weakSelf.detailModel.phoneNum];
        }
        else {
            [weakSelf shopNavi];
        }
    };

    [self.scrollView addSubview:addressView];

    if (_hbtype == HbDetailTypeMyHb) {
        [self setupHbQrcodeViewWithTop:addressView.dk_bottom];
    }
    else {
        [self setupHbStateViewWithTop:addressView.dk_bottom];
    }
}
// 保存二维码
- (void)codeViewlongpressed:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"保存二维码" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存" otherButtonTitles:nil];
        __weak __typeof(self) weakSelf = self;
        [sheet setCompletionBlock:^(UIActionSheet* alertView, NSInteger buttonIndex) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (buttonIndex == 0) {
                UIImageWriteToSavedPhotosAlbum([strongSelf hongbaoQrCodeImage], strongSelf,
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

// 二维码
- (void)setupHbQrcodeViewWithTop:(CGFloat)top
{
    CHbDetailQrCodeView* codeView = [[CHbDetailQrCodeView alloc] initWithFrame:CGRectMake(0, top + kDefaultTopPadding, CGRectGetWidth(self.scrollView.bounds), 215)];
    codeView.serialLabel.text = self.detailModel.serialNumber;
    codeView.qrImageView.image = [self hongbaoQrCodeImage];
    
    UILongPressGestureRecognizer* longgesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(codeViewlongpressed:)];
    [longgesture setMinimumPressDuration:1];
    [codeView.qrImageView addGestureRecognizer:longgesture];
    
    [self.scrollView addSubview:codeView];

    [self setupHbStateViewWithTop:codeView.dk_bottom];
}
- (UIImage *)hongbaoQrCodeImage
{
    return [[[CIFilterEffect alloc] initWithQRCodeString:self.detailModel.qrCode width:130] qrCodeImage];
}
// 说明
- (void)setupHbStateViewWithTop:(CGFloat)top
{
    HbDetailNotesView* notesView = [[HbDetailNotesView alloc] initWithUsrHongBao:self.detailModel frame:CGRectMake(0, top + 15, CGRectGetWidth(self.scrollView.bounds), 0)];
    [notesView fitOptimumSize];
    [self.scrollView addSubview:notesView];
    self.scrollView.contentSize = CGSizeMake(0, notesView.dk_bottom + 100);
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    NSDictionary* parameters = @{ @"userHongbaoId" : self.hbId };

    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_GiveHongbao
        parameters:parameters
        success:^(id responseData) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf shareHbWithUrl:responseData[@"data"]];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        }
        failure:^(NSString* errorMessage) {

            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [MBProgressHUD showError:errorMessage toView:strongSelf.view];
        }];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.scrollView];
    [self setupDeatilView];
    if (_hbtype == HbDetailTypeMyHb && (_detailModel.hbStatus == HbIntroModelStatusUnuse || _detailModel.hbStatus == HbIntroModelStatusExpired)) {
        [self.view addSubview:self.yellowView];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"转赠" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
        if (_detailModel.hbStatus == HbIntroModelStatusExpired) {
            _yellowView.textLabel.text = @"使用超时,可转赠给好友";
        }
    }
}
#pragma mark - Getters & Setters
- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.contentSize = CGSizeMake(0, 1000);
    }
    return _scrollView;
}
- (YTYellowBackgroundView*)yellowView
{
    if (!_yellowView) {
        _yellowView = [[YTYellowBackgroundView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 40, kDeviceWidth, 40)];
        _yellowView.alpha = 0.9f;
        _yellowView.textLabel.text = @"向店员出示二维码";
    }
    return _yellowView;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif

@end
