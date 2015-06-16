//
//  OCFacebookHelper.m
//
//  Created by Serg Shulga on 6/24/14.
//  Copyright (c) 2014 Voxience. All rights reserved.
//

#import "OCFacebookHelper.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "const.h"
#import "FFSocialManager.h"
#import "OCUtilites.h"

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
                response[FFSocialUserID] = userID;
            }
            
            if (nil != email)
            {
                response[FFSocialEmail] = email;
            }
            
            if (nil != fullname)
            {
                response[FFSocialFullName] = fullname;
            }
            
            if (nil != accessToken)
            {
                response[FFSocialToken] = accessToken;
            }
            
            if (nil != firstName)
            {
                response[FFSocialFirstName] = firstName;
            }
            
            if (nil != lastName)
            {
                response[FFSocialLastName] = lastName;
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
                     error = [NSError errorWithDomain:@"Facebook" code:SNNoAccountErrorCode userInfo:@{NSLocalizedDescriptionKey:@"Please login to Facebook in the device Settings"}];
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
                 NSError *localError = [NSError errorWithDomain:NSStringFromClass(self.class) code:SNAccessDisabledCode userInfo:@{NSLocalizedDescriptionKey:@"Facebook access disabled"}];
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
                     error = [NSError errorWithDomain:@"Facebook" code:SNNoAccountErrorCode userInfo:@{NSLocalizedDescriptionKey:@"Please login to Facebook in the device Settings"}];
                 }
                 if (error.code == 7)
                 {
                     error = [NSError errorWithDomain:@"Facebook" code:SNAccessDisabledCode userInfo:@{NSLocalizedDescriptionKey:@"In order to sign into FaceToFace using your Facebook account you must allow it to post to your friends on your behalf"}];
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
