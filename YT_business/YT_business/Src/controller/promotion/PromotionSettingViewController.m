

#import "YTPromotionModel.h"
#import "PromotionSettingViewController.h"
#import "XLFormRowNavigationAccessoryView.h"
#import "MBProgressHUD+Add.h"
#import "YTPromotionSettingModel.h"
#import "UIAlertView+TTBlock.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"

@interface PromotionSettingViewController () <UITableViewDelegate,
    UITableViewDataSource> {
    float youhuiPrice;
    float conditionPrice;
    NSMutableArray* dataArr;
    NSMutableDictionary* hbChangeDic;
        NSArray *subtractArr;
    UITableView* promotionSettingTableView;

    YTPromotionSet* promotionSet;
}
@end

@implementation PromotionSettingViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Data Prepare
    dataArr = [[NSMutableArray alloc] init];
    hbChangeDic = [[NSMutableDictionary alloc] init];
    subtractArr = [[NSArray alloc] init];
    [self configureUIComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -configureUIComponents
- (void)configureUIComponents
{
    self.navigationItem.title = @"促销设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"保存", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    // promotionSettingTableView
    promotionSettingTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    promotionSettingTableView.delegate = self;
    promotionSettingTableView.dataSource = self;
    promotionSettingTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:promotionSettingTableView];

    [self fetchSettingData];
    wSelf(wSelf);
    // refresh
    [promotionSettingTableView addYTPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:NO];
    }];
    // loadingMore
    [promotionSettingTableView addYTInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:YES];
    }];
    promotionSettingTableView.showsInfiniteScrolling = NO;
    [promotionSettingTableView triggerPullToRefresh];
}

#pragma mark -Setting Data
- (void)fetchSettingData
{
    self.requestParas = @{};
    self.requestURL = getPromoteSetURL;
}
#pragma mark -fetchDataWithIsLoadingMore
- (void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    int currPage = [[self.requestParas objectForKey:@"pageNum"] intValue];
    if (!isLoadingMore) {
        currPage = 1;
    }
    else {
        ++currPage;
    }
    self.requestParas = @{ @"pageSize" : @(20),
        @"paheNum" : @(currPage),
        isLoadingMoreKey : @(isLoadingMore) };
    self.requestURL = setBuyHongbaoStatusListURL;
}
#pragma mark -Send Data
- (void)sendUserSettingData
{
    NSMutableDictionary* reqParas = [[NSMutableDictionary alloc] init];
    reqParas[@"manSong"] = [NSString stringWithFormat:@"%@:%@", @(conditionPrice * 100), @(youhuiPrice * 100)];
    reqParas[@"defaultOnSale"] = @(promotionSet.shop.defaultOnSale);
    NSArray* hbKeys = [hbChangeDic allKeys];
    for (NSInteger i = 0; i < hbKeys.count; i++) {
        NSString* hbId = hbKeys[i];
        YTPromotionHongbao* hongbao = hbChangeDic[hbId];
        NSString* butSetIdKey = [NSString stringWithFormat:@"buyList[%@].id", @(i)];
        NSString* butSetStatusKey = [NSString stringWithFormat:@"buyList[%@].status", @(i)];
        reqParas[butSetIdKey] = hbId;
        reqParas[butSetStatusKey] = @(hongbao.status);
    }
    self.requestParas = [[NSDictionary alloc] initWithDictionary:reqParas];
    self.requestURL = savePromoteSetURL;
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:getPromoteSetURL]) {
            YTPromotionSettingModel* settingModel = (YTPromotionSettingModel*)parserObject;
            promotionSet = settingModel.promotionSet;
            NSDictionary* shopRuleDic = [NSStrUtil jsonObjecyWithString:promotionSet.shop.shopHongbaoRule];
            NSString* rule = shopRuleDic[@"manSong"];
            NSRange range = [rule rangeOfString:@":"];
            if (range.location == NSNotFound) {
                return;
            }
            NSArray* ruleArray = [rule componentsSeparatedByString:@":"];
            conditionPrice = [[ruleArray firstObject] doubleValue] / 100;
            youhuiPrice = [[ruleArray lastObject] doubleValue] / 100;
            NSArray *fullSubtracts = [NSStrUtil jsonObjecyWithString:promotionSet.shop.fullSubtract];
            NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in fullSubtracts) {
                YTSubtractFullModel *fullModel = [[YTSubtractFullModel alloc] initWithJSONDict:dic];
                for (YTFullSubtract *subtract in fullModel.rules) {
                    subtract.date = fullModel.date;
                    [mutableArr addObject:subtract];
                }
            }
            subtractArr = [[NSArray alloc] initWithArray:mutableArr];
            
            [promotionSettingTableView reloadData];
        }
        else if ([operation.urlTag isEqualToString:savePromoteSetURL]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            wSelf(wSelf);
            [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [wSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
            [alert show];
        }
        else {
            YTPromotionModel* promotionModel = (YTPromotionModel*)parserObject;
            if (!operation.isLoadingMore) {
                dataArr = [NSMutableArray arrayWithArray:promotionModel.promotionHongbaoSet.records];
            }
            else {
                [dataArr addObjectsFromArray:promotionModel.promotionHongbaoSet.records];
            }
            [promotionSettingTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            if (!operation.isLoadingMore) {
                [promotionSettingTableView.pullToRefreshView stopAnimating];
            }
            else {
                [promotionSettingTableView.infiniteScrollingView stopAnimating];
            }
            if (promotionModel.promotionHongbaoSet.totalCount > dataArr.count) {
                promotionSettingTableView.showsInfiniteScrolling = YES;
            }
            else {
                promotionSettingTableView.showsInfiniteScrolling = NO;
            }
        }
    }
    else {
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (promotionSet.shop.promotionType == 2) {
            return subtractArr.count;
        }
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    return dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    if (section == 0) {
        static NSString* youhuiCellIdentifier = @"youhuiCell";
        UITableViewCell* youhuiCell = [tableView dequeueReusableCellWithIdentifier:youhuiCellIdentifier];
        if (!youhuiCell) {
            youhuiCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:youhuiCellIdentifier];
            youhuiCell.selectionStyle = UITableViewCellSelectionStyleGray;
            youhuiCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            youhuiCell.detailTextLabel.numberOfLines = 2;
            youhuiCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }
        youhuiCell.textLabel.text = @"当前优惠";
        if (promotionSet.shop.promotionType ==2 ) {
            if (indexPath.row < subtractArr.count) {
                YTFullSubtract *subtract = subtractArr[indexPath.row];
                NSString *dateStr = [subtract.date
                                     stringByReplacingOccurrencesOfString:@"/"
                                     withString:@"至"];
                NSString *timeStr = [subtract.time
                                     stringByReplacingOccurrencesOfString:@"/"
                                     withString:@"-"];
                NSString *subStr = [NSString stringWithFormat:@"%@ %@ 每满%@减%@元 最高减%@元",dateStr,timeStr,@(subtract.subtractFull),@(subtract.subtractCur),@(subtract.subtractMax)];
                youhuiCell.detailTextLabel.text = subStr;
            }
        }else{
            if (promotionSet.shop.promotionType==0 || promotionSet.shop.discount == 100) {
                youhuiCell.detailTextLabel.text = @"未设置";
            }else {
                NSString* discountStr =
                [NSString stringWithFormat:@"%.1f折", promotionSet.shop.discount / 10.];
                youhuiCell.detailTextLabel.text = discountStr;
            }
        }
        return youhuiCell;
    }
    else if (section == 1) {
        static NSString* onboardSwitchCellIdentifier = @"onboardSwitchCell";
        UITableViewCell* onboardSwitchCell = [tableView dequeueReusableCellWithIdentifier:onboardSwitchCellIdentifier];
        if (!onboardSwitchCell) {
            onboardSwitchCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:onboardSwitchCellIdentifier];
            onboardSwitchCell.selectionStyle = UITableViewCellSelectionStyleNone;

            // configure UIProperty
            onboardSwitchCell.textLabel.text = @"新买红包默认上架";
            onboardSwitchCell.textLabel.font = [UIFont systemFontOfSize:14];
            onboardSwitchCell.textLabel.textColor = [UIColor hexFloatColor:@"242424"];
        }
        UISwitch* switchOnboard = [[UISwitch alloc] init];
        switchOnboard.onTintColor = [UIColor redColor];
        switchOnboard.on = promotionSet.shop.defaultOnSale;
        [switchOnboard addTarget:self action:@selector(defaultSwitchAction:) forControlEvents:UIControlEventValueChanged];
        onboardSwitchCell.accessoryView = switchOnboard;
        return onboardSwitchCell;
    }
    static NSString* hongbaoCellIdentifier = @"hongbaoCell";
    UITableViewCell* hongbaoCell = [tableView dequeueReusableCellWithIdentifier:hongbaoCellIdentifier];
    if (!hongbaoCell) {
        hongbaoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hongbaoCellIdentifier];
        hongbaoCell.selectionStyle = UITableViewCellSelectionStyleNone;

        // configure UIProperty
        UILabel* textLab = [[UILabel alloc] init];
        textLab.tag = 101;
        textLab.font = [UIFont systemFontOfSize:15];
        textLab.textColor = [UIColor hexFloatColor:@"242424"];
        [hongbaoCell addSubview:textLab];

        UILabel* detailLab = [[UILabel alloc] init];
        detailLab.tag = 102;
        detailLab.font = [UIFont systemFontOfSize:13];
        detailLab.textColor = [UIColor hexFloatColor:@"666666"];
        [hongbaoCell addSubview:detailLab];

        [textLab mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.mas_lessThanOrEqualTo(hongbaoCell.mas_right).with.offset(-100);
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
        }];

        [detailLab mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.mas_lessThanOrEqualTo(hongbaoCell.mas_right).with.offset(-100);
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(textLab.mas_bottom).with.offset(8);
        }];
    }
    YTPromotionHongbao* hongbao = (YTPromotionHongbao*)[dataArr objectAtIndex:row];
    UILabel* textLab = (UILabel*)[hongbaoCell viewWithTag:101];
    UILabel* detailLab = (UILabel*)[hongbaoCell viewWithTag:102];
    UISwitch* switchOnboard = [[UISwitch alloc] init];
    switchOnboard.onTintColor = [UIColor redColor];
    switchOnboard.tag = 1000 + row;
    [switchOnboard addTarget:self action:@selector(hongbaoSwitchAction:) forControlEvents:UIControlEventValueChanged];

    switchOnboard.on = hongbao.status == 2 || hongbao.status == 1 ? YES : NO;
    hongbaoCell.accessoryView = switchOnboard;

    textLab.text = [NSString stringWithFormat:@"%@ 价值%.1f", hongbao.name, hongbao.cost / 100.];
    detailLab.text = hongbao.title;
    return hongbaoCell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 0) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"如需修改当前优惠请拨打客服热线400-117-7677" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (buttonIndex == 1) {
            [strongSelf callPhoneNumber:YT_Service_Number];
        }
    }];
    [alert show];
}
#pragma mark -UITableViewDelegate
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
        //        return [NSString stringWithFormat:@"红包促销比例，不足则等比赠送(当前比例%@)",youhuiTitle];
    }
    else if (section == 1) {
        return @"";
    }
    return @"红包上架管理";
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 15.;
    }
    return 40.;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 2) {
        return 60;
    }
    return 44;
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - Event response
- (void)defaultSwitchAction:(id)sender
{
    UISwitch* switchOnboard = (UISwitch*)sender;
    promotionSet.shop.defaultOnSale = switchOnboard.on;
}
- (void)hongbaoSwitchAction:(id)sender
{
    UISwitch* switchOnboard = (UISwitch*)sender;
    NSInteger swichIndex = switchOnboard.tag - 1000;
    if (swichIndex < dataArr.count) {
        YTPromotionHongbao* hongbao = (YTPromotionHongbao*)[dataArr objectAtIndex:swichIndex];
        hongbao.status = switchOnboard.on ? 2 : 4;
        [hbChangeDic setObject:hongbao forKey:hongbao.promotionHongbaoId];
    }
}
#pragma mark -Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self sendUserSettingData];
}
#pragma mark -setNewYouhuiValue
- (void)setNewYouhuiValue:(UITextField*)inputTextField
{
    UITableViewCell* superView = (UITableViewCell*)inputTextField.superview;
    if (![superView isKindOfClass:[UITableViewCell class]]) {
        superView = (UITableViewCell*)superView.superview;
    }
    NSIndexPath* inputIndexPath = [promotionSettingTableView indexPathForCell:superView];
    if (inputIndexPath.row == 0) {
        conditionPrice = inputTextField.text.floatValue;
    }
    else {
        youhuiPrice = inputTextField.text.floatValue;
    }
}
@end
