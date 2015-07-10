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
@property (nonatomic, strong) NSString* pin;
@property (nonatomic,strong) NSMutableArray* tags;

+ (instancetype) shared;

// Returns YES if application is launching first time
+ (BOOL) isFirsTimeLaunch;

- (void) setPin: (NSString*) pin;

- (NSString*) pin;

- (void) setNumber: (NSString*) number;

- (NSString*) number;

- (NSString*) categoryNameById: (NSInteger) id;

@end
