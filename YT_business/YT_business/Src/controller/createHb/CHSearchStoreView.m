#import "CHSearchStoreView.h"
#import "UIButton+WebCache.h"
#import "YTQueryShopHelper.h"

static const NSInteger kDefaultPadding = 10;
static const NSInteger kSearchMinWidth = 86;
static const NSInteger kStoreItemWidth = 35;

static const NSInteger kStoreButtonTag = 1000;

@implementation StoreButton

@end

@interface CHSearchStoreView ()

@property (strong, nonatomic)NSMutableArray *storeItems;

@end

@implementation CHSearchStoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        self.storeItems = [[NSMutableArray alloc] initWithCapacity:kMaxStoreCount];
        [self configureSubview:frame];
    }
    return self;
}

#pragma mark -UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchStoreView:textFieldShouldBeginEditing:)]) {
        [_delegate searchStoreView:self textFieldShouldBeginEditing:textField];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchStoreView:textFieldDidBeginEditing:)]) {
        [_delegate searchStoreView:self textFieldDidBeginEditing:textField];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchStoreView:textFieldShouldEndEditing:)]) {
        [_delegate searchStoreView:self textFieldShouldEndEditing:textField];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchStoreView:textFieldDidEndEditing:)]) {
        [_delegate searchStoreView:self textFieldDidEndEditing:textField];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(searchStoreView:shouldChangeCharactersInRange:replacementString:)]) {
        [_delegate searchStoreView:self shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchStoreView:textFieldShouldClear:)]) {
        [_delegate searchStoreView:self textFieldShouldClear:textField];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchStoreView:textFieldShouldReturn:)]) {
        [_delegate searchStoreView:self textFieldShouldReturn:textField];
    }
    return YES;
}
#pragma mark - Event response
- (void)storeButtonClicked:(id)sender
{
    StoreButton *button = (StoreButton *)sender;
    NSInteger index = button.tag - kStoreButtonTag;
    [self removeShopItemAtIndex:index];
}
#pragma mark - Public methods
- (void)addShopItems:(NSArray *)items
{
    for (YTShop *shop in items) {
        [self addShopItem:shop];
    }
}
- (void)addShopItem:(YTShop *)shop
{
    NSInteger n = _storeItems.count;
    [self moveScrollViewFrame];
    
    CGFloat x = kDefaultPadding+n*(kStoreItemWidth+kDefaultPadding);
    StoreButton *button = [StoreButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, kDefaultPadding-3, kStoreItemWidth, kStoreItemWidth);
    button.tag = kStoreButtonTag + n;
    button.shopId = shop.shopId;
    [button sd_setImageWithURL:[NSURL URLWithString:shop.img] forState:UIControlStateNormal placeholderImage:YTNormalPlaceImage];
    [button addTarget:self action:@selector(storeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    [_storeItems addObject:button];
}
- (void)removeShop:(YTShop *)shop
{
    for (StoreButton *button in _storeItems) {
        if ([button.shopId isEqualToString:shop.shopId]) {
            [self removeShopItemAtIndex:(button.tag - kStoreButtonTag)];
            break;
        }
    }
}
- (void)removeShopItemAtIndex:(NSInteger)index
{
    [[YTQueryShopHelper queryShopHelper].shopArray removeObjectAtIndex:index];
    [self moveScrollViewFrame];
    StoreButton * button = [_storeItems objectAtIndex:index];
    [_storeItems removeObjectAtIndex:index];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect lastFrame = button.frame;
        CGRect curFrame;
        for (NSInteger i=index; i < [_storeItems count]; i++) {
            StoreButton *temp = [_storeItems objectAtIndex:i];
            curFrame = temp.frame;
            [temp setFrame:lastFrame];
            lastFrame = curFrame;
            temp.tag = kStoreButtonTag+i;
        }
    }];
    if ([self.delegate respondsToSelector:@selector(searchStoreView:didRemoverItem:)]) {
        [_delegate searchStoreView:self didRemoverItem:button];
    }
    [button removeFromSuperview];
}

#pragma mark - Private methods
- (void)moveScrollViewFrame
{
    NSInteger count = [YTQueryShopHelper queryShopHelper].shopArray.count;
    CGRect rect = _scrollView.frame;
    CGFloat sWidth = count*(kDefaultPadding+kStoreItemWidth);
    CGFloat sMaxWidth = CGRectGetWidth(self.bounds) - kSearchMinWidth;
    if (sWidth > sMaxWidth) {
        _scrollView.contentSize = CGSizeMake(sWidth, 0);
        sWidth = sMaxWidth;
    } else {
        _scrollView.contentSize = CGSizeMake(0, 0);
    }
    rect.size.width = sWidth;
    _scrollView.frame = rect;
    
    CGRect searchRect = _searchField.frame;
    searchRect.origin.x = kDefaultPadding + sWidth;
    searchRect.size.width = CGRectGetWidth(self.bounds) - searchRect.origin.x;
    _searchField.frame = searchRect;
}
#pragma mark - subviews
-(void)configureSubview:(CGRect)frame
{
    [self addSubview:self.searchField];
    [self addSubview:self.scrollView];
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-1, CGRectGetWidth(self.bounds), 1)];
    bottomLine.image = YTlightGrayBottomLineImage;
    [self addSubview:bottomLine];
}

#pragma mark - Setter & Getter
- (UITextField *)searchField
{
    if (!_searchField) {
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(kDefaultPadding, 0, CGRectGetWidth(self.bounds)-kDefaultPadding, CGRectGetHeight(self.bounds))];
        _searchField.tintColor = [UIColor redColor];
        _searchField.borderStyle = UITextBorderStyleNone;
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.enablesReturnKeyAutomatically = YES;
        _searchField.placeholder = @"搜索";
        _searchField.delegate = self;

    }
    return _searchField;
}
- (UIScrollView *)scrollView
{
    if ((!_scrollView)) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.bounds))];
    }
    return _scrollView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
