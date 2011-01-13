//
//  ReadmillUser.h
//  Readmill Framework
//
//  Created by Work on 12/01/2011.
//  Copyright 2011 KennettNet Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadmillAPIWrapper.h"

@class ReadmillUser;

@protocol ReadmillUserAuthenticationDelegate <NSObject>

-(void)readmillAuthenticationDidFailWithError:(NSError *)authenticationError;
-(void)readmillAuthenticationDidSucceedWithLoggedInUser:(ReadmillUser *)loggedInUser;

@end

@interface ReadmillUser : NSObject {
@private
    
    NSString *city;
    NSString *country;
    NSString *userDescription;
    NSString *firstName;
    NSString *lastName;
    NSString *fullName;
    NSString *userName;
    
    NSURL *avatarURL;
    NSURL *permalinkURL;
    NSURL *websiteURL;
    
    ReadmillUserId userId;
    
    NSUInteger followerCount;
    NSUInteger followingCount;
    NSUInteger abandonedBookCount;
    NSUInteger finishedBookCount;
    NSUInteger interestingBookCount;
    NSUInteger openBookCount;
    
    ReadmillAPIWrapper *apiWrapper;
}

+(NSURL *)clientAuthorizationURLWithRedirectURL:(NSURL *)redirect onStagingServer:(BOOL)onStaging;
+(void)authenticateCallbackURL:(NSURL *)callbackURL baseCallbackURL:(NSURL *)baseCallbackURL delegate:(id <ReadmillUserAuthenticationDelegate>)authenticationDelegate onStagingServer:(BOOL)onStaging;
+(void)authenticateWithPropertyListRepresentation:(NSDictionary *)plistRep delegate:(id <ReadmillUserAuthenticationDelegate>)authenticationDelegate;

-(id)initWithAPIDictionary:(NSDictionary *)apiDict apiWrapper:(ReadmillAPIWrapper *)wrapper;
-(id)initWithPropertyListRepresentation:(NSDictionary *)plistRep;

-(NSDictionary *)propertyListRepresentation;

-(void)updateWithAPIDictionary:(NSDictionary *)apiDict;

-(void)authenticateCallbackURL:(NSURL *)callbackURL baseCallbackURL:(NSURL *)baseCallbackURL delegate:(id <ReadmillUserAuthenticationDelegate>)authenticationDelegate;
-(void)verifyAuthentication:(id <ReadmillUserAuthenticationDelegate>)authenticationDelegate;


@property (readonly, copy) NSString *city;
@property (readonly, copy) NSString *country;
@property (readonly, copy) NSString *userDescription;
@property (readonly, copy) NSString *firstName;
@property (readonly, copy) NSString *lastName;
@property (readonly, copy) NSString *fullName;
@property (readonly, copy) NSString *userName;

@property (readonly, copy) NSURL *avatarURL;
@property (readonly, copy) NSURL *permalinkURL;
@property (readonly, copy) NSURL *websiteURL;

@property (readonly) ReadmillUserId userId;

@property (readonly) NSUInteger followerCount;
@property (readonly) NSUInteger followingCount;
@property (readonly) NSUInteger abandonedBookCount;
@property (readonly) NSUInteger finishedBookCount;
@property (readonly) NSUInteger interestingBookCount;
@property (readonly) NSUInteger openBookCount;

@property (readonly, retain) ReadmillAPIWrapper *apiWrapper;

@end