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
@property (strong, nonatomic) CLLocationManager *locationManager;
- (IBAction)segueToSettingsViewController:(id)sender;

@end
