
    
 //
//  NetworkManager.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/16/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "NetworkManager.h"
#import "NetworkDecorator.h"
#import "HWTag.h"
#import "HWFollowUser.h"
#import "HWComment.h"

@interface NetworkManager ()

@property (strong, nonatomic) NetworkDecorator *networkDecorator;



@end

typedef NS_ENUM (NSInteger, HWAcceptDeclineOffer ){
    HWAcceptOffer = 1,
    HWDeclineOffer = 2
};


@implementation NetworkManager




#pragma mark -
#pragma mark Lifecycle

+ (instancetype) shared
{
    static NetworkManager* sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NetworkManager alloc] init];
    });
    return sharedManager;
}

- (instancetype) init
{
    self = [super init];
    
    if(self)
    {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        self.networkDecorator = [NetworkDecorator new];
    }
    return self;
}

#pragma mark -
#pragma mark User section

- (void) registerUserWithPhoneNumber: (NSString*) phoneNumber
                     orFacebookToken: (NSString*) facebookToken
                        successBlock: (void (^)(HWUser* user)) successBlock
                        failureBlock: (void (^)(NSError* error)) failureBlock
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if(phoneNumber)
       [params setObject: phoneNumber forKey: @"phone"];
    else if (facebookToken)
        [params setObject: facebookToken forKey: @"facebook_token"];
    
    [self.networkDecorator POST: @"users"
                     parameters: params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                failureBlock(
                                             
                               [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]
                                             );
                                             
                            return;
                            }
                            
                            NSError* error;
                            HWUser* user = [[HWUser alloc] initWithDictionary: responseObject[@"user"] error: &error];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:user.id forKey:kUSER_ID];
                            
                            if(error)
                            {
                                failureBlock(error);
                                
                                return;
                            }
                            
                            successBlock(user);
                            
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                            return;

                        }];
}

- (void) loginWithPhoneNumber: (NSString*) phoneNumber
                          pin: (NSString*) pin
                 successBlock: (void (^)(HWUser* user)) successBlock
                 failureBlock: (void (^)(NSError* error)) failureBlock
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if(phoneNumber)
        [params setObject: phoneNumber forKey: @"phone"];
    if (pin)
        [params setObject: pin forKey: @"pin"];
    
    [self.networkDecorator PUT: @"users"
                     parameters: params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                failureBlock(
                                             
                                             [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                                

                                return;
                            }
                            
                            NSError* error;
                            HWUser* user = [[HWUser alloc] initWithDictionary: responseObject[@"user"] error: &error];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:user.id forKey:kUSER_ID];
                            if(error)
                            {
                                failureBlock(error);
                                return;
                            }
                            
                            successBlock(user);
                            
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                            return;

                        }];
}



- (void) getUserProfileWithUserID: (NSString*) userId
                     successBlock: (void (^)(HWUser* user)) successBlock
                     failureBlock: (void (^)(NSError* error)) failureBlock
{
    
 
    NSString *URLString;
    
    if (userId)
    {
        URLString  = [NSString stringWithFormat:@"user?id=%@",userId];
    } else {
        
        URLString = @"user";
    }
    
    
    [self.networkDecorator GET: URLString
                    parameters: nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               
                               return;
                           }
                           
                           NSError* error;
                           HWUser* user = [[HWUser alloc] initWithDictionary: responseObject[@"user"] error: &error];
                           
                                                     if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(user);
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           return;
                           
                       }];
}





- (void) updateUserEntityWithUsername: (NSString*) username
                                email: (NSString*) email
                              aboutMe: (NSString*) about
                                photo: (UIImage*) photo
                         successBlock: (void (^)(HWUser* user)) successBlock
                         failureBlock: (void (^)(NSError* error)) failureBlock
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if(username)
        [params setObject: username forKey: @"username"];
    if (email)
        [params setObject: email forKey: @"email"];
    if (about)
        [params setObject: about forKey: @"about_me"];
    
    [self.networkDecorator POST: @"user"
                     parameters: params
      constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
          if(photo)
          {
              [formData appendPartWithFileData: UIImagePNGRepresentation(photo)
                                          name: @"media"
                                      fileName: @"media.png"
                                      mimeType: @"image/png"];
          }
      }
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                failureBlock(
                                             
                                             [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                                

                                return;
                            }
                            
                            NSError* error;
                            HWUser* user = [[HWUser alloc] initWithDictionary: responseObject[@"user"] error: &error];
                            
                            if(error)
                            {
                                failureBlock(error);
                                return;
                            }
                            
                            successBlock(user);
                            
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                            return;

                        }];

}

- (void) linkFacebookAccountWithToken: (NSString*) token
                         successBlock: (void (^)(HWUser* user)) successBlock
                         failureBlock: (void (^)(NSError* error)) failureBlock
{
    [self.networkDecorator PUT: @"user/socials"
                    parameters: @{@"facebook_token": token}
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               

                               return;
                           }
                           
                           NSError* error;
                           HWUser* user = [[HWUser alloc] initWithDictionary: responseObject[@"user"] error: &error];
                           
                           [[NSUserDefaults standardUserDefaults] setObject:user.id forKey:kUSER_ID];
                
                           if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(user);
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           return;

                       }];
}


- (void) getCityByPostCode: (NSString*) postCode
                         successBlock: (void (^)(NSString* city)) successBlock
                         failureBlock: (void (^)(NSError* error)) failureBlock
{
    [self.networkDecorator PUT: @"get_city"
                    parameters: @{@"post_code": postCode}
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                           
                           NSError* error;
                           NSString* city = responseObject[@"city"];

                           if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(city);
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           return;

                       }];
}



#pragma mark -
#pragma mark Tag

- (void) getListOfTags: (void (^)(NSMutableArray * tags)) successBlock
          failureBlock: (void (^)(NSError* error)) failureBlock
{
    [self.networkDecorator GET: @"metatags"
                    parameters: nil
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                           
                           NSError* error;

                           
                           NSMutableArray* tags = [NSMutableArray array];
                           

                           
                           
                           //WithDictionary: tag error: &error];
                           
                           for (NSDictionary* tag in responseObject[@"tags"][@"platforms"])
                           {
                               HWTag* newTag = [[HWTag alloc] initWithDictionary: tag error: &error];
                                [tags addObject:newTag];
                           }
//
                           if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(tags);
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           return;

                       }];
}


#pragma mark -
#pragma mark Items

- (void) getItemsWithPage: (NSInteger) page
             searchString: (NSString*) searchString // can be nil
             successBlock: (void (^)(NSArray* arrayWithItems, NSInteger page, NSString* searchString)) successBlock
             failureBlock: (void (^)(NSError* error)) failureBlock
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if(page < 1)
        page = 1;
    [params setObject: @(page) forKey: @"p"];
    
    if(searchString && searchString.length > 0)
    {
        [params setObject: searchString forKey: @"q"];
    }
    
    [self.networkDecorator GET: @"listings"
                    parameters: params
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                           
                           NSError* error;
                           NSArray* items = responseObject[@"items"];
                           
                           NSMutableArray* arrayWithItems = [NSMutableArray array];
                           
                           for (NSDictionary* item in items) {
                               HWItem* newItem = [[HWItem alloc] initWithDictionary: item error: &error];
                               if(error)
                               {
                                   NSLog(@"Error occured during item entity parsing: %@", error);
                                   error = nil;
                               }
                               else
                               {
                                   [arrayWithItems addObject: newItem];
                               }
                           }
                           
                           if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(arrayWithItems, page, searchString);
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           return;

                       }];
}

- (void) createItem: (HWItem*) item
       successBlock: (void (^)(HWItem* item)) successBlock
       failureBlock: (void (^)(NSError* error)) failureBlock
{
    if(!item)
    {
        NSLog(@"No item to create");
        failureBlock([NSError errorWithDomain: @"No item to create" code: 101 userInfo: nil]);
        return;
    }
    
    NSDictionary* params = [item toDictionary];
    
    [self.networkDecorator POST: @"listings"
                    parameters: params
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                           
                           NSError* error;
                           HWItem* item = [[HWItem alloc] initWithDictionary: responseObject[@"item"] error: &error];
                           
                           if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(item);
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           return;
                       }];
}

- (void) getItemById: (NSString*) itemId
        successBlock: (void (^)(HWItem* item)) successBlock
        failureBlock: (void (^)(NSError* error)) failureBlock
{
    NSDictionary* params = @{@"listing_id": itemId};
    
    [self.networkDecorator GET: @"listings"
                    parameters: params
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                           
                           NSError* error;
                           HWItem* item = [[HWItem alloc] initWithDictionary: responseObject[@"item"] error: &error];
                           
                           item.user_items =  responseObject[@"user_items"];
                           item.similar_items = responseObject[@"similar_items"];
                           
                           if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(item);
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           return;

                       }];
}

- (void) removeItemById: (NSString*) itemId
           successBlock: (void (^)(void)) successBlock  //TODO: HWItem to void
           failureBlock: (void (^)(NSError* error)) failureBlock
{
    
    
    NSDictionary* params = @{@"listing_id": itemId};
    

    
    [self.networkDecorator DELETE:@"listings"
     
                       parameters: params
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                           
                           successBlock();
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           return;
                           
                       }];
}

- (void) getItemsByUserId: (NSString*) userId
             successBlock: (void (^)(NSArray* arrayWithItems)) successBlock
             failureBlock: (void (^)(NSError* error)) failureBlock
{
    NSDictionary* params = @{@"user_id": userId};
    
    [self.networkDecorator GET: @"listings"
                    parameters: params
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                           
                           NSError* error;
                           NSArray* items = responseObject[@"items"];
                           
                           NSMutableArray* arrayWithItems = [NSMutableArray array];
                           
                           for (NSDictionary* item in items) {
                               HWItem* newItem = [[HWItem alloc] initWithDictionary: item error: &error];
                               if(error)
                               {
                                   NSLog(@"Error occured during item entity parsing: %@", error);
                                   error = nil;
                               }
                               else
                               {
                                   [arrayWithItems addObject: newItem];
                               }
                           }
                           
                           if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(arrayWithItems);
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           return;
                           
                       }];
}

#pragma mark -
#pragma mark Follow

- (void) followWithUserId:(NSString*)userId
             successBlock:(void(^)(void)) successBlock
             failureBlock: (void (^)(NSError* error)) failureBlock
{
    
    
    NSDictionary *parametr = @{@"user_id":userId};
    
    [self.networkDecorator POST:@"user/followers"
                     parameters:parametr
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            
                            
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                failureBlock(
                                             
                                             [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                                
                                return;
                            }
                            
                            successBlock();
                            
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         
                          failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                          
                      }];
    
 
}


- (void) unfollowWithUserId:(NSString*)userId
               successBlock:(void(^)(void)) successBlock
               failureBlock: (void (^)(NSError* error)) failureBlock
{
    
    NSString *unfollow = [NSString stringWithFormat: @"user/followers?user_id=%@", userId];
 
    [self.networkDecorator DELETE:unfollow
                       parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                           
                            NSLog(@"%@",responseObject);
                           successBlock();
                        
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                        failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           
                       }];
    
    
}

- (void) getFollowersWithUserId:(NSString*)userId
                   successBlock:(void(^)(NSArray* followersArray)) successBlock
                   failureBlock: (void (^)(NSError* error)) failureBlock
{
    NSString *URLString = [NSString stringWithFormat: @"user/followers?user_id=%@",userId];
    
    
    [self.networkDecorator GET:URLString
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }

                           NSArray *usersArray = responseObject[@"users"];
                           NSMutableArray *followersArray = [NSMutableArray array];
                           
    
                           NSError *error;
                           for (NSDictionary *dict in usersArray)
                           {
                               HWFollowUser *user = [[HWFollowUser alloc]initWithDictionary:dict error:&error];
                               [followersArray addObject:user];
                               
                           }
                           
                           if(error){
                               failureBlock(error);
                               return ;
                           }
                           
                           successBlock(followersArray);

                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                       }];
    
    
}

- (void) getFollowingWithUserId:(NSString*)userId
                   successBlock:(void(^)(NSArray* followingArray)) successBlock
                   failureBlock:(void (^)(NSError* error)) failureBlock
{
    
    
    NSString *URLString = [NSString stringWithFormat:@"user/followers?following=true&user_id=%@",userId];
    [self.networkDecorator GET:URLString
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                          
                           NSArray *usersArray = responseObject[@"users"];
                           NSMutableArray *followersArray = [NSMutableArray array];
                           
                           NSError *error;
                           for (NSDictionary *dict in usersArray)
                           {
                               HWFollowUser *user = [[HWFollowUser alloc]initWithDictionary:dict error:&error];
                               
                               [followersArray addObject:user];
                               
                           }
                           
                           if(error){
                               failureBlock(error);
                               return ;
                           }
                           
                           successBlock(followersArray);
                           
                           
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           
                       }];
    
    
}

#pragma mark - like/dislike and add to wishlist
- (void) likeDislikeWhithItemId:(NSString*)itemId
                   successBlock:(void(^)(void)) succesBlock
                   failureBlock:(void(^)(NSError* error)) failureBlock
{
    
    NSString *URLString = [NSString stringWithFormat:@"listings/likes/%@",itemId];
    
    [self.networkDecorator PUT:URLString
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           NSLog(@"%@",responseObject);
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                           
                           succesBlock();
                           
                           
                           
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                       }];
    
}


#pragma mark -
#pragma mark Comments

- (void) OfferPrice: (NSString*) newPrice
             itemId: (NSString*) itemId
              successBlock: (void (^)(void)) successBlock
              failureBlock: (void (^)(NSError* error)) failureBlock
{
    NSString* post = [@"listings/offers/" stringByAppendingString: itemId];
    [self.networkDecorator POST:post
                    parameters: @{@"new_price": newPrice}
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                        
                           successBlock();
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           return;
                           
                       }];
}


- (void) acceptOfferWithItemId:(NSString*)itemId
                         successBlock:(void(^)(void))successBlock
                         failureBlock:(void(^)(NSError* error))failureBlock
{
    
    [self acceptDeclineOfferWithItemId:itemId
                         acceptDecline:HWAcceptOffer
                          successBlock:^{
                              
                              successBlock();
                              
                          } failureBlock:^(NSError *error) {
                              
                              failureBlock(error);
                          }];
   
    
}

- (void) declineOfferWithItemId:(NSString*)itemId
                  successBlock:(void(^)(void))successBlock
                  failureBlock:(void(^)(NSError* error))failureBlock
{
    
    [self acceptDeclineOfferWithItemId:itemId
                         acceptDecline:HWDeclineOffer
                          successBlock:^{
                              
                              successBlock();
                              
                          } failureBlock:^(NSError *error) {
                              
                              failureBlock(error);
                          }];
    
    
}


- (void) acceptDeclineOfferWithItemId:(NSString*)itemId
                        acceptDecline:(HWAcceptDeclineOffer) acceptDecline
                  successBlock:(void(^)(void))successBlock
                  failureBlock:(void(^)(NSError* error))failureBlock
{
    
    NSString *URLString = [NSString stringWithFormat:@"listings/offers/%@",itemId];
    NSString *new_status = [NSString stringWithFormat:@"%ld", (long)acceptDecline];
    
    NSDictionary * parametrs = @{@"new_status":new_status};
    
    
    [self.networkDecorator PUT:URLString
                    parameters:parametrs
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                           
                           successBlock();

                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                           return;
                       }];


}




#pragma mark - 
#pragma mark wishlist



- (void) getWishlistWithUserId:(NSString*)userId
                  successBlock:(void(^)(NSArray *wishlistArray)) succesBlock
                  failureBlock:(void(^)(NSError* error)) failureBlock
{
    
    NSString *URLString = [NSString stringWithFormat:@"user/wishlist?user_id=%@",userId];
    
    [self.networkDecorator GET:URLString
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                           
                           NSMutableArray *wishlistArray = [NSMutableArray array];
                           NSArray *array = responseObject[@"items"];
                           
                           NSError *error;
                           
                           for(NSDictionary *dict in array)
                           {
                               HWItem * item = [[HWItem alloc]initWithDictionary:dict error:&error];
                               [wishlistArray addObject:item];
                               
                           }
                           
                           
                           if(error){
                               
                               failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                               return;
                           }
                           
                           succesBlock(wishlistArray);
                           
                           
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
                         failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                       }];
    
    
}


#pragma mark -
#pragma mark Comments


- (void) createNewCommentWithItemId:(NSString*)itemId
                        textComment:(NSString*) textComment
                       successBlock:(void(^)(void)) successBlock
                       failureBlock:(void(^)(NSError *error)) failureBlock
{
    NSString *URLString = [NSString stringWithFormat:@"listings/comments/%@",itemId];
    NSDictionary *parametrs = @{@"text":textComment};
    
    [self.networkDecorator POST:URLString
                     parameters:parametrs
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                failureBlock(
                                             
                                             [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                                
                                return;
                            }
                            
                            successBlock();
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                             failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                            
                            
                        }];
    
}


- (void) getAllCommentsWithItem:(HWItem*)item
                     successBlock:(void (^)(NSArray* commentsArray))successBlock
                     failureBlock:(void(^)(NSError * error)) failureBlock
{
    
    NSString *URLString = [NSString stringWithFormat:@"listings/comments/%@",item.id];
    
    [self.networkDecorator GET:URLString
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock(
                                            
                                            [NSError errorWithDomain:responseObject[@"title"] code:[responseObject[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
                               
                               return;
                           }
                           
                           NSArray * array = responseObject[@"comments"];
                           NSMutableArray *commentsArray =[NSMutableArray array];
                           
                           NSError *error;
                           
                           NSString *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUSER_ID];
                           NSString *bossItemId = item.user_id;
                           
                           for (NSDictionary *dict in array)
                           {
                               HWComment *comment = [[HWComment alloc]initWithDictionary:dict error:&error];
                               
                               
                               // offer logic
                               
                               if(comment.offer)
                               {
                                   NSError *er;
                                   HWOffer *offerForItem = [[HWOffer alloc]initWithDictionary:comment.offer error:&er];
                                   
                                   
                                   if ([offerForItem.offer_creater_id isEqualToString:bossItemId] ||
                                       [offerForItem.offer_receiver_id isEqualToString:currentUser]  ||
                                       [offerForItem.offer_creater_id isEqualToString:currentUser])
                                   {
                                       
                                      
                                       if([offerForItem.status integerValue]>0) {
                                           
                                       } else  if ([offerForItem.offer_receiver_id isEqualToString:    currentUser]) {
                                       
                                           comment.isAcceptDeclineComment = @"Yes";
                                       }
                                       
                                   } else {
                                       
                                       continue;
                                   }
                                   

                                   if(er)
                                   {
                                       NSLog(@"%@",er);
                                   }
                                   
                               }
                               
                                [commentsArray addObject:comment];
                           }
                           if (error)
                           {
                               failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                               return;

                           }
                           
                           successBlock(commentsArray);
                           
                          
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           failureBlock([NSError errorWithDomain:@"Server Error" code:error.code userInfo:error.userInfo]);
                       }];
}

@end


