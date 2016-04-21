#import "RegisterInfomationTableCell.h"

@interface RegisterInfomationTableCell ()
@property (nonatomic, strong) UILabel* photoLabel;
@property (nonatomic, strong) UIButton* photoBtn;
@property (nonatomic, strong) UIImageView* photoImageView;
@property (nonatomic, strong) UIImageView* shadeImageView;
@end

@implementation RegisterInfomationTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
#pragma maek - SubViews
- (void)configureSubview
{
    [self.contentView addSubview:self.photoImageView];
    [self.contentView addSubview:self.shadeImageView];
    [self.contentView addSubview:self.photoBtn];
    [self.contentView addSubview:self.photoLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_photoImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        [_shadeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        [_photoBtn mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.mas_equalTo(self.contentView).offset(-20);
            make.centerX.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        [_photoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(_photoBtn.bottom).offset(10);
        }];
        self.didSetupConstraints = YES;
    }

    [super updateConstraints];
}

#pragma mark - Getters & Setters
- (void)setPhotoText:(NSString*)photoText
{
    _photoText = [photoText copy];
    _photoLabel.text = photoText;
}
- (void)setPhotoImage:(UIImage*)photoImage
{
    _photoImage = photoImage;
    _photoImageView.image = photoImage;
}
- (UILabel*)photoLabel
{
    if (!_photoLabel) {
        _photoLabel = [[UILabel alloc] init];
        _photoLabel.numberOfLines = 1;
        _photoLabel.font = [UIFont systemFontOfSize:18];
        _photoLabel.textColor = [UIColor whiteColor];
        _photoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _photoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _photoLabel;
}
- (UIButton*)photoBtn
{
    if (!_photoBtn) {
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBtn setImage:[UIImage imageNamed:@"yt_register_uploadImage.png"] forState:UIControlStateNormal];
        _photoBtn.userInteractionEnabled = NO;
    }
    return _photoBtn;
}
- (UIImageView*)photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.clipsToBounds = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _photoImageView;
}
- (UIImageView *)shadeImageView
{
    if (!_shadeImageView) {
        _shadeImageView = [[UIImageView alloc] init];
        _shadeImageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
    }
    return _shadeImageView;
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
