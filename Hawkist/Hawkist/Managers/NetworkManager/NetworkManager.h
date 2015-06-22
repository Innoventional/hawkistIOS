//
//  NetworkManager.h
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/16/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkManager : NSObject

+ (instancetype) shared;

// User section

// user registration, requires phone or facebook token(another must be nil). Returns user entity.
- (void) registerUserWithPhoneNumber: (NSString*) phoneNumber
                     orFacebookToken: (NSString*) facebookToken
                        successBlock: (void (^)(HWUser* user)) successBlock
                        failureBlock: (void (^)(NSError* error)) failureBlock;

// user login and registration
// In this version of API we use this method in both cases - for login and for registration
// For registration -> send phone number -> after getting SMS with pin send pnone number and pin
// For login -> send phone number and pin
//

- (void) loginWithPhoneNumber: (NSString*) phoneNumber
                          pin: (NSString*) pin
                 successBlock: (void (^)(HWUser* user)) successBlock
                 failureBlock: (void (^)(NSError* error)) failureBlock;

// get user profile
- (void) getUserProfileWithSuccessBlock: (void (^)(HWUser* user)) successBlock
                           failureBlock: (void (^)(NSError* error)) failureBlock;

// update user entity

- (void) updateUserEntityWithUsername: (NSString*) username
                                email: (NSString*) email
                              aboutMe: (NSString*) about
                                photo: (UIImage*) photo
                         successBlock: (void (^)(HWUser* user)) successBlock
                         failureBlock: (void (^)(NSError* error)) failureBlock;

// link facebook accaunt to user account

- (void) linkFacebookAccountWithToken: (NSString*) token
                         successBlock: (void (^)(HWUser* user)) successBlock
                         failureBlock: (void (^)(NSError* error)) failureBlock;
@end
