//
//  HWPushNotificationSettings.h
//  Hawkist
//
//  Created by Anton on 02.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWPushNotificationSettings : JSONModel

@property (nonatomic, assign)BOOL enable;
@property (strong, nonatomic)NSDictionary* types;

@end
