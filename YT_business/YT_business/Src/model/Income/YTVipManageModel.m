//
//  YTVipManageModel.m
//  YT_business
//
//  Created by chun.chen on 15/12/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTVipManageModel.h"

@implementation YTVipManage
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"vipId":@"id"};
}
- (NSAttributedString*)sendAttributedString
{
    NSString* send = [NSString stringWithFormat:@"%@",@(self.totalNum)];
    NSString* read = [NSString stringWithFormat:@"%@",@(self.readNum)];
    NSString* fullText = [NSString stringWithFormat:@"发送%@人  已读%@人", send, read];
    NSRange sendRange = NSMakeRange(2, send.length);
    NSRange readRange = NSMakeRange(fullText.length - 1 - read.length, read.length);
    
    NSMutableAttributedString* mutableAttributedStr =
    [[NSMutableAttributedString alloc]
     initWithString:fullText];
    
    [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:sendRange];
    [mutableAttributedStr addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:15]
                                 range:sendRange];
    
    [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:readRange];
    [mutableAttributedStr addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:15]
                                 range:readRange];
    return [[NSAttributedString alloc] initWithAttributedString:mutableAttributedStr];
}
- (NSAttributedString*)nameAttributedString
{
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@店的红包",[YTUsr usr].shop.name]];
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

@implementation YTVipManageSet


@end

@implementation YTVipManageModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"manageSet":@"data"};
}
@end
