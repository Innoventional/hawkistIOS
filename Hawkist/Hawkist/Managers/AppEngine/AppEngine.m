//
//  AppEngine.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/17/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "AppEngine.h"

@implementation AppEngine

#pragma mark -
#pragma mark Lifecycle
//@synthesize user;
+ (instancetype) shared
{
    static AppEngine* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedInstance = [[AppEngine alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

#pragma mark -
#pragma mark Public

+ (BOOL) isFirsTimeLaunch
{
    BOOL isFirstTime = ![[[NSUserDefaults standardUserDefaults] objectForKey: @"isFirstTime"] boolValue];
    if(isFirstTime)
        [[NSUserDefaults standardUserDefaults] setObject: @(YES) forKey: @"isFirstTime"];
    return isFirstTime;
}

#pragma mark -
#pragma mark Setters/Getters

- (void) setPin: (NSString*) pin
{
     [[NSUserDefaults standardUserDefaults] setObject: pin forKey: @"pin"];
}

- (NSString*) pin
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"pin"];
}

- (void) setNumber: (NSString*) number
{
    [[NSUserDefaults standardUserDefaults] setObject: number forKey: @"number"];

}


- (NSString*) number
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"number"];

}

- (void) setTags:(NSMutableArray *)tags
{
    _tags = tags;
}


- (void) setCity:(NSString *)city
{
    [[NSUserDefaults standardUserDefaults] setObject: city forKey: @"city"];
    
}


- (NSString*) city
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"city"];
    
}

- (void) setPostCode:(NSString *)postCode
{
    [[NSUserDefaults standardUserDefaults] setObject: postCode forKey: @"postCode"];
    
}


- (NSString*) postCode
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"postCode"];
    
}


- (void) setLogginedWithFB:(BOOL)logginedWithFB
{
    if (logginedWithFB)
        
        [[NSUserDefaults standardUserDefaults] setObject: @"YES" forKey: @"loginFB"];
    else
        [[NSUserDefaults standardUserDefaults] setObject: @"NO" forKey: @"loginFB"];
}

- (BOOL) logginedWithFB
{
    NSString* result = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey: @"loginFB"];
    
    if ([result isEqualToString:@"YES"])
        return YES;
    return NO;
}

- (void) setLogginedWithPhone:(BOOL)logginedWithPhone
{
    if (logginedWithPhone)
        
        [[NSUserDefaults standardUserDefaults] setObject: @"YES" forKey: @"loginPhone"];
    else
        [[NSUserDefaults standardUserDefaults] setObject: @"NO" forKey: @"loginPhone"];
}

- (BOOL) logginedWithPhone
{
    NSString* result = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey: @"loginPhone"];
    
    if ([result isEqualToString:@"YES"])
        return YES;
    return NO;
}
@end
