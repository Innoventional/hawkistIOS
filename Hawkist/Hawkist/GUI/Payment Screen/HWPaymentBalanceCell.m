//
//  HWPaymentNewCardCellTableViewCell.m
//  Hawkist
//
//  Created by User on 13.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWPaymentBalanceCell.h"


@interface HWPaymentBalanceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *activeImage;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;


@end

@implementation HWPaymentBalanceCell 




-(void) setCellWithBalance:(NSString*)balance{
    
    self.balanceLabel.text = [NSString stringWithFormat:@"£%@", balance];
}




@end
