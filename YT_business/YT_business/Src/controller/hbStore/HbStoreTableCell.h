//
//  HbStoreTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/6/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTUsrHongBao;
@protocol HbStoreTableCellDelegate;

@interface HbStoreTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *hbImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *describeLabel;
@property (strong, nonatomic) UILabel *costLabel;

@property (strong, nonatomic) UITextField *textFiled;
@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *minusButton;

@property (strong, nonatomic) UILabel *sameLabel;
@property (strong, nonatomic) UIButton *askButton;

@property (weak, nonatomic) id<HbStoreTableCellDelegate> delegate;

- (void)configHbStoreTableListModel:(YTUsrHongBao *)hongbao;

@end


@protocol HbStoreTableCellDelegate <NSObject>
@required
- (void)hbStoreTableCell:(HbStoreTableCell *)cell hbStoreModel:(YTUsrHongBao *)hbModel textFieldDidEndEditing:(UITextField *)textField;
- (void)hbStoreTableCell:(HbStoreTableCell *)cell textFieldShouldBeginEditing:(UITextField *)textField;
- (void)hbStoreTableCell:(HbStoreTableCell *)cell didAddhbStoreModel:(YTUsrHongBao *)hbModel;
- (void)hbStoreTableCell:(HbStoreTableCell *)cell didMinushbStoreModel:(YTUsrHongBao *)hbModel;
- (void)hbStoreTableCellAskAction:(HbStoreTableCell *)cell;
@end



