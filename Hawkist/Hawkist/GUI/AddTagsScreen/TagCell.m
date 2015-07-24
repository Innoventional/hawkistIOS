//
//  TagCell.m
//  Hawkist
//
//  Created by Anton on 23.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "TagCell.h"

@implementation TagCell

- (instancetype) init
{
    if (self = [super init])
    {
        UIView* sub = [[[NSBundle mainBundle]loadNibNamed:@"TagCell" owner:self options:nil]firstObject];
        
        sub.frame = self.bounds;
        
        [self addSubview:sub];
        
    }
    return self;
}


@end
