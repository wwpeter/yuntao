#import "CHSelectImageCell.h"

NSString * const XLFormRowDescriptorTypeSelectImage = @"XLFormRowDescriptorTypeSelectImage";


@interface CHSelectImageCell ()

@property (strong, nonatomic) UILabel *leftTitleLabel;
@property (strong, nonatomic) UIImageView*rightImageView;

@end

@implementation CHSelectImageCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[CHSelectImageCell class] forKey:XLFormRowDescriptorTypeSelectImage];
}
#pragma mark - XLFormDescriptorCell

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 80;
}

-(void)configure
{
    [super configure];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;;
    
    [self.contentView addSubview:self.leftTitleLabel];
    [self.contentView addSubview:self.rightImageView];
    [self setupLayout];
}

-(void)update
{
    [super update];
    NSString *title = self.rowDescriptor.title;
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName value:CCCUIColorFromHex(0xcccccc) range:NSMakeRange(4, title.length-4)];
    self.leftTitleLabel.attributedText = str;
    [self updateSelectImage];
}
-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    if (self.rowDescriptor.action.formBlock){
        self.rowDescriptor.action.formBlock(self.rowDescriptor);
    }
    else if (self.rowDescriptor.action.formSelector){
        [controller performFormSelector:self.rowDescriptor.action.formSelector withObject:self.rowDescriptor];
    }
    else if ([self.rowDescriptor.action.formSegueIdenfifier length] != 0){
        [controller performSegueWithIdentifier:self.rowDescriptor.action.formSegueIdenfifier sender:self.rowDescriptor];
    }
    else {
        
    }

}
#pragma mark - Private methods
- (void)updateSelectImage
{
    if (self.rowDescriptor.value) {
        UIImage *image = (UIImage *)self.rowDescriptor.value;
        self.rightImageView.image =image;
    }
}
-(void)setupLayout
{
    [_leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(16);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-80);
    }];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
}
#pragma mark - Setter & Getter
- (UILabel *)leftTitleLabel
{
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc] init];
        _leftTitleLabel.userInteractionEnabled = NO;
        _leftTitleLabel.textColor = CCCUIColorFromHex(0x666666);
        _leftTitleLabel.font = [UIFont systemFontOfSize:14];
        _leftTitleLabel.numberOfLines = 1;
    }
    return _leftTitleLabel;
}
- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
        _rightImageView.layer.masksToBounds = YES;
        _rightImageView.layer.cornerRadius = 2;
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _rightImageView;
}
@end
