#import "YTPickerView.h"
#import "XLFormRowNavigationAccessoryView.h"

@interface YTPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) XLFormRowNavigationAccessoryView * navigationAccessoryView;

@end

@implementation YTPickerView

- (instancetype)initWithPickerPickerData:(NSArray *)pickerData frame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        _pickerData = pickerData;
        _selectIndex = 0;
        [self configureSubview:frame];
    }
    return self;
}
#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 1.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectIndex = row;
}
#pragma mark - Public methods
- (void)showInView:(UIView *) view
{
    self.display = YES;
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)hidePicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         self.display = NO;
                         [self removeFromSuperview];
                         
                     }];
    
}

#pragma mark - Event response
- (void)doneButtonDidClicked:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
    [self hidePicker];
}

#pragma mark - subviews
-(void)configureSubview:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickerView];
    [self addSubview:self.navigationAccessoryView];
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 216)];
        _pickerView.delegate=self;
        _pickerView.dataSource = self;
        //    _locatePicker.showsSelectionIndicator=YES;
    }
    return _pickerView;
}
-(XLFormRowNavigationAccessoryView *)navigationAccessoryView
{
    if (_navigationAccessoryView) return _navigationAccessoryView;
    _navigationAccessoryView = [XLFormRowNavigationAccessoryView new];
    _navigationAccessoryView.doneButton.target = self;
    _navigationAccessoryView.doneButton.action = @selector(doneButtonDidClicked:);
    _navigationAccessoryView.tintColor = [UIColor redColor];
    [_navigationAccessoryView.previousButton setCustomView:[UIView new]];
    [_navigationAccessoryView.nextButton setCustomView:[UIView new]];
    return _navigationAccessoryView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
