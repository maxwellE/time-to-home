//
//  TTHSecondViewController.m
//  TimeToHome
//
//  Created by Maxwell Elliott on 2/16/14.
//
//

#import "TTHSecondViewController.h"
#import "Location.h"
#import <CoreLocation/CoreLocation.h>
#import "TTHPageViewController.h"
#import <AFNetworking.h>

@interface TTHSecondViewController ()

@end

@implementation TTHSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshTimeLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Label Updating

- (void)refreshTimeLabels {
    TTHPageViewController *pvc = (TTHPageViewController *)[self parentViewController];
    CLLocation *location = [[pvc locationManager] location];
    [self updateUberWaitTimeWorkTextLabel:location];
    [self updateBusWaitTimeWorkTextLabel:location];
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
        NSString *time = [self getTotalTravelTimeForResponseObject:responseObject currentValue:_workUberTimeLabel.text];
        [_workUberTimeLabel setText:time];
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
        NSString *time = [self getTotalTravelTimeForResponseObject:responseObject currentValue:_workBusTimeLabel.text];
        [_workBusTimeLabel setText:time];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma Google Place response object logic

-(NSString *)getTotalTravelTimeForResponseObject: (id)responseObject currentValue: (NSString *)value {
    if (responseObject == nil) {
        return value;
    }
    NSArray *routes = [responseObject objectForKey:@"routes"];
    if (routes == nil || routes.count == 0) {
        return value;
    }
    NSDictionary *route = [routes objectAtIndex:0];
    NSArray *legs = [route objectForKey:@"legs"];
    if (route) {
        if (legs == nil || legs.count == 0) {
            return value;
        }
        NSDictionary *legsDictionary = [legs objectAtIndex:0];
        // Will only happen if this is a bus result.
        if ([legsDictionary objectForKey:@"arrival_time"]) {
            NSDate *currentTime = [[NSDate alloc] init];
            id arrivalTimeValue = [[legsDictionary objectForKey:@"arrival_time"] objectForKey:@"value"];
            NSDate *arrivalTime = [[NSDate alloc] initWithTimeIntervalSince1970: [arrivalTimeValue doubleValue]];
            double trueTotalBusTime = ceil([arrivalTime timeIntervalSinceDate:currentTime]);
            int totalBusTimeInMinutes = trueTotalBusTime / 60;
            if (trueTotalBusTime <= 60) {
                totalBusTimeInMinutes = 1;
            }
            return [NSString stringWithFormat:@"%d", totalBusTimeInMinutes];
        } else {
            NSInteger timeInSeconds = [[[legsDictionary objectForKey:@"duration"] objectForKey:@"value"] integerValue];
            if (timeInSeconds <= 60) {
                return @"1";
            } else {
                int timeInMinutes = timeInSeconds / 60;
                return [NSString stringWithFormat:@"%d", timeInMinutes];
            }
        }
    }
    return @"N/A";
}

@end
