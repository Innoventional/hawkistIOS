//
//  HWMyBalanceBankAccAddressView.m
//  Hawkist
//
//  Created by User on 24.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWMyBalanceBankAccAddressView.h"

@implementation HWMyBalanceBankAccAddressView


- (void) setBankAccountAddress:(HWBankAccountAddress*)bankAccAddress {
    
    [self.addressLine1 setText:bankAccAddress.address_line1];
    [self.addressLine2 setText:bankAccAddress.address_line2];
    [self.city setText:bankAccAddress.city];
    [self.postCode setText:bankAccAddress.post_code];
}


- (IBAction)saveEditBankAccountAddressAction:(id)sender {
    
    if(self.delegete && [self.delegete respondsToSelector:@selector(saveEditBankAccAddressWithButton:)]) {
        
        [self.delegete saveEditBankAccAddressWithButton:sender];
    }
}

- (IBAction)sameAsBillingAction:(id)sender {
    
    if(self.delegete && [self.delegete respondsToSelector:@selector(sameAsBillingWithButton:)]) {
        
        [self.delegete sameAsBillingWithButton:sender];
    }
}
@end
