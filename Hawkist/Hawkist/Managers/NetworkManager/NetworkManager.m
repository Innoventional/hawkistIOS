
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
#import "HWMention.h"
#import "HWCard.h"
#import "HWOrderItem.h"

@interface NetworkManager ()

@property (strong, nonatomic) NetworkDecorator *networkDecorator;



@end

typedef NS_ENUM (NSInteger, HWAcceptDeclineOffer ){
    HWOfferAccept = 1,
    HWOfferDecline = 2
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
#pragma mark Error section



- (NSError*) errorWithResponseObject:(id)responseObject
{
    NSError *responseError = [NSError errorWithDomain:responseObject[@"title"]
                                         code:[responseObject[@"status"] integerValue]
                                     userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}];
    return responseError;
}


- (NSError*)serverErrorWithError:(NSError*)error
{
    NSError *serverError;
    
    if (error.code == 499)   /// Internet disconnected
    {
        return [NSError errorWithDomain:@"Connection Error"
                                   code:499
                               userInfo:@{NSLocalizedDescriptionKey:@"Could not complete the last action. Please try again."}];
    }
        
    else
    {
        
        if (error.code == -1004 || error.code == -1009 || error.code == - 1005)
        {
            return [NSError errorWithDomain:@"Connection Error"
                                code:499
                            userInfo:@{NSLocalizedDescriptionKey:@"Could not complete the last action. Please try again."}];
        }
        
        NSInteger statusCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];

        switch (statusCode) {
            case 401:
                
            {
                serverError = [NSError errorWithDomain:@"Server Error"
                                                  code:401
                                              userInfo:@{NSLocalizedDescriptionKey:@"Unauthorized"}];
                break;
            }
            default:
            {
                serverError = [NSError errorWithDomain:@"Server Error"
                                                  code:error.code
                                              userInfo:error.userInfo];
                break;
            }
        }
        
    }
    return serverError;
}



#pragma mark -
#pragma mark User section


- (void) registerUserWithPhoneNumber: (NSString*) phoneNumber
                     orFacebookToken: (NSString*) facebookToken
                        successBlock: (void (^)(HWUser* user)) successBlock
                        failureBlock: (void (^)(NSError* error)) failureBlock
{
    

    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
   
    if(phoneNumber) {
        
        [params setObject: phoneNumber forKey: @"phone"];

    } else if (facebookToken) {
        
        [params setObject: facebookToken forKey: @"facebook_token"];
    }
    
    [self.networkDecorator POST: @"users"
                     parameters: params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                NSError *responseError = [self errorWithResponseObject:responseObject];
                                
                                failureBlock(responseError);
                                             
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
                            
                            NSError *serverError = [self serverErrorWithError:error];
                            
                            failureBlock(serverError);
                            
                        }];
}

- (void) loginWithPhoneNumber: (NSString*) phoneNumber
                          pin: (NSString*) pin
                 successBlock: (void (^)(HWUser* user)) successBlock
                 failureBlock: (void (^)(NSError* error)) failureBlock
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if(phoneNumber) {
        [params setObject: phoneNumber forKey: @"phone"];
    }
    
    if (pin) {
        [params setObject: pin forKey: @"pin"];
    }
    
     [self.networkDecorator PUT: @"users"
                     parameters: params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                NSError *responseError = [self errorWithResponseObject:responseObject];
                                
                                failureBlock(responseError);
                                
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
                            
                            NSError *serverError = [self serverErrorWithError:error];
                            
                            failureBlock(serverError);

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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               
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
                          
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                           
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
                                NSError *responseError = [self errorWithResponseObject:responseObject];
                                
                                failureBlock(responseError);
                                
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
                           
                            NSError *serverError = [self serverErrorWithError:error];
                            
                            failureBlock(serverError);

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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               

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
                          
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);

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
                                            
                                            NSError *responseError = [self errorWithResponseObject:responseObject];
                                            
                                            failureBlock(responseError);
                               
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
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);

                       }];
}


- (void) logOutWithSuccessBlock:(void(^)(void))successBlock
                   failureBlock:(void(^)(NSError *error))failureBlock

{
NSString *URLString = @"user/logout";

    [self.networkDecorator PUT:URLString
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           
                           successBlock();
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           failureBlock(serverError);

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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
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
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);

                       }];
}


- (void) getAvaliableTags:(void (^)(NSMutableArray * tags)) successBlock
             failureBlock: (void (^)(NSError* error)) failureBlock
{
    [self.networkDecorator GET: @"user/metatags"
                    parameters: nil
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           
                           NSError* error;
                           
                           
                           NSMutableArray* tags = [NSMutableArray array];
                           
                           
                           
                           
                           //WithDictionary: tag error: &error];
                           
                           for (NSDictionary* tag in responseObject[@"tags"])
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
                          
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                           
                       }];
}




- (void) addTagToFeed:(NSString*)tagId
         successBlock:(void(^)(void)) successBlock
             failureBlock: (void (^)(NSError* error)) failureBlock
{
    
    NSMutableDictionary* tag = [NSMutableDictionary dictionary];
    
        [tag setObject: tagId forKey: @"id"];
        [tag setObject: @"0" forKey: @"type"];

    NSMutableArray* param = [NSMutableArray array];
    [param addObject:tag];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    [params setObject:param forKey:@"tags"];
    
    
    [self.networkDecorator PUT: @"user/metatags"
                    parameters: params
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           
                           successBlock();
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                           
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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
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
                          
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);

                       }];
}

- (void) createOrUpdateItem: (HWItem*) item
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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
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
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           
                           NSError* error;
                           HWItem* item = [[HWItem alloc] initWithDictionary: responseObject[@"item"] error: &error];
                           
                           
                           NSMutableArray *userItemsArray = [NSMutableArray array];
                           NSArray *tempArray = responseObject[@"user_items"];
                           NSError *userItemsError;
                           
                           for (NSDictionary *dict in tempArray)
                           {
                               HWItem *item = [[HWItem alloc]initWithDictionary:dict error:&userItemsError];
                               [userItemsArray addObject:item];
                           }
                           item.user_items = (id)userItemsArray;
                           
                           NSMutableArray *similarItemsArray = [NSMutableArray array];
                           tempArray = responseObject[@"similar_items"];
                           NSError *similarItemsError;
                           
                           for (NSDictionary *dict in tempArray)
                           {
                               HWItem *item = [[HWItem alloc]initWithDictionary:dict error:&similarItemsError];
                               [similarItemsArray addObject:item];
                           }
                           item.similar_items = (id)similarItemsArray;
                           
                           if(similarItemsError || userItemsError)
                           {
                               NSLog(@"%@ - user\n%@ - similar",userItemsError.localizedDescription, similarItemsError.localizedDescription);
                               return;
                           }
                           if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(item);
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);

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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           
                           successBlock();
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                           
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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
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
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                       }];
}


- (void) check_selling_ability:(void(^)(void))successBlock
                  failureBlock: (void (^)(NSError* error)) failureBlock
{
    [self.networkDecorator GET:@"check_selling_ability"
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           
                           else successBlock();

     
                            }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
                            NSError *serverError = [self serverErrorWithError:error];
         
                            failureBlock(serverError);
         
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
                            
                            
                            NSLog(@"%@",responseObject);
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                NSError *responseError = [self errorWithResponseObject:responseObject];
                                
                                failureBlock(responseError);
                                
                                return;
                            }
                            
                            successBlock();
                            
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         
                          NSError *serverError = [self serverErrorWithError:error];
                          
                          failureBlock(serverError);
                          
                      }];
    
 
}


- (void) unfollowWithUserId:(NSString*)userId
               successBlock:(void(^)(void)) successBlock
               failureBlock: (void (^)(NSError* error)) failureBlock
{
    
    NSString *unfollow = [NSString stringWithFormat: @"user/followers?user_id=%@", userId];
 
    [self.networkDecorator DELETE:unfollow
                       parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                            NSLog(@"%@",responseObject);
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                      
                           successBlock();
                        
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                           
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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
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
        
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
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
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                           
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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           
                           succesBlock();
                           
                           
                           
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
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
                                    NSError *responseError = [self errorWithResponseObject:responseObject];
                                    
                                    failureBlock(responseError);
                               
                               return;
                           }
                        
                           successBlock();
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                           
                       }];
}


- (void) acceptOfferWithItemId:(NSString*)itemId
                         successBlock:(void(^)(void))successBlock
                         failureBlock:(void(^)(NSError* error))failureBlock
{
    
    [self acceptDeclineOfferWithItemId:itemId
                         acceptDecline:HWOfferAccept
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
                         acceptDecline:HWOfferDecline
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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           
                           successBlock();

                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
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
        
                         NSError *serverError = [self serverErrorWithError:error];
                         
                         failureBlock(serverError);
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
                                NSError *responseError = [self errorWithResponseObject:responseObject];
                                
                                failureBlock(responseError);
                                
                                return;
                            }
                            
                            successBlock();
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                            NSError *serverError = [self serverErrorWithError:error];
                            
                            failureBlock(serverError);
                            
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
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
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
                               NSError *serverError = [self serverErrorWithError:error];
                               
                               failureBlock(serverError);
                               
                               return;

                           }
                           
                           successBlock(commentsArray);
                           
                          
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                       }];
}


#pragma mark -
#pragma mark MentionInComment

- (void) getMentionInCommentsWithString:(NSString*)text
                           successBlock:(void(^)(NSArray *mentionsArray))successBlock
                           failureBlock:(void(^)(NSError *error)) failureBlock
{
    

//    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *decodevalue = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *URLString = [NSString stringWithFormat:@"listings/comments_people"];
   
    if(text && text.length > 0)
    {
        [params setObject: text forKey: @"q"];
    }
 
#warning please see me
    

    
    [self.networkDecorator GET:URLString
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           
                           NSArray *tempArray = responseObject[@"users"];
                           NSMutableArray *mentionArray = [NSMutableArray array];
                           NSError *error;
                           
                           for (NSDictionary *dict in tempArray)
                           {
                               HWMention *mention = [[HWMention alloc]initWithDictionary:dict error:&error];
                               [mentionArray addObject:mention];
                           }
                           
                           if(error){
                               NSLog(@"%@",error.localizedDescription);
                           }
                           
                           successBlock(mentionArray);
                           
                           
                           
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                       }];
    
    
    
    
}


#pragma mark -
#pragma mark BankCard


- (void) addNewBankCard:(NSString*)tokenId
             successBlock:(void(^)(void)) successBlock
             failureBlock: (void (^)(NSError* error)) failureBlock
{
    
    
    NSDictionary *parameter = @{@"stripe_token":tokenId};
    
    [self.networkDecorator POST:@"user/cards"
                     parameters:parameter
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            
                            
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                NSError *responseError = [self errorWithResponseObject:responseObject];
                                
                                failureBlock(responseError);
                                
                                return;
                            }
                            
                            successBlock();
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                            NSError *serverError = [self serverErrorWithError:error];
                            
                            failureBlock(serverError);
                            
                        }];
    
    
}



- (void) getAllBankCards:(void(^)(NSArray *cards))successBlock
                           failureBlock:(void(^)(NSError *error)) failureBlock
{
    
    [self.networkDecorator GET:@"user/cards"
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           
                           NSError* error;
                           NSMutableArray* cards = [NSMutableArray array];
                           for (NSDictionary* card in responseObject[@"cards"])
                           {
                               HWCard* newCard = [[HWCard alloc]initWithDictionary: card error: &error];
                               [cards addObject:newCard];
                           }
                           //
                           if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(cards);
                           
                           
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                       }];
    
}

- (void) removeBankCard:(NSString*)cardId
           successBlock:(void(^)(void)) successBlock
           failureBlock: (void (^)(NSError* error)) failureBlock
{
    
    NSDictionary *parameter = @{@"card_id":cardId};
    
    [self.networkDecorator DELETE:@"user/cards"
                     parameters:parameter
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                NSError *responseError = [self errorWithResponseObject:responseObject];
                                
                                failureBlock(responseError);
                                
                                return;
                            }
                            
                            successBlock();
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                            NSError *serverError = [self serverErrorWithError:error];
                            
                            failureBlock(serverError);
                            
                        }];
    
    
}

- (void) updateBankCard:(HWCard*)card
           successBlock:(void(^)(void)) successBlock
           failureBlock: (void (^)(NSError* error)) failureBlock
{
    
    NSDictionary *parameter = [card toDictionary];
    
    [self.networkDecorator PUT:@"user/cards"
                       parameters:parameter
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              
                              if([responseObject[@"status"] integerValue] != 0)
                              {
                                  NSError *responseError = [self errorWithResponseObject:responseObject];
                                  
                                  failureBlock(responseError);
                                  
                                  return;
                              }
                              
                              successBlock();
                              
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              
                              NSError *serverError = [self serverErrorWithError:error];
                              
                              failureBlock(serverError);
                              
                          }];
    
    
}


#pragma mark - 
#pragma mark Buy item

-(void) buyItemWithCardId:(NSString*)cardId
               withItemId:(NSString*)itemId
             successBlock:(void(^)(void))successBlock
             failureBlock:(void(^)(NSError *error)) failureBlock
{
    
    NSString *URLString = [NSString stringWithFormat:@"user/orders"];
  
    NSDictionary *parameters =  @{
                                  @"stripe_card_id":cardId,
                                  @"listing_id":itemId
                                  
                                  };
    
    [self.networkDecorator POST:URLString
                     parameters:parameters
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                NSError *responseError = [self errorWithResponseObject:responseObject];
                                
                                failureBlock(responseError);
                                
                                return;
                            }
                            
                            successBlock();

                            
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                            NSError *serverError = [self serverErrorWithError:error];
                            
                            failureBlock(serverError);
                            
                        }];
    
    
    
}


#pragma mark -
#pragma mark OrderItem


-(void)getAllOrderItemWithSuccessBlock:(void(^)(NSArray *array)) successBlock
                          failureBlock:(void(^)(NSError *error)) failureBlock
{
    
    NSString *URLString = @"user/orders";
    
    [self.networkDecorator GET:URLString
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                                NSArray *array = [self getOrderItemsArrayWithResponse:responseObject];
                                successBlock(array);
                           
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                           
                       }];
    
}

-(void) searchInOrdersWithString:(NSString*)searchText
                    successBlock:(void(^)(NSArray *array)) successBlock
                    failureBlock:(void(^)(NSError *error)) failureBlock
{
    
    NSString *URLString = [NSString stringWithFormat:@"user/orders"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if(searchText && searchText.length > 0)
    {
        [params setObject: searchText forKey: @"q"];
    }
    
    
    [self.networkDecorator GET:URLString
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           NSArray *array = [self getOrderItemsArrayWithResponse:responseObject];
                           successBlock(array);
                           
                           
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           failureBlock(serverError);
                       }];
}


- (NSArray*) getOrderItemsArrayWithResponse:(id)responseObject
{
    NSError *error;
    NSArray *ordersArray = responseObject[@"orders"];
    NSMutableArray *array = [NSMutableArray array];
    
    for ( NSDictionary *dict in ordersArray) {
        NSDictionary *listingDict = dict[@"listing"];
        
        HWOrderItem * orderItem = [[HWOrderItem alloc] init];
        orderItem.item = [[HWItem alloc]initWithDictionary:listingDict
                                                     error:&error];
        orderItem.id = dict[@"id"];
        NSNumber *numb = dict[@"status"];
        orderItem.status = [numb intValue];
        [array addObject:orderItem];
    }
    
    if (error)
    {
        NSLog(@"%@",error);
        
    }
    return array;
}



- (void) orderReceivedWithOrderId:(NSString *)orderId
                     successBlock:(void(^)(void)) successBlock
                     failureBlock:(void(^)(NSError *error)) failureBlock

{
    NSString *URLString = @"user/orders";
    NSDictionary *parametrs = @{@"order_id": orderId,
                                 @"new_status": @"1"};
    
    [self.networkDecorator PUT:URLString
                    parameters:parametrs
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }

                           successBlock();
                           
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           failureBlock(serverError);
                           
                       }];
    
    
}


- (void) orderHasInIssueWithOrderId:(NSString*)orderId
             withOrderIssuseReasons:(HWOrderIssuseReasons) orderIssuse
                       successBlock:(void(^)(void)) successBlock
                       failureBlock:(void(^)(NSError *error)) failureBlock
{
    
    NSString *URLString = @"user/orders";
    NSDictionary *parametrs = @{@"order_id": orderId,
                                @"new_status": @"2",
                                @"issue_reason": [NSString stringWithFormat:@"%ld",(long)orderIssuse]};
    
    [self.networkDecorator PUT:URLString
                    parameters:parametrs
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               failureBlock(responseError);
                               return;
                           }

                           successBlock();
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           failureBlock(serverError);
                           
                       }];
}


#pragma mark -
#pragma mark Address

- (void) addNewAddress:(HWAddress*) address
           successBlock:(void(^)(void)) successBlock
           failureBlock: (void (^)(NSError* error)) failureBlock
{
    
    
    NSDictionary* params = [address toDictionary];
    
    [self.networkDecorator POST:@"user/addresses"
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            
                            
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                NSError *responseError = [self errorWithResponseObject:responseObject];
                                
                                failureBlock(responseError);
                                
                                return;
                            }
                            
                            successBlock();
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                            NSError *serverError = [self serverErrorWithError:error];
                            
                            failureBlock(serverError);
                            
                        }];
    
    
}


- (void) getAddresses:(void(^)(NSArray *addresses))successBlock
            failureBlock:(void(^)(NSError *error)) failureBlock
{
    
    [self.networkDecorator GET:@"user/addresses"
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           
                           NSError* error;
                           NSMutableArray* addresses = [NSMutableArray array];
                           for (NSDictionary* address in responseObject[@"addresses"])
                           {
                               HWAddress* newAddress = [[HWAddress alloc]initWithDictionary: address error: &error];
                               [addresses addObject:newAddress];
                           }
                           //
                           if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(addresses);
                           
                           
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                       }];
    
}


- (void) removeAddress:(NSString*)addressId
           successBlock:(void(^)(void)) successBlock
           failureBlock: (void (^)(NSError* error)) failureBlock
{
    
    NSDictionary *parameter = @{@"address_id":addressId};
    
    [self.networkDecorator DELETE:@"user/addresses"
                       parameters:parameter
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              
                              if([responseObject[@"status"] integerValue] != 0)
                              {
                                  NSError *responseError = [self errorWithResponseObject:responseObject];
                                  
                                  failureBlock(responseError);
                                  
                                  return;
                              }
                              
                              successBlock();
                              
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              
                              NSError *serverError = [self serverErrorWithError:error];
                              
                              failureBlock(serverError);
                              
                          }];
    
    
}

- (void) updateAddress:(HWAddress*)address
           successBlock:(void(^)(void)) successBlock
           failureBlock: (void (^)(NSError* error)) failureBlock
{
    
    NSDictionary *parameter = [address toDictionary];
    
    [self.networkDecorator POST:@"user/addresses"
                    parameters:parameter
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               
                               failureBlock(responseError);
                               
                               return;
                           }
                           
                           successBlock();
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           
                           failureBlock(serverError);
                           
                       }];
    
    
}

- (void) getRecentlyAddress:(void(^)(HWAddress *address))successBlock
               failureBlock:(void(^)(NSError *error)) failureBlock
{
    [self.networkDecorator PUT:@"user/addresses"
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               NSError *responseError = [self errorWithResponseObject:responseObject];
                               failureBlock(responseError);
                               return;
                           }
                           
                           NSError* error;
                           
                           HWAddress* address = [[HWAddress alloc] initWithDictionary: responseObject[@"addresses"] error: &error];
                           
                           if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(address);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSError *serverError = [self serverErrorWithError:error];
                           failureBlock(serverError);
                           
                       }];

}


@end

