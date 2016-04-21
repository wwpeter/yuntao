#import "CHCostView.h"
#import "UIImage+HBClass.h"

static const NSInteger kDoneBtnWidth = 120;

@interface CHCostView ()


@end

@implementation CHCostView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        [self configureSubview:frame];
    }
    return self;
}
#pragma mark - Event response
- (void)backButtonClicked:(id)sender
{
    if (self.selectBlock) {
        self.selectBlock(1);
    }
}
- (void)doneButtonClicked:(id)sender
{
    if (self.selectBlock) {
        self.selectBlock(2);
    }
}
#pragma mark - subviews
-(void)configureSubview:(CGRect)frame
{
    CGFloat viewWidth =  CGRectGetWidth(self.bounds);
    CGFloat viewHeight =  CGRectGetHeight(self.bounds);
    
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 1)];
    topLine.image = YTlightGrayTopLineImage;
    [self addSubview:topLine];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, viewWidth-kDoneBtnWidth, viewHeight);
    [backBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xe5e5e5)] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    UILabel *sellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, viewHeight)];
    sellLabel.font = [UIFont systemFontOfSize: 14];
    sellLabel.textColor = CCCUIColorFromHex(0x666666);
    sellLabel.text = @"建议售价";
    [self addSubview:sellLabel];
    
    _costLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, CGRectGetWidth(backBtn.bounds)-70-16, viewHeight)];
    _costLabel.font = [UIFont boldSystemFontOfSize:22];
    _costLabel.textColor = CCCUIColorFromHex(0xff5a60);
    _costLabel.text = @"￥10";
    [self addSubview:_costLabel];
    
    UIImageView *righrArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_cell_rightArrow"]];
    righrArrow.frame = CGRectMake(CGRectGetWidth(backBtn.bounds)-16, 0, 6, 9);
    righrArrow.center = CGPointMake(righrArrow.center.x, backBtn.center.y);
    [self addSubview:righrArrow];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(viewWidth-kDoneBtnWidth, 0, kDoneBtnWidth, viewHeight);
    _doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_doneButton setBackgroundColor:CCCUIColorFromHex(0xff5a60)];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
     [_doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_doneButton];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
