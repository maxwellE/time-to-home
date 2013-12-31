//
//  Location.m
//  TimeToHome
//
//  Created by Maxwell Elliott on 12/30/13.
//
//

#import "Location.h"


@implementation Location

@dynamic address;
@dynamic isHome;

- (void)unpackDictionary:(NSDictionary *)dictionary {
    [super unpackDictionary:dictionary];
    self.address = [dictionary objectForKey:@"address"];
    self.isHome = [dictionary objectForKey:@"isHome"];
}

- (BOOL)shouldUnpackDictionary:(NSDictionary *)dictionary {
    return YES;
}

+ (NSString *)entityName {
    return @"Location";
}

@end
