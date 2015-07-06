//
//  ChoiceCellView.m
//  Hawkist
//
//  Created by Anton on 06.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "ChoiceCellView.h"

@implementation ChoiceCellView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView* sub = [[[NSBundle mainBundle]loadNibNamed:@"ChoiceCell" owner:self options:nil]firstObject];
        
        sub.frame = self.bounds;
        
        [self addSubview:sub];
        
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{

    if (self= [super initWithFrame:frame])
    {
        UIView* sub = [[[NSBundle mainBundle]loadNibNamed:@"ChoiceCell" owner:self options:nil]firstObject];
        
        sub.frame = self.bounds;
        
        [self addSubview:sub];

    }
    return self;
}

@end
