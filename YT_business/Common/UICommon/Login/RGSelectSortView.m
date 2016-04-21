//
//  RGSelectSortView.m
//  YT_business
//
//  Created by chun.chen on 15/6/4.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTCategoryModel.h"
#import "RGSelectSortView.h"
#import "YTRegisterHelper.h"

static const NSInteger kTopViewHeight = 20;
static const NSInteger kTableHeight = 290;
static const NSInteger kDefaultRowHeight = 50;
static const NSInteger kLeftWidth = 160;

static NSString *LeftCellIdentifier = @"selectSortLeftCellIdentifier";
static NSString *RightCellIdentifier = @"selectSortRightCellIdentifier";

@interface RGSelectSortView ()
<
UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate
> {
    NSArray *leftDataArr;
    NSArray *rightDataArr;
}

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *selectView;
@property (strong, nonatomic) UITableView *leftTableView;
@property (strong, nonatomic) UITableView *rightTableView;
@end

@implementation RGSelectSortView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
        
        leftDataArr = [NSArray array];
        rightDataArr = [NSArray array];
        
        [self initializeSubView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleSingleTap:)];
        singleTap.delegate = self;
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

#pragma mark -setter
- (void)setCategoryModel:(YTCategoryModel *)categoryModel {
    leftDataArr = categoryModel.categorys;
    [self.leftTableView reloadData];
    if (categoryModel.categorys.count > 0) {
        rightDataArr = [categoryModel.categorys.firstObject children];
        [self.rightTableView reloadData];
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _leftTableView) {
        return leftDataArr.count;
    }
    return rightDataArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (tableView == _leftTableView) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:LeftCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        YTCategorySet *categorySet = (YTCategorySet *)[leftDataArr objectAtIndex:indexPath.row];
        NSArray *selCategoryArr = [categorySet.children filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hasSelected == 1"]];
        
        if (selCategoryArr.count > 0) {
            cell.backgroundColor = [UIColor whiteColor];
        } else {
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.textLabel.text = categorySet.name;
        
        [cell.imageView setYTImageWithURL:categorySet.icon placeHolderImage:nil];
        CGSize itemSize = CGSizeMake(15, 15);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return cell;
    } else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:RightCellIdentifier];
        cell.textLabel.textColor = [UIColor blackColor];
        
        YTCategory *category = (YTCategory *)[rightDataArr objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (category.hasSelected) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = category.name;
        return cell;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _leftTableView) {
        YTCategorySet *categorySet = [leftDataArr objectAtIndex:indexPath.row];
        if (categorySet.children.count > 0) {
            rightDataArr = [NSArray arrayWithArray:categorySet.children];
        } else {
            rightDataArr = [NSArray array];
        }
        [_rightTableView reloadData];
    } else {
        YTCategory *category = [rightDataArr objectAtIndex:indexPath.row];
        category.hasSelected = !category.hasSelected;
        if (category.hasSelected) {
            NSArray *hadSelectedArr = [rightDataArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hasSelected == 1 && categoryId != %@",category.categoryId]];
            if (hadSelectedArr.count == 1) {
                YTCategory *hadSelectedCategory = hadSelectedArr.lastObject;
                hadSelectedCategory.hasSelected = NO;
            }
            [self hideSelectSortView];
            [YTRegisterHelper registerHelper].catId = category.categoryId;
            [YTRegisterHelper registerHelper].categoryName = category.name;
            if (self.selectedCategoryBlock) {
                self.selectedCategoryBlock(category);
            }
        }
        [self.rightTableView reloadData];
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
@end