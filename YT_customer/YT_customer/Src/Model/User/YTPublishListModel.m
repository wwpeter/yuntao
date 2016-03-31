//
//  YTPublishListModel.m
//  YT_customer
//
//  Created by chun.chen on 15/12/10.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTPublishListModel.h"

@implementation YTPublish
+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"id" : @"pId" }];
}
- (NSAttributedString*)nameAttributedString
{
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@店的红包", self.shop.name]];
    if (self.hongbaoLx != YTDistributeHongbaoTypePsqhb) {
        return [[NSAttributedString alloc] initWithAttributedString:attString];
    }
    UIImage* image = [UIImage imageNamed:@"distribute_moneyHb_pin.png"];
    NSTextAttachment* textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(2, -3, image.size.width, image.size.height);
    NSAttributedString* luckAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attString appendAttributedString:luckAttachmentString];
    return [[NSAttributedString alloc] initWithAttributedString:attString];
}
@end

@implementation YTPublishSet

@end

@implementation YTPublishListModel
+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"data" : @"publishSet" }];
}
@end
