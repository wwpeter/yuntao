#import "VipManageDistributeView.h"
#import "UIView+DKAddition.h"

static NSString* CellIdentifier = @"VipManageCellIdentifier";
static const NSInteger kTableHeight = 200;

@interface VipManageDistributeView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, copy) NSArray* dataArr;
@end

@implementation VipManageDistributeView

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
#pragma mark - Public methods
- (void)show
{
    self.isShow = YES;
    self.hidden = NO;
    [UIView animateWithDuration:0.25f
        animations:^{
            _bgView.alpha = 1.0;
            _tableView.dk_y = self.dk_bottom - kTableHeight;
        }
        completion:^(BOOL finished){
        }];
}
- (void)dismiss
{
    self.isShow = NO;
    [UIView animateWithDuration:0.25f
        animations:^{
            _tableView.dk_y = self.dk_bottom;
            _bgView.alpha = 0;
        }
        completion:^(BOOL finished) {
            self.hidden = YES;
        }];
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismiss];
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
}

#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}

#pragma mark - Event response
- (void)handleSingleTap:(UITapGestureRecognizer*)tap
{
    [self dismiss];
}

#pragma mark - Subviews
- (void)configSubViews
{
    self.dataArr = @[ @"现金/实物红包", @"拼手气/群红包", @"免费广告" ];
    [self addSubview:self.bgView];
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = ({
        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
        headView.backgroundColor = [UIColor whiteColor];

        UILabel* mesLabel = [[UILabel alloc] initWithFrame:headView.bounds];
        mesLabel.numberOfLines = 1;
        mesLabel.font = [UIFont systemFontOfSize:15];
        mesLabel.textColor = CCCUIColorFromHex(0x666666);
        mesLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        mesLabel.textAlignment = NSTextAlignmentCenter;
        mesLabel.text = @"请选择推送类型";
        [headView addSubview:mesLabel];

        headView;
    });

    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    [self addGestureRecognizer:singleTap];
}
#pragma mark - Getters & Setters
- (UIView*)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.6];
    }
    return _bgView;
}
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.dk_bottom, self.dk_width, kTableHeight) style:UITableViewStyleGrouped];
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
