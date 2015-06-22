//
//  AppEngine.h
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/17/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppEngine : NSObject
@property (nonatomic,strong) HWUser* user;
+ (instancetype) shared;

// Returns YES if application is launching first time
+ (BOOL) isFirsTimeLaunch;

@end
