//
//  HWAddDataModel.m
//  Hawkist
//
//  Created by User on 04.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWAddDataModel.h"

@implementation HWAddDataModel


- (instancetype) initWithTitle:(NSString*)title
                   description:(NSString*)description
                titleForButton:(NSString*)titleButton
{
    self =  [super init] ;
    if (self)
    {
        self.titleStr = title;
        self.descriptionStr = description;
        self.titleForButtonStr = titleButton;
    }
    return self;
}

@end
