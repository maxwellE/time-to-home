//
//  TTHFirstViewController.h
//  TimeToHome
//
//  Created by Maxwell Elliott on 12/9/13.
//
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface TTHFirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *uberTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *busTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *uberTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *busTimeTitleLabel;

@end
