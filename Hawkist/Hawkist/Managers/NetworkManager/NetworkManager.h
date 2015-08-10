//
//  NetworkManager.h
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/16/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWTag.h"
#import "HWCard.h"

@interface NetworkManager : NSObject

+ (instancetype) shared;



typedef NS_ENUM(NSInteger, HWOrderIssuseReasons)
{
    
    HWItemHasNotArrived = 0,
    HWItemIsNotAsDescribed = 1,
    HWItemIsBrokenOrNotUsable = 2
};





#pragma mark -
#pragma mark User section

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

// for current user  userID == nil
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


- (void) logOutWithSuccessBlock:(void(^)(void))successBlock
                   failureBlock:(void(^)(NSError *error))failureBlock;


#pragma mark -
#pragma mark Tag

- (void) getListOfTags: (void (^)(NSMutableArray* tags)) successBlock
          failureBlock: (void (^)(NSError* error)) failureBlock;


- (void) getAvaliableTags:(void (^)(NSMutableArray * tags)) successBlock
             failureBlock: (void (^)(NSError* error)) failureBlock;


- (void) addTagToFeed:(NSString*)tagId
         successBlock:(void(^)(void)) successBlock
         failureBlock: (void (^)(NSError* error)) failureBlock;

#pragma mark -
#pragma mark Items

// get all items at page with search string
- (void) getItemsWithPage: (NSInteger) page
             searchString: (NSString*) searchString // can be nil
             successBlock: (void (^)(NSArray* arrayWithItems, NSInteger page, NSString* searchString)) successBlock
             failureBlock: (void (^)(NSError* error)) failureBlock;


// create an item

- (void) createOrUpdateItem: (HWItem*) item
       successBlock: (void (^)(HWItem* item)) successBlock
       failureBlock: (void (^)(NSError* error)) failureBlock;

// get item by id
- (void) getItemById: (NSString*) itemId
        successBlock: (void (^)(HWItem* item)) successBlock
        failureBlock: (void (^)(NSError* error)) failureBlock;


//remove item by id
- (void) removeItemById: (NSString*) itemId
           successBlock: (void (^)(void)) successBlock
           failureBlock: (void (^)(NSError* error)) failureBlock;

// get items by user
- (void) getItemsByUserId: (NSString*) userId
             successBlock: (void (^)(NSArray* arrayWithItems)) successBlock
             failureBlock: (void (^)(NSError* error)) failureBlock;

- (void) check_selling_ability:(void(^)(void))successBlock
                  failureBlock: (void (^)(NSError* error)) failureBlock;
#pragma mark -
#pragma mark Follower


//follow user
- (void) followWithUserId:(NSString*)userId
             successBlock:(void(^)(void)) successBlock
             failureBlock: (void (^)(NSError* error)) failureBlock;

// unfollow user
- (void) unfollowWithUserId:(NSString*)userId
               successBlock:(void(^)(void)) successBlock
               failureBlock: (void (^)(NSError* error)) failureBlock;


//get follower for userId
- (void) getFollowersWithUserId:(NSString*)userId
                   successBlock:(void(^)(NSArray* followersArray)) successBlock
                   failureBlock: (void (^)(NSError* error)) failureBlock;

//get following for userId
- (void) getFollowingWithUserId:(NSString*)userId
                   successBlock:(void(^)(NSArray* followingArray)) successBlock
                   failureBlock:(void (^)(NSError* error)) failureBlock;


#pragma mark - like/dislike and add to wishlist
- (void) likeDislikeWhithItemId:(NSString*)itemId
                   successBlock:(void(^)(void)) succesBlock
                   failureBlock:(void(^)(NSError* error)) failureBlock;


- (void) getWishlistWithUserId:(NSString*)userId
                  successBlock:(void(^)(NSArray *wishlistArray)) succesBlock
                  failureBlock:(void(^)(NSError* error)) failureBlock;




#pragma mark -
#pragma mark Comments

- (void) OfferPrice: (NSString*) newPrice
             itemId: (NSString*) itemId
       successBlock: (void (^)(void)) successBlock
       failureBlock: (void (^)(NSError* error)) failureBlock;


- (void) acceptOfferWithItemId:(NSString*)itemId
                  successBlock:(void(^)(void))successBlock
                  failureBlock:(void(^)(NSError* error))failureBlock;

- (void) declineOfferWithItemId:(NSString*)itemId
                  successBlock:(void(^)(void))successBlock
                  failureBlock:(void(^)(NSError* error))failureBlock;


- (void) createNewCommentWithItemId:(NSString*)itemId
                        textComment:(NSString*) textComment
                       successBlock:(void(^)(void)) successBlock
                       failureBlock:(void(^)(NSError *error)) failureBlock;

- (void) getAllCommentsWithItem:(HWItem*)item
                     successBlock:(void (^)(NSArray* commentsArray))successBlock
                     failureBlock:(void(^)(NSError * error)) failureBlock;



#pragma mark -
#pragma mark MentionInComment

- (void) getMentionInCommentsWithString:(NSString*)text
                           successBlock:(void(^)(NSArray *mentionsArray))successBlock
                           failureBlock:(void(^)(NSError *error)) failureBlock;



#pragma mark -
#pragma mark BankCard

- (void) addNewBankCard:(NSString*)tokenId
           successBlock:(void(^)(void)) successBlock
           failureBlock: (void (^)(NSError* error)) failureBlock;

- (void) getAllBankCards:(void(^)(NSArray *cards))successBlock
            failureBlock:(void(^)(NSError *error)) failureBlock;

- (void) removeBankCard:(NSString*)cardId
           successBlock:(void(^)(void)) successBlock
           failureBlock: (void (^)(NSError* error)) failureBlock;

- (void) updateBankCard:(HWCard*)card
           successBlock:(void(^)(void)) successBlock
           failureBlock: (void (^)(NSError* error)) failureBlock;

#pragma mark - 
#pragma mark BuyItem

-(void) buyItemWithCardId:(NSString*)cardId
               withItemId:(NSString*)itemId
             successBlock:(void(^)(void))successBlock
             failureBlock:(void(^)(NSError *error)) failureBlock;


-(void) getAllOrderItemWithSuccessBlock:(void(^)(NSArray *array)) successBlock
                          failureBlock:(void(^)(NSError *error)) failureBlock;

-(void) orderHasInIssueWithOrderId:(NSString*)orderId
             withOrderIssuseReasons:(HWOrderIssuseReasons) orderIssuse
                       successBlock:(void(^)(void)) successBlock
                       failureBlock:(void(^)(NSError *error)) failureBlock;


-(void) orderReceivedWithOrderId:(NSString *)orderId
                     successBlock:(void(^)(void)) successBlock
                     failureBlock:(void(^)(NSError *error)) failureBlock;



@end
