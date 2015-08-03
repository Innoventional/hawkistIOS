//
//  CustomField.m
//  Hawkist
//
//  Created by Anton on 03.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "CustomField.h"

@implementation CustomField

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView* sub = [[[NSBundle mainBundle]loadNibNamed:@"CustomField" owner:self options:nil]firstObject];
        
        sub.frame = self.bounds;
        
        [self addSubview:sub];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
