//
//  HWPaymentOptionCell.m
//  Hawkist
//
//  Created by User on 02.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWPaymentOptionCell.h"

@interface HWPaymentOptionCell ()

@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activeImage;

 
@property (nonatomic, strong) HWCard *card;

@end

@implementation HWPaymentOptionCell

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
- (void) setCellWithCard:(HWCard*)card
{
    self.card = card;
    self.fullNameLabel.text = card.name;
    self.numberCardLabel.text = [NSString stringWithFormat:@"**** **** **** %@",card.last4];
    self.expirationDateLabel.text = [NSString stringWithFormat:@"%@ / %@",card.exp_month, card.exp_year];
    
}

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

@end
