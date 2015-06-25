
#import "OCFacebookHelper.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "const.h"
#import "SocialManager.h"
#import "OCUtilites.h"

const NSInteger SNAccessDisabledCode = -1001;
const NSInteger SNNotLinkedErrorCode = -1002;
const NSInteger SNLinkedToAnotherUserErrorCode = -1003;
const NSInteger SNNoLinkedAccountInSettingsErrorCode = -1004;
const NSInteger SNCannotAutolinkErrorCode = -1005;
const NSInteger SNNoAccountErrorCode = 6;


static OCFacebookHelper* fbHelperInstance = nil;

@implementation OCFacebookHelper

#pragma mark - General

+ (instancetype) shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        fbHelperInstance = [OCFacebookHelper new];
    });
    return fbHelperInstance;
}

#pragma mark - Login

- (void)loginFacebookSuccess:(void (^)(NSDictionary* ))successBlock failure:(void (^)(NSError *))failure
{
    [self getFacebookUserWithCompletionBlock:^(ACAccount *fbAccount, NSError *error)
    {
        if (error != nil)
        {
            if (failure != nil)
            {
                failure(error);
            }
        }
        else
        {
            ACAccountCredential *fbCredential = [fbAccount credential];
            NSString *accessToken = [fbCredential oauthToken];
            
            NSString *userID = [NSString stringWithFormat: @"%@", [[fbAccount valueForKey:@"properties"] objectForKey:@"uid"]];
            NSString *email = [[fbAccount valueForKey:@"properties"] objectForKey:@"ACUIDisplayUsername"];
            if (![OCUtilites NSStringIsValidEmail:email]) {
                email = fbAccount.username;
                if (![OCUtilites NSStringIsValidEmail:email]) {
                    email = nil;
                }
            }
            
            NSString *fullname = [[fbAccount valueForKey:@"properties"] objectForKey:@"ACPropertyFullName"];
            
            NSArray *nameArray = [fullname componentsSeparatedByString: @" "];
           
            NSString *firstName;
            if(nameArray.count > 0)
                firstName = [nameArray objectAtIndex: 0];
            
            NSString *lastName;
            if(nameArray.count > 1)
                lastName = [nameArray objectAtIndex: 1];
            
            NSMutableDictionary *response = [NSMutableDictionary new];
            
            if (nil != userID)
            {
                response[SocialUserID] = userID;
            }
            
            if (nil != email)
            {
                response[SocialEmail] = email;
            }
            
            if (nil != fullname)
            {
                response[SocialFullName] = fullname;
            }
            
            if (nil != accessToken)
            {
                response[SocialToken] = accessToken;
            }
            
            if (nil != firstName)
            {
                response[SocialFirstName] = firstName;
            }
            
            if (nil != lastName)
            {
                response[SocialLastName] = lastName;
            }
            
            if (successBlock != nil)
            {
                successBlock(response);
            }
        }
    }];
}

- (void) linkFacebookWithCompletionBlock: (void (^)(NSError *error)) completionBlock
{
//    [self getFacebookUserWithCompletionBlock:^(ACAccount *fbAccount, NSError *error)
//     {
//         if (error != nil)
//         {
//             if (completionBlock != nil)
//             {
//                 completionBlock(error);
//             }
//         }
//         else
//         {
//             [OCUser user].facebookId = [NSString stringWithFormat: @"%@", [[fbAccount valueForKey:@"properties"] objectForKey:@"uid"]];
//             [[OCUser user] save];
//             [[OCUser user] saveUserOnServer];
//             if (completionBlock != nil)
//             {
//                 completionBlock(nil);
//             }
//         }
//     }];
}

#pragma mark - Post

- (void)postToFacebookWithMessage:(NSString *)message completionBlock:(void (^)(NSError *))completionBlock
{
    [self getLinkedFacebookUserWithCompletionBlock:^(ACAccount* fbAccount, NSError* error)
    {
        if (error != nil)
        {
            completionBlock(error);
        }
        else
        {
            NSDictionary *parameters = @{@"access_token": fbAccount.credential.oauthToken,
                                              @"message": message};
            
            NSURL *feedURL = [NSURL
                              URLWithString:@"https://graph.facebook.com/me/feed"];
            
            SLRequest *feedRequest =[SLRequest requestForServiceType: SLServiceTypeFacebook
                                                       requestMethod: SLRequestMethodPOST
                                                                 URL: feedURL
                                                          parameters: parameters];
            
            [feedRequest performRequestWithHandler: ^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error)
             {
                 if (completionBlock != nil)
                 {
                     completionBlock(error);
                 }
             }];
        }
    }];
}


#pragma mark - Private

- (void) getFacebookUserWithCompletionBlock:(void(^)(ACAccount* fbAccount, NSError *error))completionBlock
{
    static ACAccountStore *accountStore;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        accountStore = [[ACAccountStore alloc] init];
    });

    NSDictionary *options = @{
                              ACFacebookAppIdKey: FACEBOOK_APP_ID,
                              ACFacebookPermissionsKey: @[ @"email"/*, @"publish_actions"*/],
                              ACFacebookAudienceKey: ACFacebookAudienceFriends
                              };
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [accountStore requestAccessToAccountsWithType: accountType options: options completion: ^(BOOL granted, NSError *error)
     {
         if(error == nil)
         {
             // Did user allow us access?
             if(granted == YES)
             {
                 NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
                 
                 if (arrayOfAccounts == nil || arrayOfAccounts.count == 0)
                 {
                     error = [NSError errorWithDomain:@"Please login to Facebook in the device Settings" code:SNNoAccountErrorCode userInfo:@{NSLocalizedDescriptionKey:@"Please login to Facebook in the device Settings"}];
                     completionBlock(nil, error);
                 }
                 else
                 {
                     ACAccount* account = [arrayOfAccounts lastObject];
                     
                     [accountStore renewCredentialsForAccount: account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error)
                      {
                         completionBlock(account, nil);
                     }];
                     
                     
                     
                     return;
                 }
             }
             else
             {
                 NSError *localError = [NSError errorWithDomain: @"Cannot Access Facebook. In order to Sign Up With Facebook, please allow Hawkist access. Navigate to Settings > Privacy > Facebook and enable Hawkist." code:SNAccessDisabledCode userInfo:@{NSLocalizedDescriptionKey:@"Cannot Access Facebook. In order to Sign Up With Facebook, please allow Hawkist access. Navigate to Settings > Privacy > Facebook and enable Hawkist."}];
                 if(completionBlock != nil)
                 {
                     completionBlock(nil, localError);
                 }
             }
         }
         else
         {
             if(completionBlock != nil)
             {
                 if (error.code == 6)
                 {
                     error = [NSError errorWithDomain:@"Please login to Facebook in the device Settings" code:SNNoAccountErrorCode userInfo:@{NSLocalizedDescriptionKey:@"Please login to Facebook in the device Settings"}];
                 }
                 if (error.code == 7)
                 {
                     error = [NSError errorWithDomain:@"Connect to Facebook. Hawkist would like access to your basic profile info and friends list" code:SNAccessDisabledCode userInfo:@{NSLocalizedDescriptionKey:@"Connect to Facebook. Hawkist would like access to your basic profile info and friends list"}];
                 }
                 completionBlock(nil, error);
             }
         }
     }];
}

- (void)getLinkedFacebookUserWithCompletionBlock:(void (^)(ACAccount *, NSError *))completionBlock
{
//    if([OCUser user].facebookId.length != 0)
//    {
//        [self getFacebookUserWithCompletionBlock:^(ACAccount* account, NSError *error)
//        {
//            if(error == nil && [OCUser user].facebookId.longLongValue != [[[account valueForKey:@"properties"] objectForKey:@"uid"] longLongValue])
//            {
//                error = [NSError errorWithDomain:@"Facebook" code:SNNoLinkedAccountInSettingsErrorCode userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"You linked another Facebook account", @"You linked another Facebook account")}];
//            }
//            
//            if(completionBlock != nil)
//            {
//                completionBlock(account, error);
//            }
//        }];
//    }
//    else
//    {
//        NSError *error = [NSError errorWithDomain:@"Facebook" code:SNNotLinkedErrorCode userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Facebook not linked", @"Facebook not linked")}];
//        if(completionBlock != nil)
//        {
//            completionBlock(nil, error);
//        }
//    }
}

@end
