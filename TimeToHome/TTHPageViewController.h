//
//  TTHPageViewController.h
//  TimeToHome
//
//  Created by Maxwell Elliott on 2/16/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TTHPageViewController : UIPageViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate, CLLocationManagerDelegate>
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *allViewControllers;
@end
