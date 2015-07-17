//
//  NetworkManager.h
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/16/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWTag.h"

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

- (void) getUserProfileWithUserID: (NSString*) userId
                     successBlock: (void (^)(HWUser* user)) successBlock
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

- (void) getCityByPostCode: (NSString*) postCode
              successBlock: (void (^)(NSString* city)) successBlock
              failureBlock: (void (^)(NSError* error)) failureBlock;

- (void) getListOfTags: (void (^)(NSMutableArray* tags)) successBlock
          failureBlock: (void (^)(NSError* error)) failureBlock;

// get all items at page with search string
- (void) getItemsWithPage: (NSInteger) page
             searchString: (NSString*) searchString // can be nil
             successBlock: (void (^)(NSArray* arrayWithItems, NSInteger page, NSString* searchString)) successBlock
             failureBlock: (void (^)(NSError* error)) failureBlock;


// create an item

- (void) createItem: (HWItem*) item
       successBlock: (void (^)(HWItem* item)) successBlock
       failureBlock: (void (^)(NSError* error)) failureBlock;

// get item by id
- (void) getItemById: (NSString*) itemId
        successBlock: (void (^)(HWItem* item)) successBlock
        failureBlock: (void (^)(NSError* error)) failureBlock;


//remove item by id
- (void) removeItemById: (NSString*) itemId
           successBlock: (void (^)(HWItem* item)) successBlock
           failureBlock: (void (^)(NSError* error)) failureBlock;

// get items by user
- (void) getItemsByUserId: (NSString*) userId
             successBlock: (void (^)(NSArray* arrayWithItems)) successBlock
             failureBlock: (void (^)(NSError* error)) failureBlock;

@end
