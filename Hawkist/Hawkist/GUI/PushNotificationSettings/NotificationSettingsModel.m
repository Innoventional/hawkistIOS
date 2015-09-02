//
//  NotificationSettingsModel.m
//  Hawkist
//
//  Created by Anton on 02.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "NotificationSettingsModel.h"

@implementation NotificationSettingsModel


- (instancetype) initWithImageName:(NSString*)imageName withTitle:(NSString*)title withStatus:(BOOL)enabled withType:(int)type;
{
    self = [super init];
    
    if (self)
    {
        self.title = title;
        self.image = [UIImage imageNamed:imageName];
        self.enabled = enabled;
        self.type = type;
    }
    
    return self;
}

@end
