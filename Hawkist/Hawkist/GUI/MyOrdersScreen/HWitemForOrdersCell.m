//
//  HWitemForOrdersCell.m
//  Hawkist
//
//  Created by User on 06.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWitemForOrdersCell.h"

@interface HWitemForOrdersCell ()

@property (weak, nonatomic) IBOutlet UIButton *receivedButton;
@property (weak, nonatomic) IBOutlet UIButton *hasIssueButton;



@end

@implementation HWitemForOrdersCell

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Actions

- (IBAction)receivedAction:(UIButton *)sender
{
    if (self.orderCellDelegate && [self.orderCellDelegate respondsToSelector:@selector(receivedAction:withItem:)])
    {
        [self.orderCellDelegate receivedAction:sender withItem:self.item];
    }
    
}


- (IBAction)hasIssueAction:(UIButton *)sender
{
    
    if (self.orderCellDelegate && [self.orderCellDelegate respondsToSelector:@selector(hasIssueAction:withItem:)])
    {
        [self.orderCellDelegate hasIssueAction:sender withItem:self.item];
    }
    
    
}


@end
