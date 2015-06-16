//
//  OCTwitterHelper.h
//
//  Created by Serg Shulga on 6/24/14.
//  Copyright (c) 2014 Voxience. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCTwitterHelper : NSObject

@property (nonatomic, strong) NSArray* twitterAccounts;

+ (instancetype) shared;

- (void) loginTwitterSuccess:(void (^)(NSDictionary *response))successBlock failure:(void (^)(NSError *error))failure;
- (void) loginTwitterUsername: (NSString*) username success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSError *))failure;
- (void) linkTwitterWithCompletionBlock: (void (^)(NSArray* accounts, NSError *error)) completionBlock;
- (void) linkTwitterWithUsername: (NSString*) username andCompletionBlock: (void (^)(NSError *error)) completionBlock;
- (void) tweetWithMessage:(NSString *)message completionBlock:(void(^)(NSError *error))block;

@end
