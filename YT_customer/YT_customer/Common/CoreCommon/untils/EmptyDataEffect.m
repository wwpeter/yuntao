#import "EmptyDataEffect.h"
#import "YTNetworkMange.h"

@implementation EmptyDataEffect
+ (NSAttributedString*)titleForEmptyDataEffectType:(EmptyDataEffectType)effectType
{
    NSString* text = nil;
    UIFont* font = [UIFont systemFontOfSize:18];
    UIColor* textColor = nil;
    NSMutableDictionary* attributes = [NSMutableDictionary new];
    EmptyDataEffectType type = [self setupEffectType:effectType];

    switch (type) {
    case EmptyDataEffectTypeNetworkNone: {
        text = @"加载失败,请检查您的网络";
    } break;
    case EmptyDataEffectTypeNetworkError: {
        text = @"加载失败,请检查您的网络";
    } break;
    case EmptyDataEffectTypeLocationError: {
        text = @"无法获取您的当前位置哦~";
    } break;
        case EmptyDataEffectTypeSearchStore: {
            text = @"没有搜索结果";
        } break;
        case EmptyDataEffectTypeHehe: {
        text = @"";
    } break;

    default:
        return nil;
        break;
    }
    if (!text) {
        return nil;
    }

    if (font)
        [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor)
        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
+ (NSAttributedString*)descriptionForEmptyDataEffectType:(EmptyDataEffectType)effectType
{
    NSString* text = nil;
    UIFont* font = [UIFont systemFontOfSize:16];
    UIColor* textColor = nil;
    NSMutableDictionary* attributes = [NSMutableDictionary new];
    EmptyDataEffectType type = [self setupEffectType:effectType];
    switch (type) {
    case EmptyDataEffectTypeNetworkNone: {
        text = @"请检查网络设置";
    } break;
    case EmptyDataEffectTypeNetworkError: {
        text = @"请检测网络后重试";
    } break;
    case EmptyDataEffectTypeLocationError: {
        text = @"请检查是否开启定位服务,点击屏幕重试";
    } break;
    case EmptyDataEffectTypeHehe: {
        text = @"";
    } break;

    default:
        return nil;
        break;
    }
    if (!text) {
        return nil;
    }

    if (font)
        [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor)
        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
+ (UIImage*)imageForEmptyDataEffectType:(EmptyDataEffectType)effectType
{
    UIImage* image = nil;
    EmptyDataEffectType type = [self setupEffectType:effectType];
    switch (type) {
    case EmptyDataEffectTypeNetworkNone: {
        image = [UIImage imageNamed:@"dk_networkerror_image.png"];
    } break;
    case EmptyDataEffectTypeNetworkError: {
        image = [UIImage imageNamed:@"dk_networkerror_image.png"];
    } break;
        case EmptyDataEffectTypeLocationError: {
            image = [UIImage imageNamed:@"yt_location_errorIcon.png"];
        } break;
    case EmptyDataEffectTypeHehe: {
    } break;

    default:
        return nil;
        break;
    }
    if (!image) {
        return nil;
    }
    return image;
}
+ (NSAttributedString*)buttonTitleForEmptyDataEffectType:(EmptyDataEffectType)effectType
{

    NSString* text = nil;
    UIFont* font = [UIFont systemFontOfSize:15];
    UIColor* textColor = [UIColor colorWithRed:0.055 green:0.518 blue:0.949 alpha:1.0];
    EmptyDataEffectType type = [self setupEffectType:effectType];
    switch (type) {
    case EmptyDataEffectTypeNetworkNone:
    case EmptyDataEffectTypeNetworkError: {
        text = @"重新加载";
    } break;
        case EmptyDataEffectTypeLocationError: {
            textColor = [UIColor colorWithRed:253.0/255.0 green:92.0/255.0 blue:99.0/255.0 alpha:1.0];
            text = @"重新定位";
        } break;
    default:
        return nil;
        break;
    }

    if (!text) {
        return nil;
    }

    NSMutableDictionary* attributes = [NSMutableDictionary new];
    if (font)
        [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor)
        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
+ (UIImage*)buttonBackgroundImageForState:(UIControlState)state effectType:(EmptyDataEffectType)effectType
{
    UIImage* image = nil;
    NSString* imageName = @"";
    if (state == UIControlStateNormal)
        imageName = @"dk_networkerror_btn.png";
    if (state == UIControlStateHighlighted)
        imageName = @"dk_networkerror_btn_02.png";

    EmptyDataEffectType type = [self setupEffectType:effectType];
    switch (type) {
    case EmptyDataEffectTypeNetworkNone:
    case EmptyDataEffectTypeNetworkError: {
             image = [UIImage imageNamed:imageName];
       
    } break;
        case EmptyDataEffectTypeLocationError: {
            if (state == UIControlStateNormal)
                image = [UIImage imageNamed:@"yt_location_errorBtn_normal.png"];
            if (state == UIControlStateHighlighted)
                image = [UIImage imageNamed:@"yt_location_errorBtn_select.png"];
            
        } break;
    case EmptyDataEffectTypeHehe: {

    } break;

    default:
        return nil;
        break;
    }
    if (!image) {
        return nil;
    }
    return [[image stretchableImageWithLeftCapWidth:20 topCapHeight:20] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0.0, -70, 0.0, -70)];
}
+ (EmptyDataEffectType)setupEffectType:(EmptyDataEffectType)effectType
{
    EmptyDataEffectType type = effectType;
    NSInteger errorCode = [YTNetworkMange sharedMange].errorCode;
    if (errorCode < 0) {
        if (errorCode == -1009) {
            type = EmptyDataEffectTypeNetworkNone;
        }
        else {
            type = EmptyDataEffectTypeNetworkError;
        }
    }
    return type;
}

@end
