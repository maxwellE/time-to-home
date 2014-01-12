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

+ (Location *)grabUserHomeLocation {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[Location entityName] inManagedObjectContext:[Location mainQueueContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isHome == TRUE"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[Location mainQueueContext] executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects.lastObject;
}

@end
