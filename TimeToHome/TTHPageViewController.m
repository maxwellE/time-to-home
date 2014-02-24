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

+(TTHPageViewController *)initializePageViewController
{
    TTHPageViewController *pvc = (TTHPageViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PageViewController"];
    if (pvc) {
        pvc.currentIndex = 0;
        TTHFirstViewController *firstViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FirstViewController"];
        [pvc setViewControllers:@[firstViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        [pvc setDelegate:pvc];
        [pvc setDataSource:pvc];
        TTHSecondViewController *secondViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SecondViewController"];
        pvc.allViewControllers = @[firstViewController, secondViewController];
    }
    return pvc;
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
