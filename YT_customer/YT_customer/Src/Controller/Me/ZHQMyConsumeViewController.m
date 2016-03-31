//
//  ZHQMyConsumeViewController.m
//  YT_customer
//
//  Created by 郑海清 on 15/6/15.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "ZHQMyConsumeViewController.h"
#import "YTNetworkMange.h"
#import "MBProgressHUD+Add.h"
#import "SVPullToRefresh.h"
#import "NSStrUtil.h"

@interface ZHQMyConsumeViewController ()

@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger pageSize;
@end

static NSString* CONSUMECELL = @"cell";

@implementation ZHQMyConsumeViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self setUp];
}

#pragma mark - Data
- (void)insertRowAtTop
{
    NSDictionary* parameters = @{ @"pageNum" : @1,
        @"pageSize" : @(_pageSize) };
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_PayOrderPage
        parameters:parameters
        success:^(id responseData) {
            id object = responseData[@"data"][@"records"];
            [weakSelf pullToRefreshViewWithObject:object];
        }
        failure:^(NSString* errorMessage) {
            [weakSelf.consumeTable.pullToRefreshView stopAnimating];
            [MBProgressHUD showError:@"连接失败!" toView:self.view];
        }];
}
- (void)insertRowAtBottom
{
    NSDictionary* parameters = @{ @"pageNum" : @(_page),
        @"pageSize" : @(_pageSize) };
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_PayOrderPage
        parameters:parameters
        success:^(id responseData) {
            id object = responseData[@"data"][@"records"];
            [weakSelf loadMoreViewWithObject:object];

        }
        failure:^(NSString* errorMessage) {
            [weakSelf.consumeTable.infiniteScrollingView stopAnimating];
            [MBProgressHUD showError:errorMessage toView:self.view];
        }];
}
- (void)pullToRefreshViewWithObject:(id)object
{
    [self.consumeArr removeAllObjects];
    self.page = 2;
    for (NSDictionary* dic in object) {
        ZHQMeConsumeModel* hiModel = [[ZHQMeConsumeModel alloc] initMeConsumeModelWithDictionary:dic];
        [self.consumeArr addObject:hiModel];
    }
    [self.consumeTable reloadData];
    [self.consumeTable.infiniteScrollingView beginScrollAnimating];
    [self.consumeTable.pullToRefreshView stopAnimating];
}
- (void)loadMoreViewWithObject:(id)object
{
    if ([object count] == 0) {
        [self.consumeTable.infiniteScrollingView endScrollAnimating];
    }
    else {
        self.page++;
        for (NSDictionary* dic in object) {
            ZHQMeConsumeModel* hiModel = [[ZHQMeConsumeModel alloc] initMeConsumeModelWithDictionary:dic];
            [self.consumeArr addObject:hiModel];
        }
        [self.consumeTable reloadData];
    }
    [self.consumeTable.infiniteScrollingView stopAnimating];
}
#pragma mark - Page subviews;
- (void)setUp
{
    self.navigationItem.title = @"我的消费";
    [self.view addSubview:self.consumeTable];
    self.page = 1;
    self.pageSize = 20;
    [_consumeTable makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.top).offset(64);
    }];
    [self.consumeTable triggerPullToRefresh];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.consumeArr.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    ZHQMyConsumeCell* cell = [tableView dequeueReusableCellWithIdentifier:CONSUMECELL forIndexPath:indexPath];
    ZHQMeConsumeModel* model = _consumeArr[indexPath.row];
    cell.hbTitle.text = model.hbTitle;
    [cell.hbImg sd_setImageWithURL:[model.consumeImg imageUrlWithWidth:200] placeholderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
    cell.hbStatus.text = model.hbReceiveStatusStr;
    cell.hbDate.text = [model.hbDate stringWithFormat:@"yyyy-MM-dd"];
    cell.totalPrice.text = [NSString stringWithFormat:@"¥%@", model.price];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    PaySuccessViewController* paySuccessVC = [StoryBoardUtilities viewControllerForMainStoryboard:[PaySuccessViewController class]];
    ZHQMeConsumeModel* model = _consumeArr[indexPath.row];
    if (model.hbReceiveStatus.integerValue == 1) {
        paySuccessVC.receiveType = NoReceive;
    }
    else if(model.hbReceiveStatus.integerValue == 2) {
        paySuccessVC.receiveType = HadReceive;
    }
    paySuccessVC.orderStr = model.consumeId;
    paySuccessVC.orderId = model.orderId;
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}
#pragma mark - Getters && Setters
- (UITableView*)consumeTable
{
    if (!_consumeTable) {
        _consumeTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _consumeTable.dataSource = self;
        _consumeTable.delegate = self;
        _consumeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _consumeTable.rowHeight = 105.0;
        _consumeTable.backgroundColor = CCCUIColorFromHex(0xEEEEEE);
        [_consumeTable registerClass:[ZHQMyConsumeCell class] forCellReuseIdentifier:CONSUMECELL];
        __weak __typeof(self) weakSelf = self;
        [_consumeTable addPullToRefreshWithActionHandler:^{
            [weakSelf insertRowAtTop];
        }];
        [_consumeTable addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtBottom];
        }];
    }
    return _consumeTable;
}
- (NSMutableArray*)consumeArr
{
    if (!_consumeArr) {
        _consumeArr = [[NSMutableArray alloc] init];
    }
    return _consumeArr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
