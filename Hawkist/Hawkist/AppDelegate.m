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

@interface AppDelegate ()
@property (nonatomic,strong) LoginViewController* viewController;
//@property (nonatomic,strong) AccountDetailViewController* viewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    NetworkManager* manager = [NetworkManager shared];
    AppEngine* engine = [AppEngine shared];
    
  [manager getListOfTags:^(NSMutableArray *tags) {
        
      engine.tags = tags;
      
    } failureBlock:^(NSError *error) {
        NSLog(@"----------Can't get Tags -------");
        
    }];
    
    
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.rootViewController = [[UINavigationController alloc] init];
    
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
