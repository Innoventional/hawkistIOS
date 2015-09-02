//
//  NotificationSettingsModel.h
//  Hawkist
//
//  Created by Anton on 02.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationSettingsModel : NSObject

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *title;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) int type;

- (instancetype) initWithImageName:(NSString*)imageName withTitle:(NSString*)title withStatus:(BOOL)enabled withType:(int)type;

@end
