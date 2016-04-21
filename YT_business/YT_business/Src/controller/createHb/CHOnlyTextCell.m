
#import "CHOnlyTextCell.h"

@implementation CHOnlyTextCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = CCCUIColorFromHex(0xfff7d8);
    //override
}

- (void)update
{
    [super update];
    // override
    self.textLabel.text = self.rowDescriptor.value;
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = CCCUIColorFromHex(0xdf4248);
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return 30;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
