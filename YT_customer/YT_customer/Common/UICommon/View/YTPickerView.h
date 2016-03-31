//
//  YTPickerView.h
//  YT_customer
//
//  Created by chun.chen on 15/12/16.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
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
