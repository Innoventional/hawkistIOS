
#import "SocialManager.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "const.h"
#import "OCFacebookHelper.h"

const NSString *SocialUserID = @"SocialUserID";
const NSString *SocialEmail = @"SocialEmail";
const NSString *SocialFullName = @"SocialFullName";
const NSString *SocialToken = @"SocialToken";
const NSString *SocialSecret = @"SocialSecret";
const NSString *SocialFirstName = @"SocialFirstName";
const NSString *SocialLastName = @"SocialLastName";


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


#pragma mark - Facebook

- (void)loginFacebookSuccess:(void (^)(NSDictionary* ))successBlock failure:(void (^)(NSError *))failure
{
    [[OCFacebookHelper shared] loginFacebookSuccess: successBlock failure: failure];
}

- (void) linkFacebookWithCompletionBlock: (void (^)(NSError *error)) completionBlock
{
    [[OCFacebookHelper shared] linkFacebookWithCompletionBlock: completionBlock];
}

@end
