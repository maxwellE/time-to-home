//
//  TTHFirstViewController.m
//  TimeToHome
//
//  Created by Maxwell Elliott on 12/9/13.
//
//

#import "TTHFirstViewController.h"
#import "TTHAddressSearchViewController.h"
#import "Location.h"

@interface TTHFirstViewController ()

@end

@implementation TTHFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(NSString *)getTotalTravelTimeForResponseObject: (id)responseObject {
    NSArray *routes = [responseObject objectForKey:@"routes"];
    NSDictionary *route = [routes objectAtIndex:0];
    NSArray *legs = [route objectForKey:@"legs"];
    if (route) {
        NSDictionary *legsDictionary = [legs objectAtIndex:0];
        // Will only happen if this is a bus result.
        if ([legsDictionary objectForKey:@"arrival_time"]) {
            NSDate *currentTime = [[NSDate alloc] init];
            id arrivalTimeValue = [[legsDictionary objectForKey:@"arrival_time"] objectForKey:@"value"];
            NSDate *arrivalTime = [[NSDate alloc] initWithTimeIntervalSince1970: [arrivalTimeValue doubleValue]];
            double trueTotalBusTime = ceil([arrivalTime timeIntervalSinceDate:currentTime]);
            int totalBusTimeInMinutes = trueTotalBusTime / 60;
            return [NSString stringWithFormat:@"%d mins", totalBusTimeInMinutes];
        }
        return [[legsDictionary objectForKey:@"duration"] objectForKey:@"text"];
    }
    return @"Error! Please retry.";
}

- (void)updateUberWaitTimeHomeTextLabel: (CLLocation *)location {
    NSString *locationCoordinateString = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    Location *homeLocation = [Location grabUserHomeLocation];
    if (!homeLocation) {
        [_uberTimeLabel setText:@"No home address set."];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: @"http://maps.googleapis.com/maps/api/directions/json" parameters:@{@"origin": locationCoordinateString, @"destination": [homeLocation address], @"sensor": @"true"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *time = [self getTotalTravelTimeForResponseObject:responseObject];
        [_uberTimeLabel setText:time];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)updateUberWaitTimeWorkTextLabel: (CLLocation *)location {
    NSString *locationCoordinateString = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    Location *workLocation = [Location grabUserWorkLocation];
    if (!workLocation) {
        [_workUberTimeLabel setText:@"No work address set."];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: @"http://maps.googleapis.com/maps/api/directions/json" parameters:@{@"origin": locationCoordinateString, @"destination": [workLocation address], @"sensor": @"true"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *time = [self getTotalTravelTimeForResponseObject:responseObject];
        [_workUberTimeLabel setText:time];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)updateBusWaitTimeHomeTextLabel: (CLLocation *)location {
    NSString *locationCoordinateString = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    Location *homeLocation = [Location grabUserHomeLocation];
    if (!homeLocation) {
        [_busTimeLabel setText:@"No home address set."];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: @"http://maps.googleapis.com/maps/api/directions/json" parameters:@{@"origin": locationCoordinateString, @"destination": [homeLocation address], @"sensor": @"true", @"mode": @"transit", @"departure_time": [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *time = [self getTotalTravelTimeForResponseObject:responseObject];
        [_busTimeLabel setText:time];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)updateBusWaitTimeWorkTextLabel: (CLLocation *)location {
    NSString *locationCoordinateString = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    Location *workLocation = [Location grabUserWorkLocation];
    if (!workLocation) {
        [_workBusTimeLabel setText:@"No work address set."];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: @"http://maps.googleapis.com/maps/api/directions/json" parameters:@{@"origin": locationCoordinateString, @"destination": [workLocation address], @"sensor": @"true", @"mode": @"transit", @"departure_time": [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *time = [self getTotalTravelTimeForResponseObject:responseObject];
        [_workBusTimeLabel setText:time];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TTHAddressSearchViewController *asvc = [segue destinationViewController];
    asvc.currentUserLocation = [_locationManager location];
    asvc.segueIdentifier = [segue identifier];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    [_locationManager setDistanceFilter:500];
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void)updateTimesForHomeAddressChange {
    CLLocation *location = [_locationManager location];
    [self updateUberWaitTimeHomeTextLabel:location];
    [self updateBusWaitTimeHomeTextLabel:location];
}

-(void)updateTimesForWorkAddressChange {
    CLLocation *location = [_locationManager location];
    [self updateUberWaitTimeWorkTextLabel:location];
    [self updateBusWaitTimeWorkTextLabel:location];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    [self updateUberWaitTimeHomeTextLabel:location];
    [self updateBusWaitTimeHomeTextLabel:location];
    [self updateUberWaitTimeWorkTextLabel:location];
    [self updateBusWaitTimeWorkTextLabel:location];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
