//
//  TTHPageViewController.m
//  TimeToHome
//
//  Created by Maxwell Elliott on 2/16/14.
//
//

#import "TTHPageViewController.h"
#import "TTHFirstViewController.h"
#import "TTHSecondViewController.h"

@interface TTHPageViewController ()

@end

@implementation TTHPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    _locationManager.delegate = self;
    [_locationManager stopMonitoringSignificantLocationChanges];
    [_locationManager setDistanceFilter:500];
    [_locationManager startUpdatingLocation];
}

-(id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options
{
    self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
    if (self) {
        _currentIndex = 0;
        TTHFirstViewController *firstViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"FirstViewController"];
        [self setViewControllers:@[firstViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        [self setDelegate:self];
        [self setDataSource:self];
        TTHSecondViewController *secondViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SecondViewController"];
        _allViewControllers = @[firstViewController, secondViewController];
    }
    return self;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    NSInteger currentIndex = [_allViewControllers indexOfObject:viewController];
    if (currentIndex == 1) {
        return nil;
    }
    currentIndex++;
    return (UIViewController *)[_allViewControllers objectAtIndex:currentIndex];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger currentIndex = [_allViewControllers indexOfObject:viewController];
    if(currentIndex == 0) {
        return nil;
    }
    currentIndex--;
    return (UIViewController *)[_allViewControllers objectAtIndex:currentIndex];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

#pragma "Location Manager Delegate Code"

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (id viewController in _allViewControllers) {
        SEL selector = NSSelectorFromString(@"refreshTimeLabels");
        [viewController performSelector:selector withObject:nil];
    }
}

-(UIStoryboard *)storyboard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
