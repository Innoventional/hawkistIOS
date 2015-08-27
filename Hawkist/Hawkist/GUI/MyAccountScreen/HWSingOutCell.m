//
//  HWSingOutCell.m
//  Hawkist
//
//  Created by User on 01.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWSingOutCell.h"

@interface HWSingOutCell ()

//@property (weak, nonatomic) IBOutlet UIButton *notifySellerButton;
//@property (weak, nonatomic) IBOutlet UIButton *letMembersButton;


@end
@implementation HWSingOutCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark Actions


- (IBAction)notifySellerAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressNotifySellerButton:)])
    {
        [self.delegate pressNotifySellerButton:sender];
    }
}


- (IBAction)letMembersAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressLetMemberButton:)])
    {
        [self.delegate pressLetMemberButton:sender];
    }
}

- (IBAction)singlOutAction:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pressSingOutButton:)])
    {
        [self.delegate pressSingOutButton:sender];
    }
    
}

@end
