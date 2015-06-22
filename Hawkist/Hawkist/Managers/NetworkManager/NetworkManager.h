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
@end
