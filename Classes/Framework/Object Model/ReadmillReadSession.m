/*
 Copyright (c) 2011 Readmill LTD
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "ReadmillReadSession.h"

@interface ReadmillReadSession ()

@property (readwrite, copy) NSDate *lastPingDate;
@property (readwrite, copy) NSString *sessionIdentifier;
@property (readwrite, retain) ReadmillAPIWrapper *apiWrapper;
@property (readwrite) ReadmillReadId readId;

@end

@implementation ReadmillReadSession

- (id)init {
    return [self initWithAPIWrapper:nil readId:0];
}

-(id)initWithAPIWrapper:(ReadmillAPIWrapper *)wrapper readId:(ReadmillReadId)sessionReadId {
    return [self initWithAPIWrapper:wrapper readId:sessionReadId sessionId:[[NSProcessInfo processInfo] globallyUniqueString]];
}

-(id)initWithAPIWrapper:(ReadmillAPIWrapper *)wrapper readId:(ReadmillReadId)sessionReadId sessionId:(NSString *)sessionId {
    if ((self = [super init])) {
        // Initialization code here.
        
        [self setApiWrapper:wrapper];
        [self setReadId:sessionReadId];
        [self setLastPingDate:[NSDate date]];
        [self setSessionIdentifier:sessionId];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ id %@ for read %d", [super description], [self sessionIdentifier], [self readId]]; 
}

@synthesize lastPingDate;
@synthesize sessionIdentifier;
@synthesize apiWrapper;
@synthesize readId;

- (void)dealloc {
    // Clean-up code here.
    
    [self setApiWrapper:nil];
    [self setLastPingDate:nil];
    [self setSessionIdentifier:nil];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Threaded Messages

-(void)pingWithProgress:(ReadmillReadProgress)progress delegate:(id <ReadmillPingDelegate>)delegate {
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                delegate, @"delegate",
                                [NSThread currentThread], @"callbackThread",
                                [NSNumber numberWithUnsignedInteger:progress], @"progress",
                                nil];
    
    [self performSelectorInBackground:@selector(pingWithProperties:)
                           withObject:properties];
    
}

-(void)pingWithProperties:(NSDictionary *)properties {
    
    [self retain];
    
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    NSThread *callbackThread = [properties valueForKey:@"callbackThread"];
    id <ReadmillPingDelegate> pingDelegate = [properties valueForKey:@"delegate"];
    NSUInteger progress = [[properties valueForKey:@"progress"] unsignedIntegerValue];
    
    NSDate *pingTime = [NSDate date];
    NSTimeInterval timeSinceLastPing = [pingTime timeIntervalSinceDate:[self lastPingDate]];
    
    NSError *error = nil;
    [[self apiWrapper] pingReadWithId:[self readId]
                         withProgress:progress
                    sessionIdentifier:[self sessionIdentifier]
                             duration:(NSUInteger)timeSinceLastPing
                       occurrenceTime:pingTime
                                error:&error];
    

    [self setLastPingDate:pingTime];
    
    if (error == nil && pingDelegate != nil) {
        
        [(NSObject *)pingDelegate performSelector:@selector(readmillReadSessionDidPingSuccessfully:)
                                                 onThread:callbackThread
                                               withObject:self
                                            waitUntilDone:YES];
        
    } else if (error != nil && pingDelegate != nil) {
        
        NSInvocation *failedInvocation = [NSInvocation invocationWithMethodSignature:
                                          [(NSObject *)pingDelegate 
                                           methodSignatureForSelector:@selector(readmillReadSession:didFailToPingWithError:)]];
        
        [failedInvocation setSelector:@selector(readmillReadSession:didFailToPingWithError:)];
        
        [failedInvocation setArgument:&self atIndex:2];
        [failedInvocation setArgument:&error atIndex:3];
        
        [failedInvocation performSelector:@selector(invokeWithTarget:)
                                 onThread:callbackThread
                               withObject:pingDelegate
                            waitUntilDone:YES]; 
    }
    
    [pool drain];
    
    [self release];
}

@end
