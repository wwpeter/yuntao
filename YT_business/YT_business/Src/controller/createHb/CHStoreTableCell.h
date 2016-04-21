//
//  CHStoreTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/6/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHStoreTableCellDelegate;

@interface CHStoreTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic)  UIButton *leftButton;
@property (strong, nonatomic)  UIImageView *storeImageView;
@property (strong, nonatomic)  UIImageView *rankImageView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *costLabel;
@property (strong, nonatomic)  UILabel *addressLabel;
@property (strong, nonatomic)  UILabel *distanceLabel;

@property (strong, nonatomic) YTShop *shop;
@property (weak, nonatomic) id<CHStoreTableCellDelegate> delegate;

- (void)configStoreCellWithListModel:(YTShop *)shop;

@end

@protocol CHStoreTableCellDelegate <NSObject>
@required
- (void)storeTableCell:(CHStoreTableCell *)cell didSelectStore:(YTShop *)shop;
@end

