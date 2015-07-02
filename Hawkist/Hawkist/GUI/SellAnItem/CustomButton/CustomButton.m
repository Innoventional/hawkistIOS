//
//  CustomButton.m
//  Hawkist
//
//  Created by Anton on 01.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton


- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
//        UIView* sub = [[[NSBundle mainBundle]loadNibNamed:@"Custom" owner:self options:nil]firstObject];
//        
//        sub.frame = self.frame;
//        
//        [self addSubview:sub];

    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView* sub = [[[NSBundle mainBundle]loadNibNamed:@"Custom" owner:self options:nil]firstObject];
        
        sub.frame = self.bounds;
        
        [self addSubview:sub];
    }
    return self;
}

- (IBAction)tapAction:(id)sender {
    NSLog(@"Tap");
}
@end
