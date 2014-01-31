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
@dynamic isWork;

- (void)unpackDictionary:(NSDictionary *)dictionary {
    [super unpackDictionary:dictionary];
    self.address = [dictionary objectForKey:@"address"];
    self.isHome = [dictionary objectForKey:@"isHome"];
    self.isWork = [dictionary objectForKey:@"isWork"];
}

- (BOOL)shouldUnpackDictionary:(NSDictionary *)dictionary {
    return YES;
}

+ (NSString *)entityName {
    return @"Location";
}

+ (Location *)grabUserHomeLocation {
    return [self performLocationQuery:@"isHome == TRUE"];
}

+ (Location *)performLocationQuery:(NSString *)queryString {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[Location entityName] inManagedObjectContext:[Location mainQueueContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:queryString];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[Location mainQueueContext] executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects.lastObject;
}

+ (Location *)grabUserWorkLocation {
    return [self performLocationQuery:@"isWork == TRUE"];
}

@end
