//
//  HWMyBalanceBankAccAddressView.m
//  Hawkist
//
//  Created by User on 24.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWMyBalanceBankAccAddressView.h"
#import "UIColor+Extensions.h"


@interface HWMyBalanceBankAccAddressView ()

@property (nonatomic, assign) BOOL isEditMode;

@end

@implementation HWMyBalanceBankAccAddressView


#pragma mark - set / get 

-(void)setIsEdit:(BOOL)isEdit {
    
    _isEdit = isEdit;
    self.isEditMode = isEdit;
    
    if(isEdit) {
        
        [self.saveEditAccountAddressButton setTitle:@"SAVE BANK ACCOUNT ADDRESS" forState:UIControlStateNormal];
        [self.saveEditAccountAddressButton setBackgroundColor:[UIColor color256RGBWithRed:48 green:173 blue:148]];
    } else {
        
        [self.saveEditAccountAddressButton setTitle:@"EDIT BANK ACCOUNT ADDRESS" forState:UIControlStateNormal];
        [self.saveEditAccountAddressButton setBackgroundColor:[UIColor color256RGBWithRed:78 green:78 blue:78]];
        
    }
    
}

-(void) setIsEditMode:(BOOL)isEditMode {
    
    _isEditMode = isEditMode;
    self.addressLine1.enabled = isEditMode;
    self.addressLine2.enabled = isEditMode;
    self.city.enabled = isEditMode;
    self.postCode.enabled = isEditMode;
    
}

- (void) setBankAccountAddress:(HWBankAccountAddress*)bankAccAddress {
    
    [self.addressLine1 setText:bankAccAddress.address_line1];
    [self.addressLine2 setText:bankAccAddress.address_line2];
    [self.city setText:bankAccAddress.city];
    [self.postCode setText:bankAccAddress.post_code];
}

- (HWBankAccountAddress*) getBankAccountAddress {
    
    HWBankAccountAddress *bankAddress = [[HWBankAccountAddress alloc] init];
    bankAddress.address_line1 = self.addressLine1.text;
    bankAddress.address_line2 = self.addressLine2.text;
    bankAddress.city = self.city.text;
    bankAddress.post_code = self.postCode.text;
    
    return bankAddress;
}


-(BOOL)isFullAllTextFieldWithYourDetails:(HWBankAccountAddress*) accAddress{
    
    BOOL isNill = (accAddress.address_line1 && accAddress.city && accAddress.post_code);
    BOOL isEmpty = (!([accAddress.address_line1 isEqualToString:@""] &&
                    [accAddress.city isEqualToString:@""] &&
                    [accAddress.post_code isEqualToString:@""]
                    
                    ));
    
    return (isNill && isEmpty);
}


#pragma mark - action

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
