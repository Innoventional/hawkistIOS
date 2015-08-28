//
//  PingManager.h
//  Hawkist
//
//  Created by Anton on 28.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NotificationUpdateDelegate <NSObject>

- (void) countUpdated:(NSString*)count;

@end

@interface PingManager : NSObject

@property (nonatomic, strong) id <NotificationUpdateDelegate> notificationUpdateDelegate;

+ (instancetype) shared;


- (void) startUpdatingNotification;
- (void) stopUpdating;


@end
