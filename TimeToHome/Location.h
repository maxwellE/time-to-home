//
//  Location.h
//  TimeToHome
//
//  Created by Maxwell Elliott on 12/30/13.
//
//

#import <Foundation/Foundation.h>
#import <SSDataKit.h>

@interface Location : SSRemoteManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * isHome;
@property (nonatomic, retain) NSNumber * isWork;

+ (Location *)grabUserHomeLocation;
+ (Location *)grabUserWorkLocation;

@end
