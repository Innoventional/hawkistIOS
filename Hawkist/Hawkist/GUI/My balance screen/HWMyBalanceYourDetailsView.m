//
//  HWMyBalanceYourDetailsView.m
//  Hawkist
//
//  Created by User on 24.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWMyBalanceYourDetailsView.h"

@implementation HWMyBalanceYourDetailsView


- (void) setUserDetailsWith:(HWBankUserInfo*)userInfo {
    
    [self.firstName setText:userInfo.first_name];
    [self.lastName setText:userInfo.last_name];
    [self.birthday setText:@"Not date"];
    
}


- (IBAction)saveEditAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveEditDetailsWithButton:)]) {
        
        [self.delegate saveEditDetailsWithButton:sender];
    }
}
@end
