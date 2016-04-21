//
//  YTCityAreaPickerView.h
//  YT_business
//
//  Created by chun.chen on 15/9/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTLocation;

typedef void(^AreaDidChangeBlock)(YTLocation *locate);

@interface YTCityAreaPickerView : UIView
@property (strong, nonatomic)YTLocation *locate;
@property (assign, nonatomic)BOOL display;
@property (copy, nonatomic) AreaDidChangeBlock areaDidChangeBlock;

- (void)showAreaPickerView;
- (void)hideAreaPickerView;

@end


@interface YTLocation : NSObject

@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *street;
@property (assign, nonatomic) long zoneId;
@end
