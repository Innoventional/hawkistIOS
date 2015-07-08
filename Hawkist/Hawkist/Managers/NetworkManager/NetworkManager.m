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

@interface NetworkManager ()

@property (strong, nonatomic) NetworkDecorator *networkDecorator;

@end


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
                                failureBlock([NSError errorWithDomain: responseObject[@"message"] code: [responseObject[@"status"] integerValue] userInfo: nil]);
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
                            failureBlock(error);
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
                                failureBlock([NSError errorWithDomain: responseObject[@"message"] code: [responseObject[@"status"] integerValue] userInfo: nil]);
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
                            failureBlock(error);
                        }];
}

- (void) getUserProfileWithSuccessBlock: (void (^)(HWUser* user)) successBlock
                           failureBlock: (void (^)(NSError* error)) failureBlock
{
    [self.networkDecorator GET: @"user"
                     parameters: nil
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if([responseObject[@"status"] integerValue] != 0)
                            {
                                failureBlock([NSError errorWithDomain: responseObject[@"message"] code: [responseObject[@"status"] integerValue] userInfo: nil]);
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
                            failureBlock(error);
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
                                failureBlock([NSError errorWithDomain: responseObject[@"message"] code: [responseObject[@"status"] integerValue] userInfo: nil]);
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
                            failureBlock(error);
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
                               failureBlock([NSError errorWithDomain: responseObject[@"message"] code: [responseObject[@"status"] integerValue] userInfo: nil]);
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
                           failureBlock(error);
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
                               failureBlock([NSError errorWithDomain: responseObject[@"message"][@"message"] code: [responseObject[@"message"][@"status"] integerValue] userInfo: nil]);
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
                           failureBlock(error);
                       }];
}

- (void) getListOfTags: (void (^)(NSMutableArray * tags)) successBlock
          failureBlock: (void (^)(NSError* error)) failureBlock
{
    [self.networkDecorator GET: @"tags"
                    parameters: nil
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock([NSError errorWithDomain: responseObject[@"message"][@"message"] code: [responseObject[@"message"][@"status"] integerValue] userInfo: nil]);
                               return;
                           }
                           
                           NSError* error;

                           
                           NSMutableArray* tags = [NSMutableArray array];
                           
                           for (NSDictionary* tag in responseObject[@"tags"])
                           {
                                 HWTag* newTag = [[HWTag alloc] initWithDictionary: tag error: &error];
                                [tags addObject:newTag];
                           }
                           
                           if(error)
                           {
                               failureBlock(error);
                               return;
                           }
                           
                           successBlock(tags);
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failureBlock(error);
                       }];
}

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
    
    [self.networkDecorator GET: @"items"
                    parameters: params
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock([NSError errorWithDomain: responseObject[@"message"] code: [responseObject[@"status"] integerValue] userInfo: nil]);
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
                           failureBlock(error);
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
    
    [self.networkDecorator POST: @"items"
                    parameters: params
     
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if([responseObject[@"status"] integerValue] != 0)
                           {
                               failureBlock([NSError errorWithDomain: responseObject[@"message"] code: [responseObject[@"status"] integerValue] userInfo: nil]);
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
                           failureBlock(error);
                       }];
}

@end
