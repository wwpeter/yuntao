//
//  PaySuccessViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/6/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaySuccessModel;
@interface PaySuccessViewController : UIViewController

@property (strong, nonatomic) PaySuccessModel* paySuccessModel;
typedef NS_ENUM(NSInteger, ReceiveType) {
    /**< 未领取*/
    NoReceive,
    /**< 已领取*/
    HadReceive
};

@property (strong, nonatomic) NSString* orderStr;
@property (strong, nonatomic) NSNumber* orderId;
@property (strong, nonatomic) NSArray* passArr;
@property (assign, nonatomic) ReceiveType receiveType;
@property (assign, nonatomic) BOOL hiddenLeftBtn;
@end
