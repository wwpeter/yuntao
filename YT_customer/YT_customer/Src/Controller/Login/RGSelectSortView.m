//
//  RGSelectSortView.m
//  YT_business
//
//  Created by chun.chen on 15/6/4.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "RGSelectSortView.h"

static const NSInteger kTopViewHeight = 20;
static const NSInteger kTableHeight = 290;
static const NSInteger kDefaultRowHeight = 50;
static const NSInteger kLeftWidth = 160;

static NSString *LeftCellIdentifier = @"selectSortLeftCellIdentifier";
static NSString *RightCellIdentifier = @"selectSortRightCellIdentifier";

@interface RGSelectSortView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *selectView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UITableView *leftTableView;
@property (strong, nonatomic) UITableView *rightTableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *rightArray;

@property (assign, nonatomic) NSInteger leftSelectIndex;

@end

@implementation RGSelectSortView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [[NSArray alloc] init];
        _rightArray = [[NSArray alloc] init];
        _leftSelectIndex = 0;
        [self setupData];
        [self initializeSubView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleSingleTap:)];
        singleTap.delegate = self;
        [self addGestureRecognizer:singleTap];

    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
            return _dataArray.count;
    } else {
            return _rightArray.count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == _leftTableView) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:LeftCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == _leftSelectIndex) {
            cell.backgroundColor = [UIColor whiteColor];
        } else {
            cell.backgroundColor = [UIColor clearColor];
        }

        NSDictionary *items = _dataArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:items[@"image"]];
        cell.textLabel.text = items[@"title"];
        
        return cell;
    } else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:RightCellIdentifier];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType =  UITableViewCellAccessoryNone;
        cell.textLabel.text = _rightArray[indexPath.row];
        return cell;
    }

}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == _leftTableView) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_leftSelectIndex inSection:0];
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndexPath];
        lastCell.backgroundColor = [UIColor clearColor];
        selectCell.backgroundColor = [UIColor whiteColor];
        _leftSelectIndex = indexPath.row;
        _rightArray = _dataArray[indexPath.row][@"data"];
        [_rightTableView reloadData];
    } else {
        selectCell.tintColor = [UIColor redColor];
        selectCell.textLabel.textColor = [UIColor redColor];
        selectCell.accessoryType =  UITableViewCellAccessoryCheckmark;
        [self hideSelectSortView];

    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_leftTableView] || [touch.view isDescendantOfView:_rightTableView]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Event response
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    [self hideSelectSortView];
}
- (void)downButtonClicked:(id)senser
{
    [self hideSelectSortView];
}
#pragma mark - Public methods
- (void)showSelectSortView
{
    self.alpha = 1;
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    CGRect rect = _selectView.frame;
    rect.origin.y = CGRectGetHeight(self.frame)-kTopViewHeight-kTableHeight;
    [UIView animateWithDuration:.3f animations:^{
        _selectView.frame = rect;
    }];
}
- (void)hideSelectSortView
{
    CGRect rect = _selectView.frame;
    rect.origin.y = CGRectGetHeight(self.frame);
    [UIView animateWithDuration:.3f animations:^{
        _selectView.frame = rect;
        self.alpha = 0;

    } completion:^(BOOL finished) {
        [_rightTableView reloadData];
    }];
}
#pragma mark - Page Subviews
- (void)initializeSubView
{
    _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kTopViewHeight+kTableHeight)];
    _selectView.backgroundColor = CCCUIColorFromHex(0xf8f8f8);
    [self addSubview:_selectView];
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 18);
    [downBtn setImage:[UIImage imageNamed:@"rg_downbutton.png"] forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:downBtn];
    
    UIImageView *downLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, kTopViewHeight-1, CGRectGetWidth(self.bounds), 1)];
    downLine.image = [UIImage imageNamed:@"rg_downline.png"];
    [_selectView addSubview:downLine];
    [_selectView addSubview:self.leftTableView];
    [_selectView addSubview:self.rightTableView];
    
}

#pragma mark - Setter & Getter
- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopViewHeight, kLeftWidth, kTableHeight)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = kDefaultRowHeight;
        _leftTableView.backgroundColor = [UIColor clearColor];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LeftCellIdentifier];
    }
    return _leftTableView;
}
- (UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kLeftWidth, kTopViewHeight, CGRectGetWidth(self.bounds)-kLeftWidth, kTableHeight)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = kDefaultRowHeight;
        [_rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RightCellIdentifier];
    }
    return _rightTableView;
}

- (void)setupData
{
    NSArray *food = @[@"小吃快餐", @"自助餐", @"江浙菜", @"火锅", @"面包甜心",@"咖啡厅",@"日本料理"];
    NSArray *movie = @[@"电影一", @"电影二", @"电影三"];
    NSArray *other = @[@"一一一", @"二二二二", @"三三三三三"];
    _dataArray = @[@{@"title":@"美食",@"image":@"rg_sort_01.png",@"data":food},
                   @{@"title":@"电影",@"image":@"rg_sort_02.png",@"data":movie},
                   @{@"title":@"休闲娱乐",@"image":@"rg_sort_03.png",@"data":other},
                   @{@"title":@"酒店",@"image":@"rg_sort_04.png",@"data":other},
                   @{@"title":@"景点",@"image":@"rg_sort_05.png",@"data":other},
                   @{@"title":@"丽人",@"image":@"rg_sort_06.png",@"data":other},
                   @{@"title":@"运动健身",@"image":@"rg_sort_07.png",@"data":other}];
    _rightArray = [_dataArray firstObject][@"data"];
}
@end
