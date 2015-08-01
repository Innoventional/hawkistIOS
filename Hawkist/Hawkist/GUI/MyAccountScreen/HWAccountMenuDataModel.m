//
//  HWAccountMenuDataModel.m
//  Hawkist
//
//  Created by User on 01.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWAccountMenuDataModel.h"

@implementation HWAccountMenuDataModel


- (instancetype) initWithImageName:(NSString*)imageName withTitle:(NSString*)title
{
    self = [super init];
    
    if (self)
    {
        self.title = title;
        self.image = [UIImage imageNamed:imageName];
    }
    
    return self;
}

@end
