//
//  HWBankAccountView.h
//  Hawkist
//
//  Created by User on 24.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWBankAccountInfo.h"

@protocol HWBankAccountViewDelegate;

@interface HWBankAccountView : UIView

@property (nonatomic, weak) IBOutlet UITextField *firstName;
@property (nonatomic, weak) IBOutlet UITextField *lastName;
@property (nonatomic, weak) IBOutlet UITextField *accountNumber;
@property (nonatomic, weak) IBOutlet UITextField *sortCode;

@property (nonatomic, weak) IBOutlet UIButton *saveEditBankAccButton;
@property (nonatomic, weak) IBOutlet UIButton *whyWeNeedThisButton;

@property (nonatomic, weak) id <HWBankAccountViewDelegate> delegate;

@property (nonatomic, assign) BOOL isEdit;

- (void) setBankAccount:(HWBankAccountInfo*)bankAccount;
- (HWBankAccountInfo*) getBankAccount;

-(BOOL)isFullAllTextFieldWithBankAcc:(HWBankAccountInfo*)bankAcc;

@end


@protocol HWBankAccountViewDelegate <NSObject>

- (void) saveEditBankAccountWithButton:(UIButton*)sender;
- (void) whyWeNeedThisButton:(UIButton*) sender;

@end