#import <Foundation/Foundation.h>

const NSInteger SNAccessDisabledCode = -1001;
const NSInteger SNNotLinkedErrorCode = -1002;
const NSInteger SNLinkedToAnotherUserErrorCode = -1003;
const NSInteger SNNoLinkedAccountInSettingsErrorCode = -1004;
const NSInteger SNCannotAutolinkErrorCode = -1005;
const NSInteger SNNoAccountErrorCode = 6;

extern const NSString *FFSocialUserID;
extern const NSString *FFSocialEmail;
extern const NSString *FFSocialFullName;
extern const NSString *FFSocialToken;
extern const NSString *FFSocialSecret;
extern const NSString *FFSocialFirstName;
extern const NSString *FFSocialLastName;

@interface SocialManager : NSObject

@property (nonatomic, strong) NSArray* twitterAccounts;

+ (id) shared;

- (void) loginTwitterSuccess:(void (^)(NSDictionary *response))successBlock failure:(void (^)(NSError *error))failure;
- (void) loginTwitterUsername: (NSString*) username success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSError *))failure;
- (void) linkTwitterWithCompletionBlock: (void (^)(NSArray* accounts, NSError *error)) completionBlock;
- (void) linkTwitterWithUsername: (NSString*) username andCompletionBlock: (void (^)(NSError *error)) completionBlock;

- (void) loginFacebookSuccess:(void (^)(NSDictionary *response))successBlock failure:(void (^)(NSError *error))failure;
- (void) linkFacebookWithCompletionBlock: (void (^)(NSError *error)) completionBlock;

- (void) postMessage: (NSString*) message;

@end
