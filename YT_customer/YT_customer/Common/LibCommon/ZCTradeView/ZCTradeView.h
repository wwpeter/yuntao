//
//  ZCTradeView.h
//  直销银行
//
//  Created by 塔利班 on 15/4/30.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//  交易密码视图\负责整个项目的交易密码输入

#import <UIKit/UIKit.h>

@class ZCTradeKeyboard;

@protocol ZCTradeViewDelegate <NSObject>

@optional
/** 输入完成点击确定按钮 */
- (NSString *)finish:(NSString *)pwd;

@end

@interface ZCTradeView : UIView

@property (nonatomic, weak) id<ZCTradeViewDelegate> delegate;
@property (nonatomic, copy) NSString *inputTitle;
/** 完成的回调block */
@property (nonatomic, copy) void (^finish) (NSString *passWord);

/** 快速创建 */
+ (instancetype)tradeView;
- (instancetype)initWithInputTitle:(NSString *)inputTitle frame:(CGRect)frame;

/** 弹出 */
- (void)show;
- (void)showInView:(UIView *)view;

@end
 