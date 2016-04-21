//
//  YTPickerView.h
//  YT_business
//
//  Created by chun.chen on 15/7/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^pickerViewDoneBlock)();

@interface YTPickerView : UIView

@property (copy, nonatomic)pickerViewDoneBlock actionBlock;

@property (strong, nonatomic)NSArray *pickerData;
@property (assign, nonatomic)NSInteger selectIndex;
@property (assign, nonatomic)BOOL display;

@property (strong, nonatomic) UIPickerView *pickerView;

- (instancetype)initWithPickerPickerData:(NSArray *)pickerData frame:(CGRect)frame;
- (void)showInView:(UIView *)view;
- (void)hidePicker;

@end
