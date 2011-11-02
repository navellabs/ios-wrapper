//
//  ReadmillURLConnection.m
//  ReadmillAPI
//
//  Created by Martin Hwasser on 9/23/11.
//  Copyright (c) 2011 KennettNet Software Limited. All rights reserved.
//

#import "ReadmillURLConnection.h"

@interface ReadmillURLConnection ()
- (void)finish;
@end

@implementation ReadmillURLConnection

- (id)initWithRequest:(NSURLRequest *)aRequest completionHandler:(ReadmillURLConnectionCompletionHandler)completionHandler
{
    self = [super init];
    if (self) {
        // Initialization
        
        [self setCompletionBlock:^{
            completionHandler(self.response, self.responseData, self.connectionError);        
        }];
        request = [aRequest copy];
    }
    return self;
}
- (void)dealloc {
    
    self.connection = nil, connection = nil;
    self.connectionError = nil, connectionError = nil;
    self.responseData = nil, responseData = nil;
    self.request = nil, request = nil;
    [super dealloc];
}

@synthesize connectionError;
@synthesize responseData;
@synthesize connection;
@synthesize response;
@synthesize request;
@synthesize isFinished, isExecuting;

/* TODO - concurrent?
- (BOOL)isConcurrent {
    return YES;
}*/

- (void)start {
    if (![NSThread isMainThread]) {
        return [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
    }
    
    NSLog(@"operation for <%@> started.", [request URL]);
    
    [self willChangeValueForKey:@"isExecuting"];
    isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    NSURLConnection *aConnection = [[NSURLConnection alloc] initWithRequest:request 
                                                                   delegate:self];
    
    self.connection = aConnection;
    [aConnection release];
    
    if (connection == nil) {
        [self finish];
    }
}

- (void)finish {

    NSLog(@"status code: %d, error: %@, data size: %u", response.statusCode, connectionError, [responseData length]);
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    isExecuting = NO;
    isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)err {
    NSLog(@"connection failed with err: %@", err);
    self.connectionError = err;
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)aResponse {
    self.response = (NSHTTPURLResponse *)aResponse;
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.responseData = data;
    [data release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self finish];
}
@end

