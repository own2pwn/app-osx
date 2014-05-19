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

-(void)fillPopupContent:(NSArrayController*)popUpButtonContent
        withStreamsList:(NSArray*)streamsList
         forPopUpButton:(NSPopUpButton*)streams
                forUser:(User*)user;
@end

@implementation PYUtility


-(void)setupStreamPopUpButton:(NSPopUpButton*)streams
           withArrayController:(NSArrayController*)popUpButtonContent
                       forUser:(User*)user{
    
    [[user connection] streamsFromCache:^(NSArray *cachedStreamsList) {
        
        [self fillPopupContent:popUpButtonContent
               withStreamsList:cachedStreamsList
                forPopUpButton:streams
                       forUser:user];
        
    } andOnline:^(NSArray *onlineStreamList) {
        
        [self fillPopupContent:popUpButtonContent
               withStreamsList:onlineStreamList
                forPopUpButton:streams
                       forUser:user];
        
    } errorHandler:^(NSError *error) {
         NSLog(@"%@",error);
    }];
    
}

-(void)fillPopupContent:(NSArrayController *)popUpButtonContent
        withStreamsList:(NSArray *)streamsList
         forPopUpButton:(NSPopUpButton *)streams
                forUser:(User *)user {
    
    NSMutableArray *streamNames = [[NSMutableArray alloc] init];
    
    [self createStreamNameForStreams:streamsList
                             inArray:streamNames
                  withLevelDelimiter:@""
                             forUser:user
                             atIndex:0];
    
    NSRange range = NSMakeRange(0, [[popUpButtonContent arrangedObjects] count]);
    [popUpButtonContent removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    [popUpButtonContent addObjects:streamNames];
    [streams selectItemAtIndex:0];
    
    
    [streamNames release];
    
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
