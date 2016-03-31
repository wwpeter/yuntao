//
//  FirstViewController.m
//  YT_customer
//
//  Created by mac on 16/2/17.
//  Copyright © 2016年 sairongpay. All rights reserved.
//

#import "FirstViewController.h"
#import "CollectionViewCell.h"
#import "StoreRootViewController.h"
#import "PaiHangTableViewCell.h"
#import "YTNetworkMange.h"
#import <Masonry/Masonry.h>
#import "FirstTopModel.h"
#import "PayCodeViewController.h"
#import "ScanCodeHelper.h"
#import "OutWebViewController.h"
#import "PayViewController.h"
#import "UIAlertView+TTBlock.h"
#import "QRCodeReaderViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "CSearchStoreViewController.h"

@interface FirstViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,PaiHangCellDelegate>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *paihangDataArray;
@property (nonatomic) NSMutableArray *topDataArray;
//扫一扫
@property (strong, nonatomic) QRCodeReaderViewController* readerVC;
@end


@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    [self setUpSubviews];
    [self createTopView];
    [self loadDataSourse];
    [self createcCollectionView];
    [self createTableView];
}

- (void)loadDataSourse {
    [self.dataArray addObject:@"yt_canyin"];
    [self.dataArray addObject:@"yt_jiudian"];
    [self.dataArray addObject:@"yt_dianying"];
    [self.dataArray addObject:@"yt_yule"];
    [self.dataArray addObject:@"yt_gengduo"];
    
    //请求土豪排行榜
    
}

- (void)createTopView {
    UIImage *saoButton = [UIImage imageNamed:@"yt_buy_image.png"];
    UIImage *higImage = [UIImage imageNamed:@"yt_buy_image.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomImage:saoButton highlightImage:higImage target:self action:@selector(didSaoButtonItemAction:)];
}
#pragma mark - 扫一扫的方法
- (void)didSaoButtonItemAction:(UIButton *)button {
    _readerVC = [[QRCodeReaderViewController alloc] init];
    _readerVC.modalPresentationStyle = UIModalPresentationFormSheet;
    _readerVC.hidesBottomBarWhenPushed = YES;
    _readerVC.navigationItem.title = @"扫一扫";
    _readerVC.delegate = self;
    __weak typeof(self) weakSelf = self;
    [_readerVC setCompletionWithBlock:^(NSString* resultAsString) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setupScanResultString:resultAsString formViewController:strongSelf.readerVC];
    }];
    [self.navigationController pushViewController:_readerVC animated:YES];
    
}

- (void)setupScanResultString:(NSString*)string formViewController:(UIViewController*)formViewController
{
    ScanCodeHelper *scanCode = [[ScanCodeHelper alloc] initWithResultUrlString:string];
    if (!scanCode.isYtCode) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"此二维码未经官方认证" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        __weak typeof(self) weakSelf = self;
        [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (buttonIndex == 0) {
                [strongSelf.readerVC startScanning];
            }
        }];
        [alert show];
        return;
    }
    if (scanCode.openType == ScanCodeOpenTypeH5) {
        OutWebViewController* webVC = [[OutWebViewController alloc] initWithNibName:@"OutWebViewController" bundle:nil];
        webVC.urlStr = string;
        [formViewController.navigationController pushViewController:webVC animated:YES];
    }
    else {
        PayViewController* payVC = [[PayViewController alloc] init];
        payVC.shopId = scanCode.shopId;
        payVC.mayChange = YES;
        [formViewController.navigationController pushViewController:payVC animated:YES];
    }
}


#pragma mark - tableView 
- (void)createTableView {
    CGFloat height = 64+self.view.frame.size.height*0.20+self.view.frame.size.height*0.11+8;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width,self.view.frame.size.height - height-49)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 28)];
    UILabel *redLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 3, 18)];
    redLabel.backgroundColor = [UIColor redColor];
    UILabel *paihangLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 150, 18)];
    paihangLabel.text = @"好友红包排行榜";
    paihangLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:redLabel];
    [headView addSubview:paihangLabel];
    self.tableView.tableHeaderView = headView;
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"PaiHangTableViewCell" bundle:nil] forCellReuseIdentifier:paihang];
    
    [self.view addSubview:self.tableView];
}

#pragma mark -collectionView
- (void)createcCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((self.view.frame.size.width /5)-2, self.view.frame.size.height*0.10); // 定义item(cell)的宽高
    
    // 行间距（竖直滚动）   列间距（水平滚动）
    layout.minimumLineSpacing = 0.0;
    
    // cell(item)之间的最小间距
    layout.minimumInteritemSpacing = 0.0;
    
    layout.headerReferenceSize = CGSizeMake(0, 0);
    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    // section内边距
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+self.view.frame.size.height*0.20, self.view.frame.size.width, self.view.frame.size.height*0.11)collectionViewLayout:layout]; // collectionView关联layout, 因为它要用layout对象布局自己
   
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    // layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //注册
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellID];
   
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (NSMutableArray *)paihangDataArray {
    if (_paihangDataArray == nil) {
        _paihangDataArray = [[NSMutableArray alloc] init];
    }
    return _paihangDataArray;
}
- (NSMutableArray *)topDataArray {
    if (_topDataArray == nil) {
        _topDataArray = [[NSMutableArray alloc] init];
    }
    return _topDataArray;
}
#pragma mark - collectionView的代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.photoImageView.image = [UIImage imageNamed:self.dataArray[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    StoreRootViewController *storeViewController = [[StoreRootViewController alloc] init];
    storeViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:storeViewController animated:YES];
}

#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // return self.paihangDataArray.count;
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaiHangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:paihang];
    cell.myImageView.image = [UIImage imageNamed:@"yt_jiudian.png"];
    cell.userName.text = @"布依布舍007";
    cell.mingciLabel.text = [NSString stringWithFormat:@"第%d名",arc4random()%20];
    cell.moneyLabel.text = @"8888";
    cell.coolNumber.text = @"9";
    
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark Page subviews
- (void)setUpSubviews {
    //发红包排行第一的商户
    //土豪排行榜、
    CGFloat height1 = self.view.frame.size.height*0.20-8;
    CGFloat width = self.view.frame.size.width;
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width*0.5-0.5, height1)];
    myView.backgroundColor = [UIColor whiteColor];
    ;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*0.08, 12, width*0.3, height1*0.18)];
    imageView.image = [UIImage imageNamed:@"paihang1.png"];
    [myView addSubview:imageView];
    
    //土豪排行榜的图片
    UIImageView *oneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*0.08+(width*0.2/4), 12+height1*0.18, width*0.2, height1*0.25)];
    oneImageView.image = [UIImage imageNamed:@"one"];
    [myView addSubview:oneImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*0.16, 12+height1*0.18+height1*0.25, width*0.3, height1*0.15)];
    nameLabel.text = @"豪客来";
    nameLabel.textColor = [UIColor colorWithWhite:0 alpha:0.6];
    nameLabel.font = [UIFont systemFontOfSize:10];
    [myView addSubview:nameLabel];
    //红包总额 和 金额
    UILabel *zongeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*0.04, 12+height1*0.18+height1*0.25+height1*0.15+6, width*0.3, height1*0.15)];
    zongeLabel.text = @"红包总额:";
    zongeLabel.textColor = [UIColor colorWithWhite:0 alpha:0.8];
    zongeLabel.font = [UIFont systemFontOfSize:12];
    [myView addSubview:zongeLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*0.04+width*0.18, 12+height1*0.18+height1*0.25+height1*0.15+6, width*0.3, height1*0.15)];
    moneyLabel.text = @"99999.9";
    moneyLabel.textColor = [UIColor colorWithWhite:0 alpha:0.8];
    moneyLabel.font = [UIFont systemFontOfSize:12];
    [myView addSubview:moneyLabel];

    
    [self.view addSubview:myView];
    //发红包排行第二的商户
    CGFloat height = (self.view.frame.size.height*0.20-8)/2.0;
    UIView *topView2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0+1.5, 64, self.view.frame.size.width/2.0-1, height-1)];
    topView2.backgroundColor = [UIColor whiteColor];
    UIImageView *twoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, width*0.2, height*0.5)];
    twoImageView.image = [UIImage imageNamed:@"paihang2.png"];
    [topView2 addSubview:twoImageView];
    UILabel *twoMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 2+height*0.5, width*0.2, height*0.5)];
    twoMoneyLabel.text = @"88888.8";
    twoMoneyLabel.font = [UIFont systemFontOfSize:11];
    twoMoneyLabel.textColor = [UIColor redColor];
    [topView2 addSubview:twoMoneyLabel];
    
    UIImageView *twoImageViewShop = [[UIImageView alloc] initWithFrame:CGRectMake(15+width*0.23, 10, width*0.15, height*0.5)];
    twoImageViewShop.image = [UIImage imageNamed:@"two.png"];
    [topView2 addSubview:twoImageViewShop];
    
    UILabel *twoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+width*0.25, 10+height*0.4, width*0.2, height*0.4)];
    twoNameLabel.text = @"麦当劳";
    twoNameLabel.textColor = [UIColor colorWithWhite:0 alpha:0.6];
    twoNameLabel.font = [UIFont systemFontOfSize:10];
    [topView2 addSubview:twoNameLabel];
    //发红包排行第三的商户
    UIView *topView3 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0+1.5, 64+height+1, self.view.frame.size.width/2.0-1, height-1)];
    topView3.backgroundColor = [UIColor whiteColor];
  
    UIImageView *threeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, width*0.2, height*0.5)];
    threeImageView.image = [UIImage imageNamed:@"paihang3.png"];
    [topView3 addSubview:threeImageView];
    UILabel *threeMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 2+height*0.5, width*0.2, height*0.5)];
    threeMoneyLabel.text = @"666666.8";
    threeMoneyLabel.font = [UIFont systemFontOfSize:11];
    threeMoneyLabel.textColor = [UIColor redColor];
    [topView3 addSubview:threeMoneyLabel];
    
    UIImageView *threeImageViewShop = [[UIImageView alloc] initWithFrame:CGRectMake(15+width*0.23, 10, width*0.15, height*0.5)];
    threeImageViewShop.image = [UIImage imageNamed:@"three.png"];
    [topView3 addSubview:threeImageViewShop];
    
    UILabel *threeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+width*0.25, 10+height*0.4, width*0.2, height*0.4)];
    threeNameLabel.text = @"辛巴克";
    threeNameLabel.textColor = [UIColor colorWithWhite:0 alpha:0.6];
    threeNameLabel.font = [UIFont systemFontOfSize:10];
    [topView3 addSubview:threeNameLabel];
    
    [self.view addSubview:topView2];
    [self.view addSubview:topView3];
    
    [self createSearch];
}

#pragma mark - 搜索按钮
- (void)createSearch {
    //搜索
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width*0.55, 30)];
    searchView.backgroundColor = [UIColor whiteColor];
    UIImageView *search = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 20, 20)];
    search.image = [UIImage imageNamed:@"yt_search_image"];
    [searchView addSubview:search];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 8, 200, 15)];
    label.text = @"云陶红包10w现金等你拿";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithWhite:0 alpha:0.4];
    [searchView addSubview:label];
    searchView.userInteractionEnabled = YES;
    //加点击事件
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.view.frame.size.width*0.55, 30);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(searchButton:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:button];
    self.navigationItem.titleView = searchView;
}

- (void)searchButton:(UIButton *)button {
    CSearchStoreViewController* searchStoreVC = [[CSearchStoreViewController alloc] init];
    searchStoreVC.searchResultModule =  SearchResultModuleStore;
    searchStoreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchStoreVC animated:YES];
}

#pragma mark - 点赞的代理
- (void)didPraise:(UIButton *)button callNumber:(NSString *)str {
    NSLog(@"rr");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
