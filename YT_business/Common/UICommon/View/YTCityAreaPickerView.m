#import "YTCityAreaPickerView.h"
#import "NSStrUtil.h"
#import "YTCityZoneMange.h"

static const NSInteger kTopViewHeight = 44;
static const NSInteger kPickerViewHeight = 216;

@implementation YTLocation

@end

@interface YTCityAreaPickerView () <UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIView* selectView;
@property (strong, nonatomic) UIView* topView;
@property (strong, nonatomic) UIPickerView* locatePicker;
@property (strong, nonatomic) NSArray* provinces;
@property (strong, nonatomic) NSArray* cities;
@property (strong, nonatomic) NSArray* areas;
@end
@implementation YTCityAreaPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.alpha = 0;
        self.provinces = [YTCityZoneMange allProvinces];
        self.cities = [[self.provinces objectAtIndex:0] objectForKey:@"next"];
        self.areas = [[self.cities objectAtIndex:0] objectForKey:@"next"];
        self.locate.state = [[self.provinces objectAtIndex:0] objectForKey:@"name"];
        self.locate.city = [[self.cities objectAtIndex:0] objectForKey:@"name"];
        if (self.areas.count > 0) {
            self.locate.district = [[self.areas objectAtIndex:0] objectForKey:@"name"];
            self.locate.zoneId = [[[self.areas objectAtIndex:0] objectForKey:@"id"] longValue];
        }
        else {
            self.locate.district = @"";
            self.locate.zoneId = [[[self.cities objectAtIndex:0] objectForKey:@"id"] longValue];
        }

        [self configureSubview:frame];
    }
    return self;
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
    case 0:
        return [self.provinces count];
        break;
    case 1:
        return [self.cities count];
        break;
    case 2:
        return [self.areas count];
        break;

    default:
        return 0;
        break;
    }
}
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    switch (component) {
    case 0:
        return [[self.provinces objectAtIndex:row] objectForKey:@"name"];
        break;
    case 1:
        return [[self.cities objectAtIndex:row] objectForKey:@"name"];
        break;
    case 2:
        if ([self.areas count] > 0) {
            return [[self.areas objectAtIndex:row] objectForKey:@"name"];
            break;
        }
    default:
        return @"";
        break;
    }
}
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
    case 0:
        self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"next"];
        [self.locatePicker selectRow:0 inComponent:1 animated:YES];
        [self.locatePicker reloadComponent:1];

        self.areas = [[self.cities objectAtIndex:0] objectForKey:@"next"];
        [self.locatePicker selectRow:0 inComponent:2 animated:YES];
        [self.locatePicker reloadComponent:2];

        self.locate.state = [[self.provinces objectAtIndex:row] objectForKey:@"name"];
        self.locate.city = [[self.cities objectAtIndex:0] objectForKey:@"name"];
        if ([self.areas count] > 0) {
            self.locate.district = [[self.areas objectAtIndex:0] objectForKey:@"name"];
            self.locate.zoneId = [[[self.areas objectAtIndex:0] objectForKey:@"id"] longValue];
        }
        else {
            self.locate.district = @"";
            self.locate.zoneId = [[[self.cities objectAtIndex:0] objectForKey:@"id"] longValue];
        }
        break;
    case 1:
        self.areas = [[self.cities objectAtIndex:row] objectForKey:@"next"];
        [self.locatePicker selectRow:0 inComponent:2 animated:YES];
        [self.locatePicker reloadComponent:2];

        self.locate.city = [[self.cities objectAtIndex:row] objectForKey:@"name"];
        if ([self.areas count] > 0) {
            self.locate.district = [[self.areas objectAtIndex:0] objectForKey:@"name"];
            self.locate.zoneId = [[[self.areas objectAtIndex:0] objectForKey:@"id"] longValue];
        }
        else {
            self.locate.district = @"";
            self.locate.zoneId = [[[self.cities objectAtIndex:row] objectForKey:@"id"] longValue];
        }
        break;
    case 2:
        if ([self.areas count] > 0) {
            self.locate.district = [[self.areas objectAtIndex:row] objectForKey:@"name"];
            self.locate.zoneId = [[[self.areas objectAtIndex:row] objectForKey:@"id"] longValue];
        }
        else {
            self.locate.district = @"";
        }
        break;
    default:
        break;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    if ([touch.view isDescendantOfView:self.selectView]) {
        return NO;
    }
    return YES;
}
#pragma mark - Public methods
- (void)showAreaPickerView
{
    self.alpha = 1;
    self.display = YES;
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    CGRect rect = _selectView.frame;
    rect.origin.y = CGRectGetHeight(self.frame) - kTopViewHeight - kPickerViewHeight - 64;
    [UIView animateWithDuration:.3f
                     animations:^{
                         _selectView.frame = rect;
                     }];
}
- (void)hideAreaPickerView
{
    CGRect rect = _selectView.frame;
    rect.origin.y = CGRectGetHeight(self.frame);

    [UIView animateWithDuration:0.3f
        animations:^{
            _selectView.frame = rect;

        }
        completion:^(BOOL finished) {
            self.alpha = 0;
            self.display = NO;

        }];
}

#pragma mark - Event response
- (void)cancelButtonClicked:(id)sender
{
    [self hideAreaPickerView];
}
- (void)doneButtonClicked:(id)sender
{
    [self hideAreaPickerView];
    if ([NSStrUtil isEmptyOrNull:self.locate.district]) {
        self.locate.district = self.locate.city;
        self.locate.city = self.locate.state;
    }
    if (self.areaDidChangeBlock) {
        self.areaDidChangeBlock(self.locate);
    }
}
- (void)handleSingleTap:(UITapGestureRecognizer*)tap
{
    [self hideAreaPickerView];
}
#pragma mark - subviews
- (void)configureSubview:(CGRect)frame
{
    [self addSubview:self.selectView];
    [self.selectView addSubview:self.topView];
    [self.selectView addSubview:self.locatePicker];
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 80, kTopViewHeight);
    [cancelBtn setTitleColor:CCCUIColorFromHex(0xfa5e66) forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:cancelBtn];

    UIButton* doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 80, 0, 80, kTopViewHeight);
    [doneBtn setTitleColor:CCCUIColorFromHex(0xfa5e66) forState:UIControlStateNormal];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:doneBtn];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    [self addGestureRecognizer:singleTap];
}
#pragma mark - Setter & Getter
- (UIView*)selectView
{
    if (!_selectView) {
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kTopViewHeight + kPickerViewHeight)];
        _selectView.backgroundColor = [UIColor whiteColor];
    }
    return _selectView;
}
- (UIView*)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kTopViewHeight)];
        _topView.backgroundColor = CCCUIColorFromHex(0xf8f8f8);
    }
    return _topView;
}
- (UIPickerView*)locatePicker
{
    if (!_locatePicker) {
        _locatePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kTopViewHeight, CGRectGetWidth(self.bounds), kPickerViewHeight)];
        _locatePicker.delegate = self;
        _locatePicker.dataSource = self;
        //    显示选中框
        //        _locatePicker.showsSelectionIndicator=YES;
    }
    return _locatePicker;
}

- (YTLocation*)locate
{
    if (_locate == nil) {
        _locate = [[YTLocation alloc] init];
    }

    return _locate;
}

@end
