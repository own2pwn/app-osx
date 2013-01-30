//
//  PRYVAppDelegate.m
//  PrYv
//
//  Created by Victor Kristof on 21.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PRYVAppDelegate.h"
#import "PRYVApiClient.h"
#import "User.h"
#import "User+Extras.h"
#import "PRYVLoginController.h"

@implementation PRYVAppDelegate

- (void)dealloc
{
	[_persistentStoreCoordinator release];
	[_managedObjectModel release];
	[_managedObjectContext release];
	[_statusItem release];
    [super dealloc];
}

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize statusMenu = _statusMenu;
@synthesize statusItem = _statusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	//Try to retrieve the user from the CoreData DB
	User * user = [User currentUserInContext:[self managedObjectContext]];
	
	//If no user has been found, open login window
	if (user==nil) {		
		PRYVLoginController *loginWindow = [[PRYVLoginController alloc] initForUser:user];
		[loginWindow showWindow:self];
	
	//If the user has been found, be ready to create notes
	}else{
		NSLog(@"Welcome back, %@ !",user.username);
	}
	
//	NSURL *requestURL = [NSURL URLWithString:@"https://jonmaim.rec.la/channels"];
//	
//	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
//	[request setHTTPMethod:@"POST"];
//	[request setValue:@"VVEQmJD5T5" forHTTPHeaderField:@"Authorization"];
//	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//	
//	NSDictionary *body = @{
//			@"name": @"Mac OS X Application" 
//	};
//	
//	NSError *error = nil;
//	NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
//	if(!error){[request setHTTPBody:bodyData];}
//	
//	NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
//	
//	[NSURLConnection sendAsynchronousRequest:request
//									   queue:backgroundQueue
//						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//							   if (!error) {
//								   NSDictionary *requestResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//								   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//								   if ([httpResponse statusCode] >= 400) {
//									   NSLog(@"Remote URL returned error %ld %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
//									   NSLog(@"Result : %@", requestResults);
//									   NSLog(@"ID : %@",[requestResults valueForKey:@"id"]);
//									   
//									   //We make another request to get the list of channels and get the id from the result
//									   NSMutableString *channelId = [[NSMutableString alloc] initWithString:@"test"];
//									   //[PRYVApiClient getChannelIdForName:@"Mac OS X Application" ForUser:@"jonmaim" WithAccessToken:@"VVEQmJD5T5" ToChannelId:&channelId];
//
//									   //NSLog(@"Check for ID : %@", channelId);
//									   
//								   } else {
//									   NSLog(@"It is the first time you try to create the channel");
//									   NSLog(@"Result : %@", requestResults);
//									   NSLog(@"ID : %@",[requestResults valueForKey:@"id"]);
//								   }
//								   //channelId = [requestResults valueForKey:@"id"];
//								   //NSString *requestResults = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
//							   } else {
//								   NSLog(@"Error in sendAsynchronousRequest : %@",error);
//								   NSString *requestResults = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
//								   NSLog(@"Result : %@", requestResults);
//								   NSLog(@"Response : %@", [response URL]);
//							   }
//						   }];
}

-(void) awakeFromNib{
	
	NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
	_statusItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
	[_statusItem retain];
	
	//[_statusItem setTitle:@"Y"];
	[_statusItem setImage:[NSImage imageNamed:@"FaviconBlack56.png"]];
	[_statusItem setHighlightMode:YES];
	[_statusItem setMenu:_statusMenu];
	[_statusMenu setAutoenablesItems:YES];
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "pryv.PrYv" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"pryv.PrYv"];
}

//Enables singleton using Grand Central
+ (PRYVAppDelegate*)sharedInstance
{
	static dispatch_once_t pred;
	static PRYVAppDelegate *sharedInstance = nil;
	dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
	return sharedInstance;
}


// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PrYv" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"PrYv.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom] autorelease];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = [coordinator retain];
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
