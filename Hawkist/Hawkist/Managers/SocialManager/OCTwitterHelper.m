//
//  OCTwitterHelper.m
//
//  Created by Serg Shulga on 6/24/14.
//  Copyright (c) 2014 Voxience. All rights reserved.
//

#import "TWTAPIManager.h"
#import "OCTwitterHelper.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "const.h"
#import "FFSocialManager.h"

static OCTwitterHelper* twitterHelperInstance = nil;

@interface OCTwitterHelper ()

@property (nonatomic, strong) TWTAPIManager *apiManager;

@end

@implementation OCTwitterHelper

#pragma mark - General

+ (instancetype) shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        twitterHelperInstance = [OCTwitterHelper new];
    });
    return twitterHelperInstance;
}

- (id) init
{
    if (self = [super init])
    {
        self.apiManager = [TWTAPIManager new];
    }
    return self;
}

#pragma mark - Login 

- (void) loginTwitterSuccess:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSError *))failure
{
    [self getTwitterAccountsWithCompletionBlock:^(NSArray *twitterAccounts, NSError *error)
    {
        
        if(error != nil)
        {
            if(failure != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }
        }
        
        if(twitterAccounts.count == 1)
        {
            ACAccount *twitterAccount = [twitterAccounts lastObject];
            [self proceedTwitterAccount:twitterAccount success:successBlock failure:failure];
        }
        else if (twitterAccounts.count > 1)
        {
            NSMutableArray* accountNames = [NSMutableArray arrayWithCapacity: twitterAccounts.count];
            for (ACAccount* acc in twitterAccounts)
            {
                [accountNames addObject: acc.username];
            }
            
            NSError *localError = [NSError errorWithDomain:NSStringFromClass(self.class) code:SNCannotAutolinkErrorCode userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"You need to choose account", @"You need to choose account"), @"Accounts":accountNames}];
            
            if(failure != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(localError);
                });
            }
        }
    }];
}

- (void) loginTwitterUsername: (NSString*) username success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSError *))failure
{
    [self getTwitterAccountsWithCompletionBlock:^(NSArray *twitterAccounts, NSError *error)
     {
         if(error != nil)
         {
             if(failure != nil)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     failure(error);
                 });
             }
         }
         else
         {
             for (ACAccount* acc in twitterAccounts)
             {
                 if ([acc.username isEqualToString: username])
                 {
                     [self proceedTwitterAccount:acc success:successBlock failure:failure];
                     break;
                 }
             }
         }
     }];
}

- (void)proceedTwitterAccount:(ACAccount*)account success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *response = [NSMutableDictionary new];
    
    NSString *userID = [[account valueForKey:@"properties"] objectForKey:@"user_id"];
    NSString *username = account.username;
    
    if (nil != userID)
    {
        response[FFSocialUserID] = userID;
    }
    
    if (nil != username)
    {
        response[FFSocialFullName] = username;
        
        NSArray *nameArray = [username componentsSeparatedByString: @" "];
        
        NSString *firstName;
        if(nameArray.count > 0)
            firstName = [nameArray objectAtIndex: 0];
        
        NSString *lastName;
        if(nameArray.count > 1)
            lastName = [nameArray objectAtIndex: 1];
        if (nil != firstName)
        {
            response[FFSocialFirstName] = firstName;
        }
        
        if (nil != lastName)
        {
            response[FFSocialLastName] = lastName;
        }

    }
    
    [self.apiManager performReverseAuthForAccount:account withHandler:^(NSData *responseData, NSError *error) {
        if (responseData) {
            NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
            NSMutableDictionary *values = [NSMutableDictionary new];
            
            for (NSString *keyValuePair in parts)
            {
                NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
                NSString *key = [pairComponents objectAtIndex:0];
                NSString *value = [pairComponents objectAtIndex:1];
                
                [values setObject:value forKey:key];
            }
            
            id token = values[@"oauth_token"];
            id secret = values[@"oauth_token_secret"];
            
            if (nil != token && nil != secret)
            {
                response[FFSocialToken] = token;
                response[FFSocialSecret] = secret;
                
                if (successBlock != nil)
                {
                    successBlock(response);
                }
            }else
            {
                NSError *error = [NSError errorWithDomain:@"twitter" code:1 userInfo:@{NSLocalizedDescriptionKey: @"Can't retrieve twitter token"}];
                failure(error);
            }
        }
        else {
            failure(error);
        }
    }];
}



- (void) linkTwitterWithCompletionBlock: (void (^)(NSArray* accounts, NSError *error)) completionBlock
{
//    [self getTwitterAccountsWithCompletionBlock:^(NSArray *twitterAccounts, NSError *error)
//    {
//        if(error != nil)
//        {
//            if(completionBlock != nil)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completionBlock(nil, error);
//                });
//            }
//        }
//        
//        if(twitterAccounts.count == 1)
//        {
//            ACAccount *twitterAccount = [twitterAccounts lastObject];
//            
//            [OCUser user].twitterId = [[twitterAccount valueForKey:@"properties"] objectForKey:@"user_id"];
//            [[OCUser user] save];
//            [[OCUser user] saveUserOnServer];
//            if (completionBlock != nil)
//            {
//                completionBlock(nil, nil);
//            }
//        }
//        else if (twitterAccounts.count > 1)
//        {
//            NSMutableArray* accountNames = [NSMutableArray arrayWithCapacity: twitterAccounts.count];
//            for (ACAccount* acc in twitterAccounts)
//            {
//                [accountNames addObject: acc.username];
//            }
//            
//            NSError *localError = [NSError errorWithDomain:NSStringFromClass(self.class) code:SNCannotAutolinkErrorCode userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"You need to choose account", @"You need to choose account"), @"Accounts":accountNames}];
//            
//            if(completionBlock != nil)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completionBlock(accountNames, localError);
//                });
//            }
//        }
//    }];
}

- (void) linkTwitterWithUsername: (NSString*) username andCompletionBlock: (void (^)(NSError *error)) completionBlock
{
//    [self getTwitterAccountsWithCompletionBlock:^(NSArray *twitterAccounts, NSError *error)
//    {
//        if(error != nil)
//        {
//            if(completionBlock != nil)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completionBlock(error);
//                });
//            }
//        }
//        else
//        {
//            for (ACAccount* acc in twitterAccounts)
//            {
//                if ([acc.username isEqualToString: username])
//                {
//                    [OCUser user].twitterId = [[acc valueForKey:@"properties"] objectForKey:@"user_id"];
//                    [[OCUser user] save];
//                    [[OCUser user] saveUserOnServer];
//                    break;
//                }
//            }
//            
//            NSError* error = nil;
//            
//            if ([OCUser user].twitterId == nil)
//            {
//                error = [NSError errorWithDomain:NSStringFromClass(self.class) code:SNNoAccountErrorCode userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Wrong account name!", @"Wrong account name!")}];
//            }
//            
//            if (completionBlock != nil)
//            {
//                completionBlock(error);
//            }
//        }
//    }];
}

#pragma mark - Post

- (void) tweetWithMessage:(NSString *)message completionBlock:(void(^)(NSError *error))block
{
    [self getLinkedAccountWithCompletionBlock:^(ACAccount *twitterAccount, NSError *error)
    {
        if (error)
        {
            NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
            [userInfo setObject:message forKey:@"tweetMessage"];
            
            __block NSError* localError = [NSError errorWithDomain:error.domain
                                                              code:error.code
                                                          userInfo:[NSDictionary dictionaryWithDictionary:userInfo]];
            
            if(block != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(localError);
                });
            }
        }
        
        if (twitterAccount)
        {
            SLRequest *aRequest  = [SLRequest requestForServiceType: SLServiceTypeTwitter
                                                      requestMethod: SLRequestMethodPOST
                                                                URL: [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"]
                                                         parameters: [NSDictionary dictionaryWithObject:message forKey:@"status"]];
            [aRequest setAccount: twitterAccount];
            
            [aRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == nil)
                    {
                        
                    }
                    if (block != nil)
                    {
                        block(error);
                    }
                });
            }];
        }
    }];
}

#pragma mark - Private

- (void) getTwitterAccountsWithCompletionBlock: (void(^)(NSArray* twitterAccounts, NSError* error)) completionBlock
{
    static ACAccountStore *accountStore;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        accountStore = [[ACAccountStore alloc] init];
    });
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType: accountType options: nil completion: ^(BOOL granted, NSError *error)
     {
         if(error == nil)
         {
             // Did user allow us access?
             if(granted == YES)
             {
                 // Populate array with all available Twitter accounts
                 NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
                 
                 self.twitterAccounts = arrayOfAccounts;
                 
                 if (self.twitterAccounts == nil || self.twitterAccounts.count == 0)
                 {
                     error = [NSError errorWithDomain:@"Twitter" code:SNNoAccountErrorCode userInfo:@{NSLocalizedDescriptionKey:@"Please login to Twitter in the device Settings"}];
                 }
                 
                 if(completionBlock != nil)
                 {
                     completionBlock(arrayOfAccounts, error);
                 }
             }
             else
             {
                 NSError *localError = [NSError errorWithDomain:NSStringFromClass(self.class) code:SNAccessDisabledCode userInfo:@{NSLocalizedDescriptionKey:@"Twitter access disabled"}];
                 if(completionBlock != nil)
                 {
                     completionBlock(nil, localError);
                 }
             }
         }
         else
         {
             if (error.code == SNNoAccountErrorCode)
             {
                 error = [NSError errorWithDomain:error.domain code:SNNoAccountErrorCode userInfo:@{NSLocalizedDescriptionKey:@"Please login to Twitter in the device Settings"}];
             }
             if(completionBlock != nil)
             {
                 completionBlock(nil, error);
             }
         }
     }];
}

- (void) getLinkedAccountWithCompletionBlock: (void(^)(ACAccount* twitterAccount, NSError* error)) completionBlock
{
//    [self getTwitterAccountsWithCompletionBlock:^(NSArray *twitterAccounts, NSError *error) {
//        if (error != nil)
//        {
//            if (completionBlock != nil)
//            {
//                completionBlock(nil, error);
//            }
//            return;
//        }
//        
//        if ([OCUser user].twitterId.length == 0)
//        {
//            NSError *localError = [NSError errorWithDomain:NSStringFromClass(self.class) code:SNNotLinkedErrorCode userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Twitter not linked", @"Twitter not linked")}];
//            if(completionBlock != nil)
//            {
//                completionBlock(nil, localError);
//            }
//            return;
//        }
//        
//        for (ACAccount* account in self.twitterAccounts)
//        {
//            NSDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:[account dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"properties"]]];
//            NSString *tempUserID = [[tempDict objectForKey:@"properties"] objectForKey:@"user_id"];
//            
//            if([[OCUser user].twitterId isEqualToString: tempUserID])
//            {
//                if (completionBlock != nil)
//                {
//                    completionBlock(account, nil);
//                }
//                return;
//            }
//        }
//        
//        // account not found
//        NSError *localError = [NSError errorWithDomain:NSStringFromClass(self.class) code:SNNoLinkedAccountInSettingsErrorCode userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"You linked another Twitter account", @"You linked another Twitter account")}];
//        if (completionBlock != nil)
//        {
//            completionBlock(nil, localError);
//        }
//    }];
}

@end
