#import "CHStoreTableCell.h"
#import "CHStoreListModel.h"
#import "UIImageView+WebCache.h"
#import "UserMationMange.h"

@implementation CHStoreTableCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureSubview];
    }
    return self;
}
- (void)configStoreCellWithListModel:(YTShop*)shop
{
    self.shop = shop;
    self.leftButton.selected = shop.didSelect;
    [self.storeImageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"yt_store_placeImage.png"]];
    self.rankImageView.image = [UIImage imageNamed:@"yt_star_level_10.png"];
    self.nameLabel.attributedText = [shop nameAttributeStr];
    self.costLabel.text = [NSString stringWithFormat:@"￥%@/人", @(shop.custFee / 100)];
    self.addressLabel.text = [NSString stringWithFormat:@"%@", shop.address];
    self.distanceLabel.text = [shop userLocationDistance];
    if ([shop.shopId isEqualToString:[YTUsr usr].shop.shopId]) {
        self.leftButton.hidden = YES;
    }else{
        self.leftButton.hidden = NO;
    }
}
#pragma mark - Event response
- (void)leftButtonDidClicked:(id)sender
{
    [_delegate storeTableCell:self didSelectStore:_shop];
}
#pragma mark - Private methods

#pragma maek - SubViews
- (void)configureSubview
{
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setImage:[UIImage imageNamed:@"yt_cell_left_normal.png"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"yt_cell_left_select.png"] forState:UIControlStateSelected];
    [self.leftButton addTarget:self action:@selector(leftButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.leftButton];

    self.storeImageView = [[UIImageView alloc] init];
    self.storeImageView.clipsToBounds = YES;
    self.storeImageView.layer.masksToBounds = YES;
    self.storeImageView.layer.cornerRadius = 2;
    self.storeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.storeImageView];

    self.rankImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.rankImageView];

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = CCCUIColorFromHex(0x333333);
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.nameLabel];

    self.costLabel = [[UILabel alloc] init];
    self.costLabel.numberOfLines = 1;
    self.costLabel.font = [UIFont systemFontOfSize:12];
    self.costLabel.textColor = CCCUIColorFromHex(0x333333);
    self.costLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.costLabel];

    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.numberOfLines = 1;
    self.addressLabel.font = [UIFont systemFontOfSize:14];
    self.addressLabel.textColor = CCCUIColorFromHex(0x999999);
    self.addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.addressLabel];

    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.numberOfLines = 1;
    self.distanceLabel.font = [UIFont systemFontOfSize:14];
    self.distanceLabel.textColor = CCCUIColorFromHex(0x999999);
    self.distanceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.distanceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.distanceLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {

        [_leftButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(23, 23));
        }];
        [_storeImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_leftButton.right).offset(15);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(_storeImageView).offset(2);
            make.left.mas_equalTo(_storeImageView.right).offset(10);
            make.right.mas_equalTo(self.contentView);
        }];
        [_rankImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(_nameLabel.bottom).offset(6);
            make.left.mas_equalTo(_nameLabel);
            make.size.mas_equalTo(CGSizeMake(76, 12));
        }];
        [_costLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_rankImageView.right).offset(10);
            make.top.mas_equalTo(_rankImageView);
            make.right.mas_equalTo(self.contentView);
        }];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_rankImageView);
            make.top.mas_equalTo(_rankImageView.bottom).offset(6);
            make.right.mas_equalTo(self.contentView).offset(-70);
        }];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(_addressLabel);
            make.width.mas_equalTo(70);
        }];

        self.didSetupConstraints = YES;
    }

    [super updateConstraints];
}

/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // for multiline UILabel's you need set the preferredMaxLayoutWidth
    // you need to do this after [super layoutSubviews] as the frames will have a value from Auto Layout at this point
    
    // stay tuned for new easier way todo this coming soon to Masonry
    
    // need to layoutSubviews again as frames need to recalculated with preferredLayoutWidth
    [super layoutSubviews];
}
*/
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
