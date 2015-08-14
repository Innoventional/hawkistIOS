//
//  HWPaymentBaseCell.m
//  Hawkist
//
//  Created by User on 13.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWPaymentBaseCell.h"

@interface HWPaymentBaseCell ()

@end

@implementation HWPaymentBaseCell

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if(isSelected)
    {
        
        self.layer.borderWidth = 3;
        self.activeImage.image = [UIImage imageNamed:@"acdet_check"];
    }
    else
    {
        self.activeImage.image = [UIImage imageNamed:@"acdet_checkempty"];
        self.layer.borderWidth = 0;
    }
}


- (instancetype) awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    if (self)
    {
        self.layer.cornerRadius = 6;
        self.layer.borderColor = [UIColor colorWithRed:55./255. green:185./255. blue:165./255. alpha:1].CGColor;
        self.activeImage.image = [UIImage imageNamed:@"acdet_checkempty"];
    }
    return self;
}




@end
