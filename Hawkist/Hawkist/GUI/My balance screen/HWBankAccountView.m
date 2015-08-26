//
//  HWBankAccountView.m
//  Hawkist
//
//  Created by User on 24.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWBankAccountView.h"
#import "UIColor+Extensions.h"

@interface HWBankAccountView ()

@property (nonatomic, assign) BOOL isEditMode;

@end


@implementation HWBankAccountView

#pragma mark - set/get

-(void)setIsEdit:(BOOL)isEdit {
    
    _isEdit = isEdit;
    self.isEditMode = isEdit;
    
    if(isEdit) {
        
        [self.saveEditBankAccButton setTitle:@"SAVE BANK ACCOUNT" forState:UIControlStateNormal];
        [self.saveEditBankAccButton setBackgroundColor:[UIColor color256RGBWithRed:48 green:173 blue:148]];

    } else {
        
        [self.saveEditBankAccButton setTitle:@"EDIT DETAILS" forState:UIControlStateNormal];
        [self.saveEditBankAccButton setBackgroundColor:[UIColor color256RGBWithRed:78 green:78 blue:78]];
    }
    
}

-(void) setIsEditMode:(BOOL)isEditMode {
    
    _isEditMode = isEditMode;
     self.firstName.enabled = isEditMode;
     self.lastName.enabled = isEditMode;
     self.accountNumber.enabled = isEditMode;
     self.sortCode.enabled = isEditMode;
}

- (void) setBankAccount:(HWBankAccountInfo*)bankAccount {
    
    [self.firstName setText:bankAccount.first_name];
    [self.lastName setText:bankAccount.last_name];
    [self.accountNumber setText:bankAccount.number];
    [self.sortCode setText:bankAccount.sort_code];
}

- (HWBankAccountInfo*) getBankAccount {
    
    HWBankAccountInfo *bankAcc = [[HWBankAccountInfo alloc]init];
    
    bankAcc.first_name = self.firstName.text;
    bankAcc.last_name = self.lastName.text;
    bankAcc.number = self.accountNumber.text;
    bankAcc.sort_code = self.sortCode.text ;
    
    
    return bankAcc;
}


-(BOOL)isFullAllTextFieldWithBankAcc:(HWBankAccountInfo*)bankAcc {
    
    BOOL isNill = (bankAcc.last_name && bankAcc.last_name && bankAcc.number && bankAcc.sort_code);
    BOOL isEmpty = (!([bankAcc.last_name isEqualToString:@""] &&
                    [bankAcc.number isEqualToString:@""] &&
                    [bankAcc.sort_code isEqualToString:@""]));
    
    
    return (isNill && isEmpty);
}



#pragma mark - Action

- (IBAction)saveEditBankAccAction:(id)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(saveEditBankAccountWithButton:)]) {
        
        [self.delegate saveEditBankAccountWithButton:sender];
    }
}

- (IBAction)whyWeNeedThisAction:(id)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(whyWeNeedThisButton:)]) {
        
        [self.delegate whyWeNeedThisButton:sender];
    }
}
@end
