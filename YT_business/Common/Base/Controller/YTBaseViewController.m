//
//  IMBaseViewController.m
//  iMei
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import "YTHttpClient.h"
#import "YTBaseViewController.h"
#import "UIViewController+Login.h"
#import "MBProgressHUD+Add.h"

@interface YTBaseViewController ()

@end

@implementation YTBaseViewController
@synthesize requestURL;
@synthesize showBackBtn;

static char *btnClickAction;

- (id)init {
    if (self = [super init]) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self actionPrepareUIComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -actionLoginAfter
- (void)actionLoginAfter {
    // subclass can override
}

#pragma mark -actionPrepareUIComponents
- (void)actionPrepareUIComponents {
    self.view.backgroundColor = [UIColor hexFloatColor:@"f1f1f1"];
}

#pragma mark -actionCustomLeftBtnWithNrlImage
- (void)actionCustomLeftBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                  title:(NSString *)title
                                 action:(void(^)())btnClickBlock {
    
    self.navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    objc_setAssociatedObject(self.navLeftBtn, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self actionCustomNavBtn:self.navLeftBtn nrlImage:nrlImage htlImage:hltImage title:title];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navLeftBtn];
}

#pragma mark -actionCustomRightBtnWithNrlImage
- (void)actionCustomRightBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                   title:(NSString *)title
                                  action:(void(^)())btnClickBlock {
    self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    objc_setAssociatedObject(self.navRightBtn, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self actionCustomNavBtn:self.navRightBtn nrlImage:nrlImage htlImage:hltImage title:title];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
}

#pragma mark -actionCustomNavBtn
- (void)actionCustomNavBtn:(UIButton *)btn nrlImage:(NSString *)nrlImage
                  htlImage:(NSString *)hltImage
                     title:(NSString *)title {
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:nrlImage] forState:UIControlStateNormal];
    if (![NSStrUtil isEmptyOrNull:hltImage]) {
        [btn setBackgroundImage:[UIImage imageNamed:hltImage] forState:UIControlStateHighlighted];
    } else {
        [btn setBackgroundImage:[UIImage imageNamed:nrlImage] forState:UIControlStateNormal];
    }
    if (![NSStrUtil isEmptyOrNull:title]) {
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
    }
    [btn sizeToFit];
    [btn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -actionBtnClick
- (void)actionBtnClick:(UIButton *)btn {
    void (^btnClickBlock) (void) = objc_getAssociatedObject(btn, &btnClickAction);
    if (btnClickBlock) {
        btnClickBlock();
    }
}

#pragma mark -actionFetchRequest
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
    // subClass can override
}

#pragma mark -getter or setter
- (void)setItemTitle:(NSString *)title {
    _itemTitle = title;
    self.navigationItem.title = _itemTitle;
}

- (void)setShowBackBtn:(BOOL)showBack {
    __weak typeof(self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"yt_navigation_backBtn_normal" htlImage:@"yt_navigation_backBtn_high" title:nil action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setRequestURL:(NSString *)url {
    requestURL = url;
    BOOL showLoading = [[self.requestParas objectForKey:loadingKey] boolValue];
    if (showLoading) {
        [MBProgressHUD showMessag:@"请稍后..." toView:self.view];
    }
    __weak typeof(self) wSelf = self;
    AFHTTPRequestOperation *operation = [[YTHttpClient client] requestWithURL:url
                                                                        paras:self.requestParas
                                                                      success:^(AFHTTPRequestOperation *operation, NSObject *parserObject) {
                                                                          if (showLoading) {
                                                                              [MBProgressHUD hideHUDForView:wSelf.view animated:YES];
                                                                          }
                                                                          
                                                                          YTBaseModel *responseModel = (YTBaseModel *)parserObject;
                                                                          if ([responseModel.resultCode isEqualToString:@"NOT_LOGIN"]) {
                                                                              [wSelf authFromLoginWithReqURL:requestURL];
                                                                          } else {
                                                                              // callback
                                                                              [wSelf actionFetchRequest:operation
                                                                                                 result:responseModel
                                                                                                  error:nil];
                                                                          }
                                                                      }
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *requestErr) {
                                                                          if (showLoading) {
                                                                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                          }
                                                                          [wSelf actionFetchRequest:operation result:nil error:requestErr];
                                                                      }];
    if (self.usrInfo) {
        operation.userInfo = self.usrInfo;
    }
}

#pragma mark -doLogin
- (void)authFromLoginWithReqURL:(NSString *)reqURL {
    
}

#pragma mark -cancelLoginEvent
- (void)cancelLoginEvent {
    
}

@end
