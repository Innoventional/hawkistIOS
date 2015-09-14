//
//  HWZendesk.m
//  Hawkist
//
//  Created by User on 07.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWZendesk.h"
#import <ZendeskSDK/ZendeskSDK.h>
#import "UIColor+Extensions.h"


@implementation HWZendesk

#define ZENDESK_APPID           @"475beb8068c9472bda4f61c986e4ed6de28c120465e512aa"
#define ZENDESK_URL             @"https://hawkist.zendesk.com"
#define ZENDESK_CLIENT_ID       @"mobile_sdk_client_017b0642674c40d7b0e0"


+(HWZendesk*)shared {
    
    static HWZendesk * manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[HWZendesk alloc] init];
        
    });
    return manager;
}


- (instancetype) init {
    
    self = [super init];
    if(self) {
        
        [[ZDKConfig instance] initializeWithAppId: ZENDESK_APPID
                                       zendeskUrl: ZENDESK_URL
                                         ClientId: ZENDESK_CLIENT_ID
                                        onSuccess:^() {
                                          
                                            [self jwtIdentify];
                                            NSLog(@"Yes");
                                            
                                        } onError:^(NSError *error) {
                                            
                                            NSLog(@"%@", error.description);
                                            
                                        }];

    }
    
    return self;
}



BOOL setStatusBarColor(UIColor *color)
{
    id statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    id statusBar = [statusBarWindow valueForKey:@"statusBar"];
    
    SEL setForegroundColor_sel = NSSelectorFromString(@"setForegroundColor:");
    if([statusBar respondsToSelector:setForegroundColor_sel]) {
        // iOS 7+
        [statusBar performSelector:setForegroundColor_sel withObject:color];
        return YES;
    } else {
        return NO;
    }
}


- (void) jwtIdentify {
    
    
   
    
    
    [[NetworkManager shared] jwtWithSuccess:^(NSString *jwt) {
        
          ZDKJwtIdentity * jwtUserIdentity = [[ZDKJwtIdentity alloc] initWithJwtUserIdentifier:jwt];
        
        
        [ZDKConfig instance].userIdentity = jwtUserIdentity;
        
    } failureBlock:^(NSError *error) {
        
    
    }];
    
    
 

    // [ZDKConfig instance].userIdentity = jwtUserIdentity;
    
//    ZDKAnonymousIdentity *identity = [ZDKAnonymousIdentity new];
//    
//    identity.name = [AppEngine shared].user.username;
//    identity.email = [AppEngine shared].user.email;
//    identity.externalId = [AppEngine shared].user.id;
//    
//    
//   [ZDKConfig instance].userIdentity = identity;
}




-(void) setNavigationController:(UINavigationController *)navigationController {
    
    _navigationController = navigationController;
 
    UIFont *allFont= [UIFont fontWithName:@"OpenSans" size:17];
    UIColor *allColor = [UIColor whiteColor];
    
    NSDictionary *allAttrib = @{ NSForegroundColorAttributeName : allColor, NSFontAttributeName : allFont  };
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor color256RGBWithRed:48 green:173 blue:148]];
    [[UINavigationBar appearance] setTitleTextAttributes:allAttrib];
    
    
   // self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
setStatusBarColor([UIColor whiteColor]);
   
   
    
}

-(void) newTiket {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self jwtIdentify];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     [ZDKRequests showRequestCreationWithNavController:self.navigationController];
  //   setStatusBarColor([UIColor whiteColor]);
}

-(void) supportView {
    
    [[ZDKSupportView appearance] setSearchBarStyle:@(UIBarStyleDefault)];
 
    [ZDKHelpCenter showHelpCenterWithNavController:self.navigationController];
 
   setStatusBarColor([UIColor whiteColor]);
    
      }


-(void) refundPolicy {
    
    ZDKHelpCenterProvider  *provider = [[ZDKHelpCenterProvider alloc] init];

    [provider getArticleById:@"204470212" withCallback:^(NSArray *items, NSError *error) {
        
        ZDKHelpCenterArticle *article = items.lastObject;
        article.author_name = @"";
        
        ZDKArticleViewController* vc =[[ZDKArticleViewController alloc] initWithArticle:items.firstObject];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
}


-(void) privacyPolicy {
    
    ZDKHelpCenterProvider  *provider = [[ZDKHelpCenterProvider alloc] init];
    
    [provider getArticleById:@"204465182" withCallback:^(NSArray *items, NSError *error) {
        
        ZDKArticleViewController* vc =[[ZDKArticleViewController alloc] initWithArticle:items.firstObject];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
}

-(void) whyWeNeedThis{
       ZDKHelpCenterProvider  *provider = [[ZDKHelpCenterProvider alloc] init];
    
    [provider getArticleById:@"204424051" withCallback:^(NSArray *items, NSError *error) {
        
        ZDKArticleViewController* vc =[[ZDKArticleViewController alloc] initWithArticle:items.firstObject];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];

   

}


-(void)createTicketWithSubject:(NSString*)subject
               withDescription:(NSString*)descript {
    
    ZDKRequestProvider *provider = [ZDKRequestProvider new];
    ZDKCreateRequest *request = [[ZDKCreateRequest alloc] init];
    
    request.subject = subject;
    request.requestDescription = descript;
    
    
    
    [provider createRequest: request
               withCallback:^(id result, NSError *error) {
                   
                   
               }];
    
 
    
}

-(void)myTiket {
    
    [ZDKRequests showRequestListWithNavController:self.navigationController];
}

@end
