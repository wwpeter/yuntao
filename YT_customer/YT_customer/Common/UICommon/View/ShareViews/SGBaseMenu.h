//
//  SGBaseMenu.h
//  DangKe
//
//  Created by lv on 15/4/16.
//  Copyright (c) 2015年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BaseMenuBackgroundColor  [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:229.0/255.0 alpha:1.0]
#define BaseMenuCancelButtonColor  [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0]

#define BaseMenuTextColor      [UIColor darkTextColor]


@interface SGButton : UIButton
@end

@interface SGBaseMenu : UIView

// if rounded top left/right corner, default is YES.
@property (nonatomic, assign) BOOL roundedCorner;

@end
