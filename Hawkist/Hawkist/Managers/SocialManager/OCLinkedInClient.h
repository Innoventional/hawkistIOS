//
//  OCLinkedInClient.h
//
//  Created by Den on 05.03.14.
//  Copyright (c) 2014 Voxience. All rights reserved.
//

#import "AFNetworking.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"


@class OCLinkedInUser;

typedef void(^OCLinkedInBlock)(OCLinkedInUser *user, NSError *error);

extern NSString *OCLinkedInShowControllerNotification;
extern NSString *OCLinkedInController;

@interface OCLinkedInUser : NSObject

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic, readonly) NSString *fullName;
@property (strong, nonatomic) NSString *userId;

@end

@interface OCLinkedInClient : NSObject

@property (copy, nonatomic) OCLinkedInBlock block;

+ (instancetype) sharedClient;

- (void) loginWithBlock:(OCLinkedInBlock)block;

@end
