//
//  MoneyField.m
//  Hawkist
//
//  Created by Anton on 02.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "MoneyField.h"

@implementation MoneyField

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView* sub = [[[NSBundle mainBundle]loadNibNamed:@"money" owner:self options:nil]firstObject];
        
        sub.frame = self.bounds;
        
        [self addSubview:sub];
    }
    return self;
}

@end
