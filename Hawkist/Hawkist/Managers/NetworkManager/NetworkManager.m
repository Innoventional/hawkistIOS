//
//  NetworkManager.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/16/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "NetworkManager.h"
#import "NetworkDecorator.h"

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
                            if([responseObject[@"success"] integerValue] != 0)
                            {
                                failureBlock([NSError errorWithDomain: @"Some error occured in proccess of user registration" code: [responseObject[@"success"] integerValue] userInfo: nil]);
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
    
    [self.networkDecorator POST: @"users"
                     parameters: params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if([responseObject[@"success"] integerValue] != 0)
                            {
                                failureBlock([NSError errorWithDomain: @"Some error occured in proccess of user login/registration" code: [responseObject[@"success"] integerValue] userInfo: nil]);
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

@end
