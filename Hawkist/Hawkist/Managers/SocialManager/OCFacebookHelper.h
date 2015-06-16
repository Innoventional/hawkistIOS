
#import <Foundation/Foundation.h>

@interface OCFacebookHelper : NSObject

+ (instancetype) shared;

- (void) loginFacebookSuccess:(void (^)(NSDictionary *response))successBlock failure:(void (^)(NSError *error))failure;
- (void) linkFacebookWithCompletionBlock: (void (^)(NSError *error)) completionBlock;
- (void) postToFacebookWithMessage:(NSString *)message completionBlock:(void (^)(NSError *))completionBlock;

@end
