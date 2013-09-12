//
//  Created by Konstantin Dorodov on 1/4/13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//


#import "User+Helper.h"
#import "Constants.h"

@implementation User (Helper)

+ (User *)currentUserInContext:(NSManagedObjectContext *)context {
	
    // NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:context];
    request.entity = entity;
    
    return [[context executeFetchRequest:request error:nil] lastObject];
}

+(User*)createNewUserWithUsername:(NSString *)username
                        AndToken:(NSString *)token
                        InContext:(NSManagedObjectContext*)context{
	
	User * newUser = [User currentUserInContext:context];
    if (newUser == nil) {
        newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    }
	
    newUser.username = username;
    newUser.token = token;
   
    [context save:nil];
    
    return newUser;
}

-(PYConnection*)connection{
    return [PYClient createConnectionWithUsername:self.username andAccessToken:self.token];
}

-(NSArray*)sortLastPryvedEvents{
    if ([self.pryvedEvents count] > 0) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSArray *sortedEvents = [self.pryvedEvents sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [sortDescriptor release];
        return sortedEvents;
    }else {
        return [[[NSArray alloc] init] autorelease];
    }
}

-(void)purgeEventsInContext:(NSManagedObjectContext *)context {
//	[self.events enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
//		if ([obj isKindOfClass:[FileEvent class]]) {
//			[(FileEvent*)obj deleteFiles];
//		}
//		[context deleteObject:obj];
//	}];
	[context save:nil];
	NSLog(@"Events purged !");
}

-(void)logoutFromContext:(NSManagedObjectContext *)context{
    [context deleteObject:self];
    NSLog(@"Logged out.");
    [context save:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:PYLogoutSuccessfullNotification
                                                                           object:self];
}

-(NSString*)description {
	NSMutableString *description = [NSMutableString stringWithString:@""];
	[description appendString:@"#######################################"];
	[description appendString:@"\nCURRENT USER"];
	[description appendFormat:@"\nUsername: %@",self.username];
	[description appendFormat:@"\nToken: %@",self.token];
	
	return description;
}

@end