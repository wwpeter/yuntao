//
//  CSearchTextView.m
//  YT_customer
//
//  Created by chun.chen on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "CSearchTextView.h"

@implementation CSearchTextView

- (instancetype)init
{
    self = [super init];
    if (!self)
        return nil;
    [self configSubViews];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    [self configSubViews];
    return self;
}

#pragma mark -UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchTextView:textFieldShouldBeginEditing:)]) {
        [_delegate searchTextView:self textFieldShouldBeginEditing:textField];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchTextView:textFieldDidBeginEditing:)]) {
        [_delegate searchTextView:self textFieldDidBeginEditing:textField];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchTextView:textFieldShouldEndEditing:)]) {
        [_delegate searchTextView:self textFieldShouldEndEditing:textField];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchTextView:textFieldDidEndEditing:)]) {
        [_delegate searchTextView:self textFieldDidEndEditing:textField];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(searchTextView:shouldChangeCharactersInRange:replacementString:)]) {
        [_delegate searchTextView:self shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchTextView:textFieldShouldClear:)]) {
        [_delegate searchTextView:self textFieldShouldClear:textField];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchTextView:textFieldShouldReturn:)]) {
        [_delegate searchTextView:self textFieldShouldReturn:textField];
    }
    return YES;
}

#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.searchField];
    [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
#pragma mark - Setter & Getter
- (UITextField *)searchField
{
    if (!_searchField) {
        _searchField = [[UITextField alloc] init];
        _searchField.tintColor = [UIColor redColor];
        _searchField.borderStyle = UITextBorderStyleNone;
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.enablesReturnKeyAutomatically = YES;
        _searchField.placeholder = @"搜索";
        _searchField.delegate = self;
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIImageView* searchLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 18)];
        searchLeftImageView.image = [UIImage imageNamed:@"yt_searchIcon.png"];
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        _searchField.leftView = searchLeftImageView;
    }
    return _searchField;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}


@end
