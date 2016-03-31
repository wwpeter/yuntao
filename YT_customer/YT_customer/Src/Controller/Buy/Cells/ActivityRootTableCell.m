#import "ActivityRootTableCell.h"
#import <UIImageView+WebCache.h>
#import "YTActivityModel.h"

@implementation ActivityRootTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}

#pragma mark - Public methods
- (void)configCellWithActivity:(YTActivity*)activity
{
    [self.activImageView sd_setImageWithURL:[NSURL URLWithString:activity.img] placeholderImage:YTNormalPlaceImage];

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
#pragma maek - SubViews
- (void)configureSubview
{
    self.activImageView = [[UIImageView alloc] init];
//    self.activImageView.clipsToBounds = YES;
//    self.activImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.activImageView];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {

        [_activImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.edges.mas_equalTo(self.contentView);
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
