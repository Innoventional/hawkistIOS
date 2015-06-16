
#import "SocialManager.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "const.h"
#import "OCTwitterHelper.h"
#import "OCFacebookHelper.h"

const NSString *FFSocialUserID = @"FFSocialUserID";
const NSString *FFSocialEmail = @"FFSocialEmail";
const NSString *FFSocialFullName = @"FFSocialFullName";
const NSString *FFSocialToken = @"FFSocialToken";
const NSString *FFSocialSecret = @"FFSocialSecret";
const NSString *FFSocialFirstName = @"FFSocialFirstName";
const NSString *FFSocialLastName = @"FFSocialLastName";


@interface SocialManager ()

@end

@implementation SocialManager

#pragma mark -
#pragma mark Lifecycle

+ (id) shared
{
    static SocialManager* sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SocialManager alloc] init];
    });
    return sharedManager;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}


#pragma mark - Twitter

- (void) loginTwitterSuccess:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSError *))failure
{
    [[OCTwitterHelper shared] loginTwitterSuccess: successBlock failure: failure];
}

- (void) loginTwitterUsername: (NSString*) username success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSError *))failure
{
    [[OCTwitterHelper shared] loginTwitterUsername: username success: successBlock failure: failure];
}

- (void) linkTwitterWithCompletionBlock: (void (^)(NSArray* accounts, NSError *error)) completionBlock
{
    [[OCTwitterHelper shared] linkTwitterWithCompletionBlock: completionBlock];
}

- (void) linkTwitterWithUsername: (NSString*) username andCompletionBlock: (void (^)(NSError *error)) completionBlock
{
    [[OCTwitterHelper shared] linkTwitterWithUsername: username andCompletionBlock: completionBlock];
}

#pragma mark - Facebook

- (void)loginFacebookSuccess:(void (^)(NSDictionary* ))successBlock failure:(void (^)(NSError *))failure
{
    [[OCFacebookHelper shared] loginFacebookSuccess: successBlock failure: failure];
}

- (void) linkFacebookWithCompletionBlock: (void (^)(NSError *error)) completionBlock
{
    [[OCFacebookHelper shared] linkFacebookWithCompletionBlock: completionBlock];
}

#pragma mark - Post

- (void) postMessage: (NSString*) message
{
//    if ([OCUser user].shareActivity)
//    {
//        if ([OCUser user].isFacebookSharingActive)
//        {
//            [[OCFacebookHelper shared] postToFacebookWithMessage: message
//                                                 completionBlock: ^(NSError* error)
//             {
//                 
//             }];
//        }
//        
//        if ([OCUser user].isTwitterSharingActive)
//        {
//            [[OCTwitterHelper shared] tweetWithMessage: message
//                                       completionBlock: ^(NSError *error)
//             {
//                 
//             }];
//        }
//    }
}


@end
