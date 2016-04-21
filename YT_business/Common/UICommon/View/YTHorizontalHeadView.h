//
//  YTHorizontalHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/12/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YTNumerical <NSObject>
@end

@interface YTHorizontalHeadView : UIView

@property (nonatomic, copy) NSArray<YTNumerical>* numercals;
@property (nonatomic)BOOL displayTopLine;

- (instancetype)initWithNumercals:(NSArray<YTNumerical>*)numercals;
- (void)reloadNumercals:(NSArray<YTNumerical>*)numercals;
@end

@interface YTNumerical : NSObject

@property (nonatomic, copy) NSString* caption;
@property (nonatomic, copy) NSString* message;
- (instancetype)initWithCaption:(NSString*)caption message:(NSString*)message;

@end

@protocol YTHorizontalHeadViewDelegate <NSObject>

- (NSUInteger)numberOfNumericalsInHorizontalHeadView:(YTHorizontalHeadView*)headView;
- (id<YTNumerical>)horizontalHeadView:(YTHorizontalHeadView*)headView numercalAtIndex:(NSUInteger)index;

@end