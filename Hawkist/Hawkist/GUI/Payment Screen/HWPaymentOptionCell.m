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


 
@property (nonatomic, strong) HWCard *card;

@end

@implementation HWPaymentOptionCell


- (void) setCellWithCard:(HWCard*)card
{
    self.card = card;
    self.fullNameLabel.text = card.name;
    self.numberCardLabel.text = [NSString stringWithFormat:@"●●●● ●●●● ●●●● %@",card.last4];
    self.expirationDateLabel.text = [NSString stringWithFormat:@"%@ / %@",card.exp_month, card.exp_year];
    
}


@end
