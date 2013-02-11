//
//  Created by Konstantin Dorodov on 1/4/13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//


#import "User+Extras.h"

@implementation User (Extras)

+ (User *)currentUserInContext:(NSManagedObjectContext *)context {
	
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
	
    return [[context executeFetchRequest:request error:nil] lastObject];
}
+(User *)createNewUserWithUsername:(NSString *)username Token:(NSString *)token ChannelId:(NSString *)channelId InContext:(NSManagedObjectContext *)context{
	
	User * newUser = [User currentUserInContext:context];
	
    if (newUser == nil) {
        newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    }
	
    newUser.username = username;
    newUser.oAuthToken = token;
    newUser.channelId = channelId;
	newUser.notes = [[NSSet alloc] init];
	newUser.files =[[NSSet alloc] init];
    
    [context save:nil];
    
    return newUser;
}

@end