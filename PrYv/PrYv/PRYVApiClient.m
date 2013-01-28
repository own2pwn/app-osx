//
//  PRYVApiClient.m
//  PrYv
//
//  Created by Victor Kristof on 25.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PRYVApiClient.h"

@implementation PRYVApiClient

@synthesize serverTimeInterval = _serverTimeInterval;
@synthesize userId = _userId;
@synthesize oAuthToken = _oAuthToken;
@synthesize channelId = _channelId;


+ (PRYVApiClient *)sharedClient
{
    static PRYVApiClient *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    
    return _manager;
}

+(void)getChannelIdForName:(NSString*)name
				   ForUser:(NSString*)username
		   WithAccessToken:(NSString*)oAuthToken
			   ToChannelId:(NSMutableString**)channelId
{	
	NSString *requestString = [NSString stringWithFormat:@"https://%@.rec.la/channels",username];
	NSURL *requestURL = [NSURL URLWithString:requestString];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
	[request setValue:oAuthToken forHTTPHeaderField:@"Authorization"];
	
	NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
	
	[NSURLConnection sendAsynchronousRequest:request
									   queue:backgroundQueue
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
							   if (!error) {
								   //Parse the array containing Dictionnary of {id => "id", name => "name"}
								   NSArray *requestResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
								   [requestResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
									   if ([[obj objectForKey:@"name"] isEqualToString:name]) {
										   //[*channelId appendString:[obj objectForKey:@"id"]];
										   //NSLog(@"Channel ID is %@", [*channelId description]);
//										   NSMutableString *channel = [[NSMutableString alloc] initWithString:@""];
//										   [channel appendString:[obj objectForKey:@"id"]];
//										   NSLog(@"Channel ID is : %@", channel);
										   
										   //NSLog(@"*channelId = %@",[*channelId description]);
										   
										   //NSLog(@"Channel ID is %@", [obj objectForKey:@"id"]);
										   *stop = TRUE;
									   }
								   }];
							   } else {
								   NSLog(@"Error = %@",error);
							   }
							   
						   }];
}


- (id)nonNil:(id)object
{
	if (!object) {
		return @"";
	}
	else
		return object;
}

- (NSString *)apiBaseUrl
{
    // production url
    //return [NSString stringWithFormat:@"https://%@.pryv.io", self.userId];
	
    // development url
    return [NSString stringWithFormat:@"https://%@.rec.la", self.userId];
}

- (BOOL)isReady
{
    // The manager must contain a user, token and a application channel
    if (self.userId == nil || self.userId.length == 0) {
        return NO;
    }
    if (self.oAuthToken == nil || self.oAuthToken.length == 0) {
        return NO;
    }
    if (self.channelId == nil || self.channelId.length == 0) {
        return NO;
    }
	
    return YES;
}

- (NSError *)createNotReadyError
{
    NSError *error;
    if (self.userId == nil || self.userId.length == 0) {
		error = [NSError errorWithDomain:@"user not set" code:7 userInfo:nil];
	}
	else if (self.oAuthToken == nil || self.oAuthToken.length == 0) {
		error = [NSError errorWithDomain:@"auth token not set" code:77 userInfo:nil];
	}
	else if (self.channelId == nil || self.channelId.length == 0) {
		error = [NSError errorWithDomain:@"channel not set" code:777 userInfo:nil];
	}
	else {
		error = [NSError errorWithDomain:@"unknown error" code:999 userInfo:nil];
	}
    return error;
}

- (void)startClientWithUserId:(NSString *)userId
                   oAuthToken:(NSString *)token
                    channelId:(NSString *)channelId
               successHandler:(void (^)(NSTimeInterval serverTime))successHandler
                 errorHandler:(void(^)(NSError *error))errorHandler;
{
    NSParameterAssert(userId);
    NSParameterAssert(token);
    NSParameterAssert(channelId);
	
    self.userId = userId;
    self.oAuthToken = token;
    self.channelId = channelId;
	
    [self synchronizeTimeWithSuccessHandler:successHandler
                               errorHandler:errorHandler];
}

- (void)synchronizeTimeWithSuccessHandler:(void(^)(NSTimeInterval serverTime))successHandler errorHandler:(void(^)(NSError *error))errorHandler
{
    if (![self isReady]) {
        NSLog(@"fail synchronize: not initialized");
		
        if (errorHandler)
            errorHandler([self createNotReadyError]);
        return;
    }
	
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/", [self apiBaseUrl]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setValue:self.oAuthToken forHTTPHeaderField:@"Authorization"];
	
	NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
	
	[NSURLConnection sendAsynchronousRequest:request
									   queue:backgroundQueue
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
							   if (!error) {
								   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
								   if ([httpResponse statusCode] >= 400) {
									   NSLog(@"Remote URL returned error %ld %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
									   NSLog(@"Could not synchronize");
									   NSDictionary *userInfo = @{
											@"NSHTTPURLResponse" : [self nonNil:httpResponse],
											@"statusCode" : [NSNumber numberWithInt:(int)[httpResponse statusCode]],
											@"serverError" : [self nonNil:[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]]
									   };
									   NSError *requestError = [NSError errorWithDomain:@"Connection failed" code:100 userInfo:userInfo];
									   if (errorHandler)
										   errorHandler(requestError);
								   } else {
									   NSTimeInterval serverTime = [[[httpResponse allHeaderFields] objectForKey:@"Server-Time"] doubleValue];
									   NSLog(@"successfully authorized and synchronized with server time: %f ", serverTime);
									   _serverTimeInterval = [[NSDate date] timeIntervalSince1970] - serverTime;
									   
									   if (successHandler)
										   successHandler(serverTime);

									   
									   
								   }

							   } else {
								   NSLog(@"Could not synchronize");
								   NSDictionary *userInfo = @{
									@"connectionError": [self nonNil:error]
								   };
								   NSError *requestError = [NSError errorWithDomain:@"Connection failed" code:100 userInfo:userInfo];
								   if (errorHandler)
									   errorHandler(requestError);
							   }
							   
						   }];
}

@end
