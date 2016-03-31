//
//  YTPlaceTextView.h
//  YT_customer
//
//  Created by chun.chen on 15/8/2.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YTPlaceTextViewDelegate;

@interface YTPlaceTextView : UIView<UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel* placeLabel;
@property (copy, nonatomic) NSString *placeholder;
@property (weak, nonatomic) id<YTPlaceTextViewDelegate>delegate;
@end


@protocol YTPlaceTextViewDelegate <NSObject>
@optional
- (void)placeTextView:(YTPlaceTextView *)view textViewShouldBeginEditing:(UITextView *)textView;
- (void)placeTextView:(YTPlaceTextView *)view textViewShouldEndEditing:(UITextView *)textView;
- (void)placeTextView:(YTPlaceTextView *)view textViewDidEndEditing:(UITextView *)textView;
@end