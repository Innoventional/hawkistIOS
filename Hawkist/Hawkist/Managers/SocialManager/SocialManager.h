#import <Foundation/Foundation.h>

extern const NSString *SocialUserID;
extern const NSString *SocialEmail;
extern const NSString *SocialFullName;
extern const NSString *SocialToken;
extern const NSString *SocialSecret;
extern const NSString *SocialFirstName;
extern const NSString *SocialLastName;

@interface SocialManager : NSObject

+ (id) shared;

- (void) loginFacebookSuccess:(void (^)(NSDictionary *response))successBlock failure:(void (^)(NSError *error))failure;
- (void) linkFacebookWithCompletionBlock: (void (^)(NSError *error)) completionBlock;


@end
