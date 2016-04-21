//
//  OutWebViewController.h
//  YT_business
//
//  Created by chun.chen on 15/6/4.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutWebViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *urlStr;
@property (assign, nonatomic) BOOL showRight;
-(instancetype)initWithURL:(NSString *)urlStr title:(NSString *)title isShowRight:(BOOL)showRight;
@end
