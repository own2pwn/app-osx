//
//  PRYVFileController.m
//  PrYv
//
//  Created by Victor Kristof on 01.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PRYVFileController.h"
#import "PRYVAppDelegate.h"
#import "File.h"
#import "User.h"
#import "User+Extras.h"
#import "NSString+Helper.h"

@implementation PRYVFileController

-(id)initWithOpenPanel:(NSOpenPanel *)o{
	self = [super init];
	if (self) {
		openDialog = o;
		[openDialog setCanChooseFiles:YES];
		[openDialog setAllowsMultipleSelection:YES];
		[openDialog setCanChooseDirectories:YES];
		[openDialog setCanCreateDirectories:YES];
		[openDialog setResolvesAliases:YES];
		threadLock = [[NSLock alloc] init];
	}
	return self;
}

-(void)runDialog{
	// This method displays the panel and returns immediately.
	// The completion handler is called when the user selects an
	// item or cancels the panel.
	[openDialog beginWithCompletionHandler:^(NSInteger result){
		if (result == NSFileHandlingPanelOKButton) {
			
			NSArray *files = [openDialog URLs];
			[NSThread detachNewThreadSelector:@selector(pryvFiles:) toTarget:self withObject:files];
		}
		[openDialog release];//Mac OS X 10.6 fix
		
	}];
}

-(void)pryvFiles:(NSArray *)files{
	[threadLock lock];
	@autoreleasepool {
		NSMutableArray *filesToSend = [[NSMutableArray alloc] init];
		// Loop through the files to create File entities that we add in an NSArray in order to prepare them for the FileEvent.
		[files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[PRYVFileController constructFilesArray:filesToSend withFile:[obj path] inSubfolder:@""];
		}];
		
		//Enumerate the filesToSend array to create the FileEvent and try to send it.
		
	}
	[threadLock unlock];

}
//Recursively add files with their hierarchical structure to the array
+(void)constructFilesArray:(NSMutableArray*)array
				   withFile:(NSString*)file
				inSubfolder:(NSString*)subfolder{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:file error:nil];
	
	if ([fileAttributes valueForKey:NSFileType] == NSFileTypeDirectory) {
		NSError *error = nil;
		NSArray *folderContent = [fileManager contentsOfDirectoryAtPath:file error:&error];
		if(folderContent == nil){
			NSLog(@"Directory %@ couldn't be open : %@",file, error);
		}else{
			NSString *folderName = [[file lastPathComponent] stringByAppendingString:@"/"];
			[folderContent enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				if ([obj characterAtIndex:0] != '.') {
					[PRYVFileController constructFilesArray:array withFile:[file stringByAppendingPathComponent:obj] inSubfolder:folderName];
				}
				
			}];
		}
		
	} else {
		NSManagedObjectContext *context = [[PRYVAppDelegate sharedInstance] managedObjectContext];
		User *current = [User currentUserInContext:context];
		NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
		//Create a file object to add in the array
		File *newFile = [NSEntityDescription insertNewObjectForEntityForName:@"File" inManagedObjectContext:context];
		//Create unique id that is used to change the name in the temp directory if you already have a file with the same file name in that directory
		NSString *tempFileName = [[[[newFile objectID] URIRepresentation] relativeString] lastPathComponent];
		//Add the subfolder before the file name to trace the hierarchical structure
		newFile.filename = [subfolder stringByAppendingPathComponent:[file lastPathComponent]];
		//Path of the cached file (before pryving it)
		newFile.path = [cachesDirectory stringByAppendingPathComponent:tempFileName];
		
		newFile.size = [NSNumber numberWithInt:[fileAttributes valueForKey:NSFileSize]];
		newFile.mimeType = [NSString stringWithString:[NSString mimeTypeFromFileExtension:newFile.filename]];
		//Copy the file in the Caches directory so that we don't manipulate the original object.
		NSString *copyPath = newFile.path;
		NSError *error = nil;
		if (![fileManager copyItemAtPath:file toPath:copyPath error:&error]) {
			NSLog(@"File %@ couldn't be copied : %@",file, error);
		} else{
			NSLog(@"File %@ copied !",file);
			//Store the files one by one to be sure that if the application quits, the work done so far is saved.
			[current addFilesObject:newFile];
			[context save:nil];
			[array addObject:newFile];
		}
		
	}

}

-(void)dealloc{
	[threadLock release];
	[super dealloc];
}
@end
