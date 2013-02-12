//
//  Created by Konstantin Dorodov on 1/4/13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//


#import "User+Helper.h"
#import "Folder.h"
#import "FileEvent.h"
#import "Event.h"
#import "FileEvent+Helper.h"

@implementation User (Helper)

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
	newUser.events = [[NSSet alloc] init];
	
	Folder *newFolder1 = (Folder*)[NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:context];
	newFolder1.name = @"Top Secret";
	Folder *newFolder2 = (Folder*)[NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:context];
	newFolder2.name = @"Shared";
	Folder *newFolder3 = (Folder*)[NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:context];
	newFolder3.name = @"Funny";
	Folder *newFolder4 = (Folder*)[NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:context];
	newFolder4.name = @"Work";
	newUser.folders = [NSMutableSet setWithObjects:newFolder1,newFolder2,newFolder3,newFolder4, nil];
	
    [context save:nil];
    
    return newUser;
}

-(void)purgeEventsInContext:(NSManagedObjectContext *)context{
	
	[self.events enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		if ([obj isKindOfClass:[FileEvent class]]) {
			[(FileEvent*)obj deleteFiles];
		}
		[context deleteObject:obj];
	}];
	[context save:nil];
	NSLog(@"Events purged !");
}

-(NSArray*)folderNames{
	NSMutableArray *names = [[NSMutableArray alloc] init];
	[self.folders enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		[names addObject:[obj name]];
	}];
	return [names autorelease];
}

-(NSString*)description{
	NSMutableString *description = [NSMutableString stringWithString:@""];
	[description appendString:@"#######################################"];
	[description appendString:@"\nCURRENT USER"];
	[description appendFormat:@"\nUsername: %@",self.username];
	[description appendFormat:@"\noAuthToken: %@",self.oAuthToken];
	__block int i = 1;
	[self.events enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		[description appendFormat:@"\n\n****** Event %d: %@ *****",i,[obj className]];
		[description appendFormat:@"%@",[obj description]];
		i++;
	}];
	return description;
}

@end