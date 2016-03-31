//
//  ZHQMeConsumeModel.h
//  YT_customer
//
//  Created by 郑海清 on 15/6/15.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHQMeConsumeModel : NSObject
typedef enum : NSUInteger {
    WAITE_PAY = 1,/**<未付款*/
    PAYED,/**<已付款*/
    CANCEL,/**<撤销*/
    USER_PAY_REFUNDING,/**<退款中*/
    USER_PAY_REFUND_SUCCESS/**<退款成功*/
} UserPayStatus;

@property (strong, nonatomic) NSNumber *orderId;
@property (strong, nonatomic) NSString *consumeImg;
@property (strong, nonatomic) NSString *consumeId;
@property (strong, nonatomic) NSString *hbTitle;
@property (strong, nonatomic) NSNumber *price;
@property (assign, nonatomic) UserPayStatus hbPayStatus;
@property (strong, nonatomic) NSNumber *hbReceiveStatus;
@property (strong, nonatomic) NSString *hbReceiveStatusStr;
@property (strong, nonatomic) NSString *hbPayStatusStr;
@property (strong, nonatomic) NSDate *hbDate;


-(instancetype)initMeConsumeModelWithDictionary:(NSDictionary  *)dictionray;


@end
