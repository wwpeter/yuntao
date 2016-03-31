//
//  RGSelectAddressViewController.m
//  YT_business
//
//  Created by chun.chen on 15/6/4.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "RGSelectAddressViewController.h"
#import <MapKit/MapKit.h>

static const NSInteger kMapHeight = 205;

@interface RGSelectAddressViewController ()<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>

@property (strong, nonatomic) MKMapView * mapView;
@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) NSInteger selectIndex;

@end

@implementation RGSelectAddressViewController

#pragma mark - Life cycle
- (id)init {
    if ((self = [super init])) {
        self.navigationItem.title = @"选择位置";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"保存", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    self.selectIndex = 0;
    [self initializePageSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"mapAddressCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
        cell.tintColor = [UIColor redColor];
    if (indexPath.row == _selectIndex) {
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    } else {
         cell.accessoryType =  UITableViewCellAccessoryNone;
    }

    cell.textLabel.text = @"111111111";
    cell.detailTextLabel.text = @"222222222";
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_selectIndex inSection:0];
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndexPath];
    lastCell.accessoryType =  UITableViewCellAccessoryNone;
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    selectCell.accessoryType =  UITableViewCellAccessoryCheckmark;
    _selectIndex = indexPath.row;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:@"annotation"];
    pinAnnotationView.pinColor = MKPinAnnotationColorRed;
    pinAnnotationView.draggable = YES;
    pinAnnotationView.animatesDrop = YES;
    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding){

    }
}

#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.mapView];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMapHeight-4, CGRectGetWidth(self.view.bounds), 4)];
    line.image = [UIImage imageNamed:@"rg_mapbottom_line.png"];
    [self.view addSubview:line];
    [self.view addSubview:self.tableView];
}
#pragma mark - Getters & Setters
-(MKMapView *)mapView
{
    if (_mapView) return _mapView;
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kMapHeight)];
    _mapView.delegate = self;
      return _mapView;
}
- (UITableView *)tableView
{
    if (_tableView) return _tableView;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kMapHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-kMapHeight-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    return _tableView;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
