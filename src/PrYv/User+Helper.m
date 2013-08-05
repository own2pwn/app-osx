//
//  Created by Konstantin Dorodov on 1/4/13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//


#import "User+Helper.h"
#import "Folder.h"
#import "FileEvent.h"
#import "Event.h"
#import "FileEvent+Helper.h"
#import "Constants.h"
#import "PryvApiKit.h"

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

-(PYAccess*)access{
    return [PYClient createAccessWithUsername:self.username andAccessToken:self.token];
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

-(NSArray*)folderNames {
	NSMutableArray *names = [[NSMutableArray alloc] init];
//	[self.folders enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
//		[names addObject:[obj name]];
//	}];
	return [names autorelease];
}

-(NSString*)description {
	NSMutableString *description = [NSMutableString stringWithString:@""];
	[description appendString:@"#######################################"];
	[description appendString:@"\nCURRENT USER"];
	[description appendFormat:@"\nUsername: %@",self.username];
	//[description appendFormat:@"\noAuthToken: %@",self.oAuthToken];
	//__block int i = 1;
//	[self.events enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
//		[description appendFormat:@"\n\n****** Event %d: %@ *****",i,[obj className]];
//		[description appendFormat:@"%@",[obj description]];
//		i++;
//	}];
	return description;
}

@end