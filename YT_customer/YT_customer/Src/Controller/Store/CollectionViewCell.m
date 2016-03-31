//
//  CollectionViewCell.m
//  YT_customer
//
//  Created by mac on 16/2/17.
//  Copyright © 2016年 sairongpay. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-5, frame.size.height+5)]; // 让imageView和当前item一样大
        // 设置边框
        self.photoImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.photoImageView.layer.borderWidth = 0.0;
        [self.contentView addSubview:self.photoImageView];
    }
    return self;
}

@end
