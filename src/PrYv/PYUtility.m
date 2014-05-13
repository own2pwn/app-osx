//
//  PYUtilities.m
//  osx-integration
//
//  Created by Victor Kristof on 04.01.14.
//  Copyright (c) 2014 Pryv. All rights reserved.
//

#import "PYUtility.h"
#import "User.h"
#import "User+Helper.h"
#import "PYStream.h"

@interface PYUtility ()

-(NSUInteger)createStreamNameForStreams:(NSArray *)streams
                                inArray:(NSMutableArray *)streamNames
                     withLevelDelimiter:(NSString *)delimiter
                                forUser:(User *)user
                                atIndex:(NSUInteger)index;
@end

@implementation PYUtility


-(void)setupStreamPopUpButton:(NSPopUpButton*)streams
           withArrayController:(NSArrayController*)popUpButtonContent
                       forUser:(User*)user{
    
    [[user connection] streamsFromCache:^(NSArray *cachedStreamsList) {
        NSMutableArray *streamNames = [[NSMutableArray alloc] init];
        
        [self createStreamNameForStreams:cachedStreamsList
                                 inArray:streamNames
                      withLevelDelimiter:@""
                                 forUser:user
                                 atIndex:0];
        
        NSRange range = NSMakeRange(0, [[popUpButtonContent arrangedObjects] count]);
        [popUpButtonContent removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        [popUpButtonContent addObjects:streamNames];
        [streams selectItemAtIndex:0];
        
        [streamNames release];
    } andOnline:^(NSArray *onlineStreamList) {
        NSMutableArray *streamNames = [[NSMutableArray alloc] init];
        
        [self createStreamNameForStreams:onlineStreamList
                                 inArray:streamNames
                      withLevelDelimiter:@""
                                 forUser:user
                                 atIndex:0];
        
        NSRange range = NSMakeRange(0, [[popUpButtonContent arrangedObjects] count]);
        [popUpButtonContent removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        [popUpButtonContent addObjects:streamNames];
        [streams selectItemAtIndex:0];
        
        [streamNames release];
    } errorHandler:^(NSError *error) {
         NSLog(@"%@",error);
    }];
    
}

-(NSUInteger)createStreamNameForStreams:(NSArray *)streams
                                inArray:(NSMutableArray *)streamNames
                     withLevelDelimiter:(NSString *)delimiter
                                forUser:(User *)user
                                atIndex:(NSUInteger)index
{
    for (PYStream *stream in streams){
        [user.streams setObject:[stream streamId] forKey:[NSString stringWithFormat:@"%lu",index]];
        index++;
        [streamNames addObject:[NSString stringWithFormat:@"%@%@",delimiter,stream.name]];
        if ([stream.children count] > 0) {
            index = [self createStreamNameForStreams:stream.children
                                             inArray:streamNames
                                  withLevelDelimiter:@"- "
                                             forUser:user
                                             atIndex:index];
            
        }
    }
    
    return index;
    
}


@end
