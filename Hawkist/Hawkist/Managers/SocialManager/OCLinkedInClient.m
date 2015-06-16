//
//  OCLinkedInClient.m
//
//  Created by Den on 05.03.14.
//  Copyright (c) 2014 Voxience. All rights reserved.
//

#import "OCLinkedInClient.h"
#import "const.h"

NSString *OCLinkedInShowControllerNotification = @"OCLinkedInShowControllerNotification";
NSString *OCLinkedInController = @"OCLinkedInController";

@interface OCLinkedInClient()

@property (nonatomic, strong) LIALinkedInHttpClient *client;

@end

@implementation OCLinkedInClient

#pragma mark - Life Cycle

+ (instancetype)sharedClient{
    static id instance_ = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance_ = [[self alloc] init];
	});
	
	return instance_;
}

- (void)loginWithBlock:(OCLinkedInBlock)block{
    self.block = block;
    
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken completion:block];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
        block(nil, nil);
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
        block(nil, error);
    }];
}

- (void)requestMeWithToken:(NSString *)accessToken completion:(OCLinkedInBlock)completion{
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first_name,last_name,email-address,site-standard-profile-request)?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *profile) {

        OCLinkedInUser *user = [OCLinkedInUser new];
        
        user.email = profile[@"emailAddress"];
        user.firstName = profile[@"firstName"];
        user.lastName = profile[@"lastName"];
        user.userId = profile[@"id"];
        user.token = accessToken;
        
        completion(user, nil);
        
    }        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
        completion(nil, error);
    }];
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:LINKED_IN_REDIRECT_URI
                                                                                    clientId:LINKED_IN_API_KEY
                                                                                clientSecret:LINKED_IN_SECRET_KEY
                                                                                       state:LINKED_IN_STATE
                                                                               grantedAccess:@[@"r_basicprofile", @"r_emailaddress"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

@end

@implementation OCLinkedInUser

- (NSString *)fullName{
    NSString *name = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    return name;
}

@end
