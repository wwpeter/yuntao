//
//  ZHQMyConsumeCell.m
//  YT_customer
//
//  Created by 郑海清 on 15/6/15.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "ZHQMyConsumeCell.h"
#import "NSStrUtil.h"

@implementation ZHQMyConsumeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureSubview];
    }
    return self;
}

#pragma mark - Public methods
- (void)configConsumeCellWithModel:(ZHQMeConsumeModel*)introModel
{
    self.hbTitle.text = introModel.hbTitle;
    [self.hbImg sd_setImageWithURL:[introModel.consumeImg  imageUrlWithWidth:200] placeholderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
    self.hbStatus.text = introModel.hbReceiveStatusStr;
    self.hbDate.text = [introModel.hbDate stringWithFormat:@"yyyy-MM-dd"];
    self.totalPrice.text = [NSString stringWithFormat:@"¥%.2f", introModel.price.floatValue];
}

- (void)awakeFromNib
{
    // Initialization code
}

#pragma mark - Page subviews

- (void)configureSubview
{
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.hbImg];
    [self.backView addSubview:self.hbTitle];
    [self.backView addSubview:self.totalLableStatic];
    [self.backView addSubview:self.totalPrice];
    [self.backView addSubview:self.hbDate];
    [self.backView addSubview:self.arrorImg];
    [self.backView addSubview:self.dottedLine];
    [self.backView addSubview:self.hbStatus];
    [self.backView addSubview:self.topLine];
    [self.backView addSubview:self.bottomLine];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    [self updateConstraints];
}

- (void)updateConstraints
{

    [_backView makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.offset(95);
    }];
    [_topLine makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.mas_equalTo(self.backView.top);
        make.left.right.equalTo(self.contentView);
        make.height.offset(0.5);
    }];

    [_bottomLine makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self.contentView.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.offset(0.5);
    }];

    [_hbImg makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.backView.top).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];

    [_hbTitle makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_hbImg);
        make.left.mas_equalTo(_hbImg.right).offset(10);

    }];
    [_totalLableStatic makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(_hbTitle);
        make.bottom.equalTo(_hbImg);
    }];

    [_totalPrice makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(_totalLableStatic);
        make.left.equalTo(_totalLableStatic.right).offset(5);
    }];

    [_arrorImg makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(_hbImg);
    }];
    [_dottedLine makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.mas_equalTo(self.contentView.bottom).offset(-30);
        make.left.right.equalTo(self.contentView);
        make.height.offset(0.5);
    }];

    [_hbStatus makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(_dottedLine.bottom).offset(9);
    }];
    [_hbDate makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(_hbStatus);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    [super updateConstraints];
}

#pragma mark - Getters && Setters
- (UIView*)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIView*)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = CCCUIColorFromHex(0xCCCCCC);
    }

    return _topLine;
}

- (UIView*)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = CCCUIColorFromHex(0xCCCCCC);
    }
    return _bottomLine;
}

- (UIImageView*)hbImg
{
    if (!_hbImg) {
        _hbImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
    }
    return _hbImg;
}

- (UILabel*)hbTitle
{
    if (!_hbTitle) {
        _hbTitle = [[UILabel alloc] init];
        _hbTitle.font = [UIFont systemFontOfSize:15];
        _hbTitle.textColor = CCCUIColorFromHex(0x333333);
    }
    return _hbTitle;
}

- (UILabel*)totalLableStatic
{
    if (!_totalLableStatic) {
        _totalLableStatic = [[UILabel alloc] init];
        _totalLableStatic.font = [UIFont systemFontOfSize:14];
        _totalLableStatic.textColor = CCCUIColorFromHex(0x666666);
        _totalLableStatic.text = @"消费：";
    }
    return _totalLableStatic;
}

- (UILabel*)totalPrice
{
    if (!_totalPrice) {
        _totalPrice = [[UILabel alloc] init];
        _totalPrice.font = [UIFont systemFontOfSize:14];
        _totalPrice.textColor = CCCUIColorFromHex(0x666666);
    }

    return _totalPrice;
}

- (UIImageView*)arrorImg
{
    if (!_arrorImg) {
        _arrorImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_cell_rightArrow.png"]];
    }
    return _arrorImg;
}

- (UIImageView*)dottedLine
{
    if (!_dottedLine) {
        _dottedLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhq_dotted_line"]];
    }
    return _dottedLine;
}

- (UILabel*)hbStatus
{

    if (!_hbStatus) {
        _hbStatus = [[UILabel alloc] init];
        _hbStatus.font = [UIFont systemFontOfSize:12];
        _hbStatus.textColor = CCCUIColorFromHex(0x666666);
    }

    return _hbStatus;
}

- (UILabel*)hbDate
{
    if (!_hbDate) {
        _hbDate = [[UILabel alloc] init];
        _hbDate.font = [UIFont systemFontOfSize:12];
        _hbDate.textColor = CCCUIColorFromHex(0x666666);
    }

    return _hbDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
