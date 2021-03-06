//
//  ReadmillURLExtensions.m
//  Readmill
//
//  Created by Martin Hwasser on 4/9/11.
//  Copyright 2011 Readmill. All rights reserved.
//

#import "NSURL+ReadmillURLParameters.h"
#import "NSString+ReadmillAdditions.h"
#import "NSDictionary+ReadmillAdditions.h"

@implementation NSURL (ReadmillURLParameters)

+ (NSURL *)URLWithParameters:(NSDictionary *)parameters 
{    
    return [NSURL URLWithString:[parameters urlParameterString]];
}
- (NSURL *)URLByAddingParameters:(NSDictionary *)parameters {

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *URLString = [self absoluteString];
    NSURL *URL = [[NSURL alloc] initWithString:[URLString stringByAppendingString:[[NSURL URLWithParameters:parameters] absoluteString]]];    
    [pool drain];
    return [URL autorelease];
}
- (NSDictionary *)queryAsDictionary {
    NSArray *parameters = [[self query] componentsSeparatedByString:@"&"];
    NSMutableDictionary *parametersDictionary = [NSMutableDictionary dictionaryWithCapacity:[parameters count]];
    for (NSString *parameter in parameters) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSArray *kvp = [parameter componentsSeparatedByString:@"="];
        NSString *key = [[kvp objectAtIndex:0] urlDecodedString];
        NSString *value = [[kvp objectAtIndex:1] urlDecodedString];
        [parametersDictionary setValue:value forKey:key];
        [pool drain];
    }
    return parametersDictionary;
}
@end