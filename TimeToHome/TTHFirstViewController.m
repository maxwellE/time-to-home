//
//  TTHFirstViewController.m
//  TimeToHome
//
//  Created by Maxwell Elliott on 12/9/13.
//
//

#import "TTHFirstViewController.h"
#import "TTHAddressSearchViewController.h"

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
        return [[[legs objectAtIndex:0] objectForKey:@"duration"] objectForKey:@"text"];
    }
    return @"Error! Please retry.";
}

- (void)updateUberWaitTimeTextLabel: (CLLocation *)location {
    NSString *locationCoordinateString = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: @"http://maps.googleapis.com/maps/api/directions/json" parameters:@{@"origin": locationCoordinateString, @"destination": @"639 Geary Street, San Francisco CA, 94102", @"sensor": @"true"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *time = [self getTotalTravelTimeForResponseObject:responseObject];
        [_uberTimeLabel setText:time];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)updateBusWaitTimeTextLabel: (CLLocation *)location {
    NSString *locationCoordinateString = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: @"http://maps.googleapis.com/maps/api/directions/json" parameters:@{@"origin": locationCoordinateString, @"destination": @"639 Geary Street, San Francisco CA, 94102", @"sensor": @"true", @"mode": @"transit", @"departure_time": [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *time = [self getTotalTravelTimeForResponseObject:responseObject];
        [_busTimeLabel setText:time];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"homeAddressSearchSegue"])
    {
        TTHAddressSearchViewController *asvc = [segue destinationViewController];
        asvc.currentUserLocation = [_locationManager location];
    }
}

- (void)segueToSettingsViewController:(id)sender {
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    [_locationManager setDistanceFilter:500];
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    [self updateUberWaitTimeTextLabel:location];
    [self updateBusWaitTimeTextLabel:location];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
