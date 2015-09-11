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

@interface AppDelegate ()
@property (nonatomic,strong) LoginViewController* viewController;
//@property (nonatomic,strong) AccountDetailViewController* viewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    ///LeanPlum////

    [Leanplum setAppId:LeanPlum_APP_ID withDevelopmentKey:LeanPlum_DevKey];
    
    
    [Leanplum start];
    
    
    
    /////LeanPlum////
    
    
    [ZDKDispatcher setDebugLogging:YES];
    
    [ZDKLogger enable:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    
    
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.rootViewController = [[UINavigationController alloc] init];
 //[self.rootViewController pushViewController:[[HWPaymentViewController alloc] init]  animated: NO];
    [self.rootViewController pushViewController:[[LoginViewController alloc] init]  animated: NO];
   //   [self.rootViewController pushViewController:[[WantToSellViewController alloc] init]  animated: NO];
    self.rootViewController.navigationBarHidden = YES;
        self.window.rootViewController = self.rootViewController;
    
        [self.window makeKeyAndVisible];

    
    [Heap setAppId: @"870570362"];
    
#ifdef DEBUG
    [Heap enableVisualizer];
#endif
    
    return YES;
    
}

 

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  {
    NSLog(@"My token is: %@", deviceToken);
    
    NSString *deviceToken2 = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    deviceToken2 = [deviceToken2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [AppEngine shared].APNStoken = deviceToken2;
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
