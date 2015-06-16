//
//  OCFacebookHelper.h
//
//  Created by Serg Shulga on 6/24/14.
//  Copyright (c) 2014 Voxience. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFacebookHelper : NSObject

+ (instancetype) shared;

- (void) loginFacebookSuccess:(void (^)(NSDictionary *response))successBlock failure:(void (^)(NSError *error))failure;
- (void) linkFacebookWithCompletionBlock: (void (^)(NSError *error)) completionBlock;
- (void) postToFacebookWithMessage:(NSString *)message completionBlock:(void (^)(NSError *))completionBlock;

@end
