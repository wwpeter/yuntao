#import "KindHongbaoTableCell.h"
#import "UIImageView+YTImageWithURL.h"
#import "NSStrUtil.h"
#import "YTPublishListModel.h"

@implementation KindHongbaoTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
#pragma mark - Public methods
- (void)configKindHongbaoCellWithModel:(YTResultHongbao *)hongbao
{
    [self.hbImageView setYTImageWithURL:[hongbao.img imageStringWithWidth:200] placeHolderImage:YTNormalPlaceImage];
    self.nameLabel.text= hongbao.name;
    self.costLabel.text = [NSString stringWithFormat:@"￥%.2f",hongbao.cost/100.];
    [self.throwView configNumberTou:hongbao.tou ling:hongbao.ling yin:hongbao.yin];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - Private methods

#pragma maek - SubViews
- (void)configureSubview
{
    self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hb_cell_background_red.png"]];
    [self.contentView addSubview:self.backImageView];
    
    self.hbImageView = [[UIImageView alloc] init];
    self.hbImageView.clipsToBounds = YES;
    self.hbImageView.layer.masksToBounds = YES;
    self.hbImageView.layer.cornerRadius = 2;
    self.hbImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.hbImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = CCCUIColorFromHex(0x333333);
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.nameLabel];
    
    self.costLabel = [[UILabel alloc] init];
    self.costLabel.numberOfLines = 1;
    self.costLabel.font = [UIFont systemFontOfSize:18];
    self.costLabel.textColor = YTDefaultRedColor;
    self.costLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.costLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.costLabel];
    
    self.throwView = [[YTHbThrowView alloc] init];
    [self.contentView addSubview:self.throwView];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_backImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(self.contentView);
            make.height.mas_equalTo(70);
        }];
        [_hbImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_backImageView).offset(15);
            make.centerY.mas_equalTo(_backImageView);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        [_costLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(_hbImageView);
            make.right.mas_equalTo(_backImageView).offset(-20);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(_hbImageView).offset(2);
            make.height.mas_equalTo(20);
            make.left.mas_equalTo(_hbImageView.right).offset(10);
            make.right.mas_equalTo(_costLabel.left).priorityHigh();
        }];
        [_throwView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_hbImageView.right).offset(10);
            make.top.mas_equalTo(_nameLabel.bottom).offset(5);
            make.right.mas_equalTo(_backImageView);
            make.height.mas_equalTo(24);
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

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
