//
//  Created by Konstantin Dorodov on 1/4/13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//


#import "User+Helper.h"
#import "Constants.h"
#import "PryvedEvent.h"
#import "Constants.h"
#import "SSKeychain.h"

@implementation User (Helper)



+ (void)saveConnection:(PYConnection *)connection
{
    if (connection == nil) {
        if (_currentUser) {
            [SSKeychain deletePasswordForService:kServiceName account:_currentUser.connection.userID];
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLastUsedUsernameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:connection.userID forKey:kLastUsedUsernameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SSKeychain setPassword:connection.accessToken forService:kServiceName account:connection.userID];
    }
    _currentUser = nil;
    
}


static User* _currentUser;
+ (User *)currentUser {
	if (_currentUser) {
        return _currentUser;
    }
    
    NSString *lastUsedUsername = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUsedUsernameKey];
    if(lastUsedUsername)
    {
        NSString *accessToken = [SSKeychain passwordForService:kServiceName account:lastUsedUsername];
        NSLog(@"LoadedSavedConnection: %@", lastUsedUsername);
        _currentUser = [self createNewUserWithUsername:lastUsedUsername AndToken:accessToken];
        
    }
    
    return _currentUser;
    
}

+(User*)createNewUserWithUsername:(NSString *)username
                         AndToken:(NSString *)token{
	
    User* newUser = [[[User alloc] init] autorelease];
	
    newUser.username = username;
    newUser.token = token;
    newUser.connection = [PYClient createConnectionWithUsername:newUser.username andAccessToken:newUser.token];
    return newUser;
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

-(void)updateNumberOfPryvedEvents {
    
    if ([self.pryvedEvents count] >  kPYNumberOfLastPryvedEvents) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSArray *sortedEvents = [self.pryvedEvents sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [sortDescriptor release];
        
        NSRange range;
        range.location = 0;
        range.length = kPYNumberOfLastPryvedEvents;
        
        NSArray *reducedArray = [sortedEvents subarrayWithRange:range];
        
        NSSet *reducedSet = [NSSet setWithArray:reducedArray];
        [self removePryvedEvents:self.pryvedEvents];
       
        [self addPryvedEvents:reducedSet];
     
    }
    
    
}

-(void)logout{
    [User saveConnection:nil];
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