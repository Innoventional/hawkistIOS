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


 

- (void) jwtIdentify {
    
    
    [[NetworkManager shared] jwt];
    
//        ZDKJwtIdentity * jwtUserIdentity = [[ZDKJwtIdentity alloc] initWithJwtUserIdentifier:@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiQm9iX0thcmJvYiIsImFsZyI6IkhTMjU2IiwianRpIjo1MCwiaWF0IjoxNDQxNzIyODQ5LCJ0eXAiOiJKV1QiLCJlbWFpbCI6ImdpZ2VrQG1haWwucnUifQ.JAKi4qD1QCXl1V9jpyNppF5qRR32TYCb7_KNU-EDys8"];
//
//     [ZDKConfig instance].userIdentity = jwtUserIdentity;
    
    ZDKAnonymousIdentity *identity = [ZDKAnonymousIdentity new];
    
    identity.name = [AppEngine shared].user.username;
    identity.email = [AppEngine shared].user.email;
    identity.externalId = [AppEngine shared].user.id;

    
   [ZDKConfig instance].userIdentity = identity;
}




-(void) setNavigationController:(UINavigationController *)navigationController {
    
    _navigationController = navigationController;
 
    UIFont *allFont= [UIFont fontWithName:@"OpenSans" size:17];
    UIColor *allColor = [UIColor whiteColor];
    
    NSDictionary *allAttrib = @{ NSForegroundColorAttributeName : allColor, NSFontAttributeName : allFont  };
    //self.navigationController.navigationBar.titleTextAttributes = allAttrib;
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor color256RGBWithRed:48 green:173 blue:148]];
    [[UINavigationBar appearance] setTitleTextAttributes:allAttrib];
   
 
    
}

-(void) newTiket {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     [ZDKRequests showRequestCreationWithNavController:self.navigationController];
}

//-(void)setConfigTi{
//    
//    [ZDKRequests configure:^(ZDKAccount *account, ZDKRequestCreationConfig *requestCreationConfig) {
//        
//        // specify any additional tags desired
//        requestCreationConfig.tags = [NSArray arrayWithObjects:@"report", nil];
//        requestCreationConfig.subject = @"newwwwweeen";
//        // add some custom content to the description
//        requestCreationConfig.additionalRequestInfo = @"\n<-----SSS----->";
//        
//    }];
//    
//}



-(void) supportView {
 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
    [[ZDKSupportView appearance] setSearchBarStyle:@(UIBarStyleDefault)];
 
    
    
    
    [ZDKHelpCenter showHelpCenterWithNavController:self.navigationController];
  }

-(void) myTiket {
//    [ZDKRequests showRequestCreationWithNavController:self.navigationController];
//     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
         [ZDKRequests showRequestListWithNavController:self.navigationController];
    

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

@end
