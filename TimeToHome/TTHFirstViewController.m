//
//  TTHFirstViewController.m
//  TimeToHome
//
//  Created by Maxwell Elliott on 12/9/13.
//
//

#import "TTHFirstViewController.h"

@interface TTHFirstViewController ()

@end

@implementation TTHFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(NSString *)getUberTimeToHome: (id)responseObject {
    NSArray *routes = [responseObject objectForKey:@"routes"];
    NSDictionary *route = [routes objectAtIndex:0];
    NSArray *legs = [route objectForKey:@"legs"];
    if (route) {
        return [[[legs objectAtIndex:0] objectForKey:@"duration"] objectForKey:@"text"];
    }
    return @"Unable to contact the Goog";
}

- (void)updateUberWaitTimeTextLabel: (CLLocation *)location {
    NSString *locationCoordinateString = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: @"http://maps.googleapis.com/maps/api/directions/json" parameters:@{@"origin": locationCoordinateString, @"destination": @"639 Geary Street, San Francisco CA, 94102", @"sensor": @"true"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *time = [self getUberTimeToHome:responseObject];
        [_uberTimeLabel setText:time];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    [self updateUberWaitTimeTextLabel:location];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
