//
//  PushNotificationManager.h
//  Hawkist
//
//  Created by Anton on 03.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushNotificationManager : NSObject
+ (instancetype) shared;

- (void) handleNotification:(NSDictionary *)userInfo andNavigationController:(UINavigationController*)navigationController;

@end
