//
//  IMBaseViewController.h
//  iMei
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTBaseModel.h"

@interface YTBaseViewController : UIViewController
@property (nonatomic, assign) BOOL showBackBtn;
@property (nonatomic,   copy) NSString *itemTitle;
@property (nonatomic,   copy) NSString *requestURL;
@property (nonatomic, strong) UIButton *navLeftBtn;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, strong) NSDictionary *usrInfo;
@property (nonatomic, strong) NSDictionary *requestParas;

// Subclass can override
- (void)actionCustomLeftBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                  title:(NSString *)title
                                 action:(void(^)())btnClickBlock;
- (void)actionCustomRightBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                   title:(NSString *)title
                                  action:(void(^)())btnClickBlock;
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr;
- (void)cancelLoginEvent;
@end
