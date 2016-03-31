//
//  PaySuccessModel.m
//  YT_customer
//
//  Created by chun.chen on 15/6/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "PaySuccessModel.h"
#import "NSDate+Utilities.h"
#import "SingleHbModel.h"
#import "HbIntroModel.h"
#import "NSDictionary+SafeAccess.h"
#import "NSStrUtil.h"

@implementation PaySuccessModel

- (instancetype)initWithPaySuccessDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        self.orderId = dictionary[@"id"];
        self.orderCode = dictionary[@"toOuterId"];
        self.payStatus = [dictionary[@"status"] integerValue];
        self.reciveStatus = [dictionary[@"receiveStatus"] integerValue];
        NSDictionary *shopDic = dictionary[@"shop"];
        
        self.storeId = shopDic[@"shopId"];
        self.storeName = shopDic[@"name"];
        NSTimeInterval paytime = [dictionary[@"payTime"] doubleValue]/1000;
        self.consumeTime = [[NSDate dateWithTimeIntervalSince1970:paytime] stringWithFormat:@"yyyy-MM-dd hh:mm"];
        NSTimeInterval createtime = [dictionary[@"createdAt"] doubleValue]/1000;
        self.createTime = [[NSDate dateWithTimeIntervalSince1970:createtime] stringWithFormat:@"yyyy-MM-dd hh:mm"];
        
        self.storePhone =shopDic[@"mobile"];
        for (id object in shopDic[@"receiveableHongbao"])
        {
            HbIntroModel *single = [[HbIntroModel alloc]initWithHbIntroDictionary:object];
            [self.hbList addObject:single];
        }
        [self setMaxCostFromDic:shopDic[@"shopHongbaoRule"]];
       self.payStatusStr = [self setupPayStatusString];
    }
    return self;
}

-(instancetype)initWithPaySuccessDictionary:(NSDictionary *)dictionary showUserHB:(BOOL)show
{
    if (self = [super init]) {
        
        self.orderId = dictionary[@"id"];
        self.orderCode = dictionary[@"toOuterId"];
        self.message = [dictionary stringForKey:@"message"];
        self.payStatus = [dictionary[@"status"] integerValue];
        self.reciveStatus = [dictionary[@"receiveStatus"] integerValue];
        NSDictionary *shopDic = dictionary[@"shop"];
        
        self.storeId = shopDic[@"shopId"];
        self.storeName = shopDic[@"name"];
        self.storeImg = shopDic[@"img"];
        self.totalPrice =[dictionary[@"totalPrice"] integerValue];
        self.originPrice = [dictionary[@"originPrice"] integerValue];
         NSTimeInterval paytime = [dictionary[@"payTime"] doubleValue]/1000;
        self.consumeTime = [[NSDate dateWithTimeIntervalSince1970:paytime] stringWithFormat:@"yyyy-MM-dd hh:mm"];
        NSTimeInterval createtime = [dictionary[@"createdAt"] doubleValue]/1000;
        self.createTime = [[NSDate dateWithTimeIntervalSince1970:createtime] stringWithFormat:@"yyyy-MM-dd hh:mm"];
        self.storePhone =shopDic[@"mobile"];
        //        userHongbaos
        if (show) {
            for (id object in dictionary[@"userHongbaos"])
            {
                HbIntroModel *single = [[HbIntroModel alloc]initWithHbIntroDictionary:object];
                [self.hbList addObject:single];
            }
        }
        else
        {
            for (id object in dictionary[@"receiveableHongbao"])
            {
                HbIntroModel *single = [[HbIntroModel alloc]initWithHbIntroDictionary:object];
                [self.hbList addObject:single];
            }
        }

        self.maxCost = self.originPrice/100;
//        [self setMaxCostFromDic:shopDic[@"shopHongbaoRule"]];
        self.payStatusStr = [self setupPayStatusString];
    }
    return self;
}

-(void)setMaxCostFromDic:(NSString *)str
{
    if ([NSStrUtil isEmptyOrNull:str]) {
        self.maxCost = 0;
        return;
    }
    NSArray *a = [str componentsSeparatedByString:@"\""];
    NSArray *b = [a[3] componentsSeparatedByString:@":"];
    CGFloat manInt = [b[0] doubleValue];
    CGFloat songInt = [b[1] doubleValue];
    CGFloat costFloat = self.totalPrice/100.;
    self.maxCost = (songInt/manInt)*costFloat;
}
-(NSMutableArray *)hbList
{
    if (!_hbList) {
        _hbList = [[NSMutableArray alloc]init];
    }
    return _hbList;
}
- (NSString *)setupPayStatusString
{
    if (self.payStatus == UserPayModelStatusWaitePay) {
        return @"未付款";
    } else if (self.payStatus == UserPayModelStatusWaitePayed) {
        if (self.reciveStatus == 1) {
            return @"红包未领取";
        }
        else
        {
            return @"领取成功";
        }
        
    }else if (self.payStatus == UserPayModelStatusWaiteCancel) {
        return @"撤销付款";
    }else if (self.payStatus == UserPayModelStatusWaiteUserPayRefund) {
        return @"退款中";
    }else if (self.payStatus == UserPayModelStatusWaiteUserPayRefundSuccess) {
        return @"退款成功";
    }
    return @"";
}

@end
