//
//  HWMyBalanceBankAccAddressView.h
//  Hawkist
//
//  Created by User on 24.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWBankAccountAddress.h"

@protocol HWMyBalanceBankAccAddressViewDelegate;

@interface HWMyBalanceBankAccAddressView : UIView

@property (nonatomic, weak) IBOutlet UITextField *addressLine1;
@property (nonatomic, weak) IBOutlet UITextField *addressLine2;
@property (nonatomic, weak) IBOutlet UITextField *city;
@property (nonatomic, weak) IBOutlet UITextField *postCode;
@property (nonatomic, weak) IBOutlet UIButton *saveEditAccountAddressButton;

@property (nonatomic, weak) id <HWMyBalanceBankAccAddressViewDelegate> delegete;

@property (nonatomic, weak) IBOutlet UIButton *sameAsBillingButton;
@property (nonatomic, assign) BOOL sameAsBilling;

- (void) setBankAccountAddress:(HWBankAccountAddress*)bankAccAddress;

@end


@protocol HWMyBalanceBankAccAddressViewDelegate <NSObject>

- (void) saveEditBankAccAddressWithButton:(UIButton*) sender;
- (void) sameAsBillingWithButton:(UIButton*) sender;

@end