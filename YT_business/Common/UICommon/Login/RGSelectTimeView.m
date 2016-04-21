
#import "UIImage+HBClass.h"
#import "RGSelectTimeView.h"
#import "YTRegisterHelper.h"

#define RGTopColor CCCUIColorFromHex(0xfa5e66)

static NSString *CellIdentifier = @"MyRGSelectTimeCellIdentifier";

static const NSInteger kTopViewHeight = 44;
static const NSInteger kSelectViewHeight = 200;
static const NSInteger kLeftWidth = 100;
static const NSInteger kDefaultRowHeight = 50;
static const NSInteger kSelectButtonTag = 1000;
static const NSInteger kStartDatePickerTag = 2000;
static const NSInteger kEndDatePickerTag = 20001;

@interface RGSelectTimeView ()
<
UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate
>

@property (strong, nonatomic) UIView *selectView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *rightView;

@property (strong, nonatomic) UITableView *dayTableView;
@property (strong, nonatomic) UIButton *selectButton;
@property (strong, nonatomic) UIDatePicker *startDatePicker;
@property (strong, nonatomic) UIDatePicker *endDatePicker;

@property (strong, nonatomic) NSArray *leftSelects;
@property (strong, nonatomic) NSArray *weekDays;

@end

@implementation RGSelectTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
        self.days = [[NSMutableArray alloc] initWithCapacity:7];
        self.leftSelects = @[@"营业时间",@"开门时间",@"打烊时间"];
        self.weekDays = @[@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六",@"每周日"];
        [self initializeSubView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleSingleTap:)];
        singleTap.delegate = self;
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return _weekDays.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *day = _weekDays[indexPath.row];
    cell.textLabel.text = day;
    for (NSString *str in _days) {
        if ([day isEqualToString:str]) {
            cell.accessoryType =  UITableViewCellAccessoryCheckmark;
            break;
        } else {
            cell.accessoryType =  UITableViewCellAccessoryNone;
        }
    }
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *day = _weekDays[indexPath.row];
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    selectCell.tintColor = [UIColor redColor];
    if (selectCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        selectCell.accessoryType =  UITableViewCellAccessoryNone;
        [_days removeObject:day];
    } else {
        selectCell.accessoryType =  UITableViewCellAccessoryCheckmark;
        [_days addObject:day];
    }
    if (self.opendaysBlock) {
        NSMutableArray *valueArr = [NSMutableArray arrayWithCapacity:_days.count];
        [_days sortUsingSelector:@selector(compare:)];
        for (NSString *dateStr in _days) {
            if ([dateStr isEqualToString:@"每周一"]) {
                [valueArr addObject:@"周一"];
            } else if ([dateStr isEqualToString:@"每周二"]) {
                [valueArr addObject:@"周二"];
            } else if ([dateStr isEqualToString:@"每周三"])  {
                [valueArr addObject:@"周三"];
            } else if ([dateStr isEqualToString:@"每周四"])  {
                [valueArr addObject:@"周四"];
            } else if ([dateStr isEqualToString:@"每周五"])  {
                [valueArr addObject:@"周五"];
            } else if ([dateStr isEqualToString:@"每周六"])  {
                [valueArr addObject:@"周六"];
            } else if ([dateStr isEqualToString:@"每周日"])  {
                [valueArr addObject:@"周日"];
            }
        }
        if (valueArr.count == 1) {
            self.opendaysBlock(valueArr.lastObject);
        } else if (valueArr.count > 1) {
            self.opendaysBlock([valueArr componentsJoinedByString:@","]);
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_dayTableView]) {
        return NO;
    }
    return YES;
}
#pragma mark - Event response
- (void)selectButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == _selectButton.tag) {
        return;
    } else {
        button.selected = YES;
        _selectButton.selected = NO;
        _selectButton = button;
        [self showRightViewWithButtonTag:button.tag];
    }
}
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    [self hideSelectTimeView];
}
-(void)dateChanged:(UIDatePicker *)picker{
    NSDate *date = picker.date;
    BOOL startTime = NO;
    NSString *timeStr = [YTTaskHandler outDateStrWithTimeStamp:[date timeIntervalSince1970]*1000 withStyle:@"HH:mm"];
    if (picker == self.startDatePicker) {
        startTime = YES;
//        if ([YTRegisterHelper registerHelper].endTime && (timeStr.intValue < [YTRegisterHelper registerHelper].startTime.intValue)) {
//            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"结束时间不能小于开始时间,请重新选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//            return ;
//        }
    } else {
//        if (timeStr.intValue < [YTRegisterHelper registerHelper].startTime.intValue) {
//            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"结束时间不能小于开始时间,请重新选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//            return ;
//        }
    }
    if (self.opentimeBlock) {
        self.opentimeBlock(startTime,timeStr);
    }
}
#pragma mark - Public methods
- (void)showSelectTimeView
{
    self.alpha = 1;
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    CGRect rect = _selectView.frame;
    rect.origin.y = CGRectGetHeight(self.frame)-kTopViewHeight-kSelectViewHeight;
    [UIView animateWithDuration:.3f animations:^{
        _selectView.frame = rect;
    }];
}
- (void)hideSelectTimeView
{
    CGRect rect = _selectView.frame;
    rect.origin.y = CGRectGetHeight(self.frame);
    [UIView animateWithDuration:.3f animations:^{
        _selectView.frame = rect;
        self.alpha = 0;
    }];
}
- (void)showRightViewWithButtonTag:(NSInteger)tag
{
    if (tag == kSelectButtonTag) {
        _dayTableView.hidden = NO;
        _startDatePicker.hidden = _endDatePicker.hidden = YES;
        
    } else if (tag == kSelectButtonTag +1 ) {
        _startDatePicker.hidden = NO;
        _dayTableView.hidden = _endDatePicker.hidden = YES;
    } else {
        _endDatePicker.hidden = NO;
         _dayTableView.hidden = _startDatePicker.hidden = YES;
    }
}
#pragma mark - Private methods
- (void)cancelButtonClicked:(id)sender
{
    [self hideSelectTimeView];
}
- (void)doneButtonClicked:(id)sender
{
    [self hideSelectTimeView];
}
#pragma mark - Page Subviews
- (void)initializeSubView
{
    _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kTopViewHeight+kSelectViewHeight)];
    _selectView.backgroundColor = CCCUIColorFromHex(0xf8f8f8);
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kTopViewHeight)];
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight, kLeftWidth, kSelectViewHeight)];
    _rightView = [[UIView alloc] initWithFrame:CGRectMake(kLeftWidth, kTopViewHeight,CGRectGetWidth(self.bounds)-kLeftWidth,kSelectViewHeight)];
    [self addSubview:_selectView];
    [_selectView addSubview:_topView];
    [_selectView addSubview:_leftView];
    [_selectView addSubview:_rightView];
    [self setupTopView];
    [self setupLeftView];
    [self setupRightView];
}
- (void)setupTopView
{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 80, kTopViewHeight);
    [cancelBtn setTitleColor:RGTopColor forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:cancelBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)-80, 0, 80, kTopViewHeight);
    [doneBtn setTitleColor:RGTopColor forState:UIControlStateNormal];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:doneBtn];
}
- (void)setupLeftView
{
    for (NSInteger i = 0; i<_leftSelects.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, i*kDefaultRowHeight, kLeftWidth, kDefaultRowHeight);\
        button.tag = i + kSelectButtonTag;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:_leftSelects[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xf8f8f8)] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_leftView addSubview:button];
        if (i == 0) {
            button.selected = YES;
            _selectButton = button;
        }
    }
}

#pragma mark - Setter & Getter
- (void)setupRightView
{
    [_rightView addSubview:self.startDatePicker];
      [_rightView addSubview:self.endDatePicker];
    [_rightView addSubview:self.dayTableView];
}

- (UITableView *)dayTableView
{
    if (!_dayTableView) {
        _dayTableView = [[UITableView alloc] initWithFrame:_rightView.bounds];
        _dayTableView.delegate = self;
        _dayTableView.dataSource = self;
        _dayTableView.rowHeight = kDefaultRowHeight;
        [_dayTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _dayTableView;
}
- (UIDatePicker *)startDatePicker
{
    if (!_startDatePicker) {
        _startDatePicker = [[UIDatePicker alloc] initWithFrame:_rightView.bounds];
        _startDatePicker.tag = kStartDatePickerTag;
        _startDatePicker.datePickerMode = UIDatePickerModeTime;
        _startDatePicker.backgroundColor = [UIColor whiteColor];
        [_startDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        _startDatePicker.hidden = YES;
    }
    return _startDatePicker;
}
- (UIDatePicker *)endDatePicker
{
    if (!_endDatePicker) {
        _endDatePicker = [[UIDatePicker alloc] initWithFrame:_rightView.bounds];
        _endDatePicker.tag = kEndDatePickerTag;
        _endDatePicker.backgroundColor = [UIColor whiteColor];
        _endDatePicker.datePickerMode = UIDatePickerModeTime;
        [_endDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        _endDatePicker.hidden = YES;
    }
    return _endDatePicker;
}

@end
