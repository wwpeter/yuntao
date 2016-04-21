//
//  RegisterViewController.m
//  YT_business
//
//  Created by chun.chen on 15/6/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "RegisterViewController.h"
#import "XLForm.h"
//#import "SelectAddressViewController.h"

NSString *const kRegisterViewName = @"name";
NSString *const kRegisterSelectorAddress = @"selectorAddress";
NSString *const kRegisterSelectorSort = @"selectorSort";

@interface RegisterViewController ()

@end

@implementation RegisterViewController

#pragma mark - Life cycle
- (id)init {
    if ((self = [super init])) {
        [self initializeForm];
    }
    return self;
}
-(void)initializeForm
{
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"注册1/3"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // 名称
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kRegisterViewName rowType:XLFormRowDescriptorTypeText title:@"名称"];
    [row.cellConfigAtConfigure setObject:@"请输入名称" forKey:@"textField.placeholder"];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.required = YES;
    [section addFormRow:row];
    
    // 地址
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kRegisterSelectorAddress rowType:XLFormRowDescriptorTypeSelectorPush title:@"地址"];
//    row.action.viewControllerClass = [SelectAddressViewController class];
     row.value = @"如：中山路1999";
    [section addFormRow:row];

    //分类
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kRegisterSelectorSort rowType:XLFormRowDescriptorTypeSelectorPush title:@"分类"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0)
                                                                displayText:@"Option 1"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Option 2"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Option 3"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"Option 4"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"Option 5"]
                            ];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Option 2"];
    [section addFormRow:row];
    
    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end
