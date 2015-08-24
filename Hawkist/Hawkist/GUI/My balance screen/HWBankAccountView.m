//
//  HWBankAccountView.m
//  Hawkist
//
//  Created by User on 24.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWBankAccountView.h"

@implementation HWBankAccountView


- (void) setBankAccount:(HWBankAccountInfo*)bankAccount {
    
    [self.firstName setText:bankAccount.holder_first_name];
    [self.lastName setText:bankAccount.holder_last_name];
    [self.accountNumber setText:bankAccount.number];
    [self.sortCode setText:bankAccount.sort_code];
}


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
