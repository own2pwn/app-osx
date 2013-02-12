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
#import "User+Helper.h"
#import "NSString+Helper.h"
#import "Tag.h"
#import "Tag+Helper.h"
#import "Folder.h"
#import "Folder+Helper.h"
#import "FileEvent.h"

@implementation PRYVFileController

-(id)initWithOpenPanel:(NSOpenPanel *)o{
	self = [super init];
	if (self) {
		openDialog = o;
		[openDialog setCanChooseFiles:YES];
		[openDialog setAllowsMultipleSelection:YES];
		[openDialog setCanChooseDirectories:YES];
		[openDialog setCanCreateDirectories:NO];
		[openDialog setResolvesAliases:YES];
		threadLock = [[NSLock alloc] init];
	}
	return self;
}

-(void)runDialog{
	NSManagedObjectContext *context = [[PRYVAppDelegate sharedInstance] managedObjectContext];
	//Add the fields for the tags and the folder
	if ([NSBundle loadNibNamed:@"OpenPanelWithTagsAndFolder" owner:self])
		[openDialog setAccessoryView:accessoryView];
	
	//Get the folder names list and fill the popup button
	User* current = [User currentUserInContext:context];
	NSArray *folderNames = [current folderNames];
	[folder addItemsWithTitles: folderNames];
	
	//Handle result
	[openDialog beginWithCompletionHandler:^(NSInteger result){
		if (result == NSFileHandlingPanelOKButton) {
			//Get the tags for the event
			NSMutableSet *newTags = [[NSMutableSet alloc] init];
			[[tags objectValue] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				[newTags addObject:[Tag tagWithValue:obj inContext:context]];
			}];
			//Get the folder
			NSString* folderName;
			if ([[folder titleOfSelectedItem] isEqualTo:@"None"]) {
				folderName = @"";
			}else{
				folderName = [NSString stringWithString:[folder titleOfSelectedItem]];
			}
			NSArray *files = [openDialog URLs];
			
			NSArray *objects = [NSArray arrayWithObjects: files, newTags, folderName, nil];
			NSArray *keys = [NSArray arrayWithObjects:@"files",@"tags",@"folder", nil];
			NSDictionary *arguments = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
			[NSThread detachNewThreadSelector:@selector(pryvFiles:) toTarget:self withObject:arguments];
		}
		[openDialog release];//Mac OS X 10.6 fix
		
	}];
}

-(void)pryvFiles:(NSDictionary *)args{
	[threadLock lock];
	@autoreleasepool {
		NSSet *files = [NSSet setWithArray:[args objectForKey:@"files"]];
		NSSet *newTags = [NSSet setWithSet:[args objectForKey:@"tags"]];
		NSString *folderName = [NSString stringWithString:[args objectForKey:@"folder"]];
		//Construct the array of files @filesToSend recursively
		//The hierarchical structure is kept in the filename
		NSMutableArray *filesToSend = [[NSMutableArray alloc] init];
		[files enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
			[PRYVFileController constructFilesArray:filesToSend withFile:[obj path] inSubfolder:@""];
		}];
		
		//Create the FileEvent and store it
		NSManagedObjectContext *context = [[PRYVAppDelegate sharedInstance] managedObjectContext];
		User *current = [User currentUserInContext:context];
		FileEvent *fileEvent = (FileEvent*)[NSEntityDescription insertNewObjectForEntityForName:@"FileEvent" inManagedObjectContext:context];
		[fileEvent addTags:newTags];
		[fileEvent addFiles:[NSSet setWithArray:filesToSend]];
		fileEvent.folder = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:context];
		fileEvent.folder.name = folderName;
		
		[current addEventsObject:fileEvent];
		
		[context save:nil];
		[filesToSend release];
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
			[array addObject:newFile];
		}
		
	}

}


-(void)dealloc{
	[threadLock release];
	[super dealloc];
}
@end
