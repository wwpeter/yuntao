//
//  ShareActionView.h
//  DangKe
//
//  Created by lv on 15/4/16.
//  Copyright (c) 2015年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

typedef void(^SGMenuActionHandler)(NSInteger index, NSString *name);

@interface ShareDataModel : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* imgUrl;
@property (nonatomic, copy) NSString* shareText;

- (instancetype)initWithTitle:(NSString*)title
                          url:(NSString*)url
                     imageUrl:(NSString*)imageUrl
                    shareText:(NSString*)sharetext;
@end

@interface ShareActionView : UIView <MFMessageComposeViewControllerDelegate>

/**
 *  获取单例
 */
+ (ShareActionView *)sharedActionView;

/**
 *  弹出分享列表
 *
 *  @param controller 来源controller
 *  @param title      分享弹狂标题
 *  @param shareData  分享数据源
 *  @param handler    点击回调
 */
+ (void)showShareMenuWithSheetView:(UIViewController *)controller
                             title:(NSString *)title
                             shareData:(ShareDataModel *)shareData
                    selectedHandle:(SGMenuActionHandler)handler;

/**
 *  自定弹出底部Grid
 *
 *  @param title      标题
 *  @param itemTitles 小标题
 *  @param images     图片
 *  @param handler    回调
 */
+ (void)showGridMenuWithTitle:(NSString *)title
                   itemTitles:(NSArray *)itemTitles
                       images:(NSArray *)images
               selectedHandle:(SGMenuActionHandler)handler;
/**
 *  短信分享
 *
 *  @param content        分享信息
 *  @param formController 来源
 */
- (void)sendMessageView:(NSString*)content
               formView:(UIViewController *)formController;
@end
