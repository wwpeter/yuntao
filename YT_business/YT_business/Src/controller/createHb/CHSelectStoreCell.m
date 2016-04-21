#import "CHSelectStoreCell.h"
#import "UIImageView+WebCache.h"
#import "CHSelectStoreViewController.h"

static const NSInteger kDefaultPadding = 10;
static const NSInteger kStoreItemWidth = 35;

NSString * const XLFormRowDescriptorTypeSelectStore = @"XLFormRowDescriptorTypeSelectStore";

@interface CHSelectStoreCell ()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation CHSelectStoreCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[CHSelectStoreCell class] forKey:XLFormRowDescriptorTypeSelectStore];
}

#pragma mark - XLFormDescriptorCell

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 50;
}

-(void)configure
{
    [super configure];
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.scrollView];
    [self setupLayout];
}

-(void)update
{
    [super update];
  
    self.nameLabel.text = self.rowDescriptor.title;
    [self updateStoreImages];
}
#pragma mark - Private methods
- (void)updateStoreImages
{
    NSArray *value = [[NSArray alloc] initWithArray:self.rowDescriptor.value];
    if (value.count > 0) {
        _nameLabel.hidden = YES;
    } else {
        _nameLabel.hidden = NO;
    }
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    for (NSInteger i = 0; i<value.count; i++) {
        CGFloat x = kDefaultPadding+i*(kStoreItemWidth+kDefaultPadding);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, kDefaultPadding-3, kStoreItemWidth, kStoreItemWidth)];
        YTShop *shop= value[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:YTNormalPlaceImage];
        [_scrollView addSubview:imageView];
         _scrollView.contentSize = CGSizeMake((i+1)*(kStoreItemWidth+kDefaultPadding), 0);
    }
}
#pragma mark - Event response
- (void)scrollViewTap:(UITapGestureRecognizer*)tap
{
     [self storeCellDidSelectedWithFormController:self.formViewController];
}
-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    [self storeCellDidSelectedWithFormController:controller];
}

- (void)storeCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    if (self.rowDescriptor.action.formSelector){
        [controller performFormSelector:self.rowDescriptor.action.formSelector withObject:self.rowDescriptor];
    }
    else if ([self.rowDescriptor.action.formSegueIdenfifier length] != 0){
        [controller performSegueWithIdentifier:self.rowDescriptor.action.formSegueIdenfifier sender:self.rowDescriptor];
    }
    else if (self.rowDescriptor.action.formSegueClass){
        UIViewController * controllerToPresent = [self controllerToPresent];
        NSAssert(controllerToPresent, @"either rowDescriptor.action.viewControllerClass or rowDescriptor.action.viewControllerStoryboardId or rowDescriptor.action.viewControllerNibName must be assigned");
        UIStoryboardSegue * segue = [[self.rowDescriptor.action.formSegueClass alloc] initWithIdentifier:self.rowDescriptor.tag source:controller destination:controllerToPresent];
        [controller prepareForSegue:segue sender:self.rowDescriptor];
        [segue perform];
    }
    else{
        UIViewController * controllerToPresent = [self controllerToPresent];
        if (controllerToPresent){
            if ([controllerToPresent conformsToProtocol:@protocol(XLFormRowDescriptorViewController)]){
                ((UIViewController<XLFormRowDescriptorViewController> *)controllerToPresent).rowDescriptor = self.rowDescriptor;
            }
            if (controller.navigationController == nil || [controllerToPresent isKindOfClass:[UINavigationController class]] || self.rowDescriptor.action.viewControllerPresentationMode == XLFormPresentationModePresent){
                [controller presentViewController:controllerToPresent animated:YES completion:nil];
            }
            else{
                [controller.navigationController pushViewController:controllerToPresent animated:YES];
            }
        }
        
    }
}
#pragma mark - Helpers

-(UIViewController *)controllerToPresent
{
    if (self.rowDescriptor.action.viewControllerClass){
        return [[self.rowDescriptor.action.viewControllerClass alloc] init];
    }
    else if ([self.rowDescriptor.action.viewControllerStoryboardId length] != 0){
        UIStoryboard * storyboard =  [self storyboardToPresent];
        NSAssert(storyboard != nil, @"You must provide a storyboard when rowDescriptor.action.viewControllerStoryboardId is used");
        return [storyboard instantiateViewControllerWithIdentifier:self.rowDescriptor.action.viewControllerStoryboardId];
    }
    else if ([self.rowDescriptor.action.viewControllerNibName length] != 0){
        Class viewControllerClass = NSClassFromString(self.rowDescriptor.action.viewControllerNibName);
        NSAssert(viewControllerClass, @"class owner of self.rowDescriptor.action.viewControllerNibName must be equal to %@", self.rowDescriptor.action.viewControllerNibName);
        return [[viewControllerClass alloc] initWithNibName:self.rowDescriptor.action.viewControllerNibName bundle:nil];
    }
    return nil;
}

-(UIStoryboard *)storyboardToPresent
{
    if ([self.formViewController respondsToSelector:@selector(storyboardForRow:)]){
        return [self.formViewController storyboardForRow:self.rowDescriptor];
    }
    if (self.formViewController.storyboard){
        return self.formViewController.storyboard;
    }
    return nil;
}


-(void)setupLayout
{
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(16);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-20);
    }];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-20);
    }];
}
#pragma mark - Setter & Getter
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.userInteractionEnabled = NO;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}
- (UIScrollView *)scrollView
{
    if ((!_scrollView)) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)]];
    }
    return _scrollView;
}
@end
