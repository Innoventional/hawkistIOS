//
//  AppDelegate.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/15/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AccountDetailViewController.h"
#import "WantToSellViewController.h"
#import "AppEngine.h"
#import "NetworkManager.h"
#import "Heap.h"
#import "ViewItemViewController.h"
#import "FeedScreenViewController.h"
#import "PingManager.h"

#import "PushNotificationManager.h"
#import "HWPaymentViewController.h"
#import <ZendeskSDK/ZendeskSDK.h>
#import <Leanplum/Leanplum.h>

#import <Braintree/Braintree.h>
#import "HWBraintreeManager.h"



#import "const.h"

@interface AppDelegate ()
@property (nonatomic,strong) LoginViewController* viewController;
//@property (nonatomic,strong) AccountDetailViewController* viewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
     
    
//    [[HWBraintreeManager shared] createTokenFromCardNumber:@"4242 4242 4242 4242"
//                                                  expMonth:3
//                                                   expYear:16
//                                                       cvv:@"222"
//                                              addressLine1:@"dd"
//                                              addressLine2:nil
//                                                      name:nil
//                                                  postCode:@"121"
//                                                      city:@"DD"
//                                                completion:^(NSString *tokenId, NSError *error) {
//                                                    
//                                                    
//                                                                                }];
    
    ///LeanPlum////

    [Leanplum setAppId:LeanPlum_APP_ID withDevelopmentKey:LeanPlum_DevKey];
    
    
    [Leanplum start];
    
    
    
    /////LeanPlum////
    
    
    //[ZDKDispatcher setDebugLogging:YES];
    
    [ZDKLogger enable:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
   
//   [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//
//
//    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];

    
    
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.rootViewController = [[UINavigationController alloc] init];
    
 //[self.rootViewController pushViewController:[[HWPaymentViewController alloc] init]  animated: NO];
    
    
    [self.rootViewController pushViewController:[[LoginViewController alloc] init]  animated: NO];
    
    
   // [self.rootViewController pushViewController:[HWBrainTreeViewController new] animated:NO];
    
   //   [self.rootViewController pushViewController:[[WantToSellViewController alloc] init]  animated: NO];
    self.rootViewController.navigationBarHidden = YES;
        self.window.rootViewController = self.rootViewController;
    
        [self.window makeKeyAndVisible];

    
    [Heap setAppId: @"870570362"];
    
#ifdef DEBUG
    [Heap enableVisualizer];
#endif
    
    //UpdateBagde
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
    
}

 

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  {
    NSLog(@"My token is: %@", deviceToken);
    
    NSString *deviceToken2 = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    deviceToken2 = [deviceToken2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [AppEngine shared].APNStoken = deviceToken2;
    

        [[NetworkManager shared] sendAPNSToken:deviceToken2 successBlock:^{
            
            
        } failureBlock:^(NSError *error) {
            
            
        }];

}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [Braintree handleOpenURL:url sourceApplication:sourceApplication];
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [AppEngine shared].APNStoken = @"";
    NSLog(@"Failed to get token, error: %@", error);
}


- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Received notification: %@", userInfo);
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  ){
        [[PushNotificationManager shared] handleNotification:userInfo andNavigationController:[self rootViewController]];
    
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[PingManager shared]stopUpdating];
     [self.window endEditing:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([PingManager shared].isRunned)
    [[PingManager shared]startUpdatingNotification];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
