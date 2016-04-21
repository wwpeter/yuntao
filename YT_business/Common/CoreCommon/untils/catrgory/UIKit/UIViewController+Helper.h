
#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface UIViewController (Helper)

- (void)setExtraCellLineHidden: (UITableView *)tableView;
- (void)showAlert:(NSString*)msg title:(NSString*)title;
- (void)callPhoneNumber:(NSString*)phoneNum;
- (void)userLogin;
- (void)showContentViewControllerAtIndex:(NSInteger)index;
- (void)openNavigation:(CLLocationCoordinate2D)destination destinationNamen:(NSString*)name;
@end
