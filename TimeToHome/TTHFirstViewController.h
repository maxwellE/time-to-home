//
//  TTHFirstViewController.h
//  TimeToHome
//
//  Created by Maxwell Elliott on 12/9/13.
//
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

@interface TTHFirstViewController : UIViewController<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *uberTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *busTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workBusTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workUberTimeLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)reduceLocationAccuracy;
@end
