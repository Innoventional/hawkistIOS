//
//  HWMyBalanceViewController.m
//  Hawkist
//
//  Created by User on 19.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWMyBalanceViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "NavigationVIew.h"

#import "HWMyBalanceCurrentBalanceView.h"
#import "HWMyBalanceYourDetailsView.h"
#import "HWBankAccountView.h"
#import "HWMyBalanceBankAccAddressView.h"
#import "NetworkManager.h"
#import "HWBankUserInfo.h"
#import "HWBankAccountInfo.h"
#import "HWBankAccountAddress.h"
#import "CDatePickerViewEx.h"
#import "UIColor+Extensions.h"



@interface HWMyBalanceViewController () <HWMyBalanceYourDetailsViewDelegate,HWMyBalanceBankAccAddressViewDelegate,HWBankAccountViewDelegate, NavigationViewDelegate,CDatePickerViewExDelegate>

@property (nonatomic, weak) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *checkMyBalanceButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningMessageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentConstreint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withwardButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkMyButtonConstraint;


@property (weak, nonatomic) IBOutlet HWMyBalanceCurrentBalanceView *balanceView;
@property (weak, nonatomic) IBOutlet HWMyBalanceYourDetailsView *yourDetailsView;
@property (weak, nonatomic) IBOutlet HWBankAccountView *bankAccountView;
@property (weak, nonatomic) IBOutlet HWMyBalanceBankAccAddressView *bankAccAddressView;
@property (nonatomic, weak) IBOutlet NavigationVIew *navView;

@property (nonatomic,strong) UIDatePicker* datePicker;
@property (nonatomic, strong) NetworkManager *networkManager;


@property (nonatomic, strong) HWBankUserInfo *yourDetails;
@property (nonatomic, strong) HWBankAccountInfo *accountInfo;
@property (nonatomic, strong) HWBankAccountAddress *accountAddress;

@property (nonatomic, assign) CGFloat heightWithward;

 

@end

@implementation HWMyBalanceViewController


#pragma mark - UIViewController


- (instancetype)init
{
    self = [super initWithNibName: @"HWMyBalanceView" bundle: nil];
    if(self)
    {
       
    }
    return self;
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adjustKeyboardFrame:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.heightWithward = self.withwardButtonConstraint.constant;
    self.withwardButtonConstraint.constant = 0;
    self.contentConstreint.constant -= self.heightWithward;
    
    self.networkManager = [NetworkManager shared];
    self.yourDetailsView.delegate = self;
    self.bankAccAddressView.delegete = self;
    self.bankAccountView.delegate = self;
    self.navView.delegate = self;
    
    [self setBalance];
    [self setYourDetailsForVerify:YES];
    [self setupDatePickerForB_Day];
    
}

- (void) setupDatePickerForB_Day {
    
    
    self.datePicker = [[UIDatePicker alloc]init];

    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setBackgroundColor:[UIColor color256RGBWithRed: 55  green: 184 blue: 164]];
    
    
    
    self.yourDetailsView.birthday.inputView = self.datePicker;
    
    [self.datePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(hideKeyboard)];
    
    
    UIButton* customButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"signBut"] forState:UIControlStateNormal];
    [customButton setTitle:@"Done" forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchDown];
    doneButton.customView = customButton;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           doneButton,
                           nil];
    [numberToolbar sizeToFit];
    self.yourDetailsView.birthday.inputAccessoryView = numberToolbar;
}



- (void) doneButtonClicked {
    
    [self.yourDetailsView.birthday resignFirstResponder];
    if([[NSDate date] timeIntervalSinceDate:self.datePicker.date] < 100000.f) {
    
        return;
    };
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:self.datePicker.date];
    self.yourDetailsView.birthday.text = stringFromDate;
    self.yourDetailsView.date = self.datePicker.date;

}

- (void) hideKeyboard
{
    
}

- (void) adjustKeyboardFrame: (NSNotification*) notification
{
    if ([self.yourDetailsView.birthday isFirstResponder] && [self.yourDetailsView.birthday.text isEqualToString:@""])
    {
       // [self didSelect];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    
    NSLog(@"%f", self.withwardButtonConstraint.constant);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
#pragma mark - Action

- (IBAction)withDrawMyBalanceAction:(id)sender {
    
    NSLog(@"withDrawMyBalanceAction");
}

- (IBAction)checkMyBalanceAction:(id)sender {
    
    NSLog(@"checkMyBalanceAction");
}

- (IBAction)rrr:(id)sender {
    
    
    self.contentConstreint.constant -= self.warningMessageConstraint.constant;
    self.warningMessageConstraint.constant = 0;
    
}

#pragma mark - NavigationViewDelegate 

-(void) leftButtonClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) rightButtonClick {
    
}

#pragma mark - HWMyBalanceYourDetailsViewDelegate

- (void) saveEditDetailsWithButton:(UIButton*)sender {
    
    if( self.yourDetailsView.isEdit ) {
     
        [self updateYourDetails:[self.yourDetailsView getUserDetails]];
    }else{
        
        self.yourDetailsView.isEdit = YES;
        
    }
    
    
    NSLog(@"saveEditDetailsWithButton");
}

#pragma mark - HWMyBalanceBankAccAddressViewDelegate

- (void) saveEditBankAccAddressWithButton:(UIButton*) sender {
    
    if( self.bankAccAddressView.isEdit ) {
        
       [self updateBankAccountAddress:[self.bankAccAddressView getBankAccountAddress]];
    }else{
        
        self.bankAccAddressView.isEdit = YES;
    }
    
    
     NSLog(@"saveEditBankAccAddressWithButton");
}

- (void) sameAsBillingWithButton:(UIButton*) sender {
    
     NSLog(@"sameAsBillingWithButton");
}

#pragma mark - HWBankAccountViewDelegate

- (void) saveEditBankAccountWithButton:(UIButton*)sender {
    
    if( self.bankAccountView.isEdit ) {
        
        [self updateBankAccount:[self.bankAccountView getBankAccount]];
    }else{
        
        self.bankAccountView.isEdit = YES;
    }
    
    
     NSLog(@"saveEditBankAccountWithButton");
}

- (void) whyWeNeedThisButton:(UIButton*) sender {
    
}


#pragma mark - network methods

- (void)setBalance {
    
[self.networkManager getUserBalanceWithSuccessBlock:^(NSString *available, NSString *pending) {
    
    self.balanceView.pendingSales.text = pending;
    self.balanceView.currentBalance.text = available;
    
                                     } failureBlock:^(NSError *error) {
    
                                         [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                     }];

}

// your details view
- (void)setYourDetailsForVerify:(BOOL) isVerify {
    
    [self.networkManager getBankUserInfoWithSuccessBlock:^(HWBankUserInfo *userInfo) {
        
        self.yourDetails = userInfo;
        [self.yourDetailsView setUserDetailsWith:userInfo];
        self.yourDetailsView.isEdit = (![self.yourDetailsView isFullAllTextFieldWithYourDetails:userInfo]);
        
        if(isVerify) {
            
            [self setBankAccountForVerify:isVerify];
        }
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
    }];
}

-(void)updateYourDetails:(HWBankUserInfo*) userInfo {
    
    [self.networkManager updateBankUserInfo:userInfo
                               successBlock:^{
                                   
                                   self.yourDetailsView.isEdit = NO;
                                  
                               } failureBlock:^(NSError *error) {
                                   
         [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                               }];
}


//bank account

- (void) setBankAccountForVerify:(BOOL) isVerify {
    
    [self.networkManager getBankAccountInfoWithSuccessBlock:^(HWBankAccountInfo *accInfo) {
        
        self.accountInfo = accInfo;
        [self.bankAccountView setBankAccount:accInfo];
        self.bankAccountView.isEdit = (![self.bankAccountView isFullAllTextFieldWithBankAcc:accInfo]);
        
        
        if(isVerify) {
            
            [self setBankAccountAddressForVerify:isVerify];
        }
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
    }];
}

- (void) updateBankAccount:(HWBankAccountInfo*)bankAcc {
    
    [self.networkManager updateBankAccountInfo:bankAcc
                                  successBlock:^{
                                      
                                      self.bankAccountView.isEdit = NO;
                                      
                                  } failureBlock:^(NSError *error) {
                                      
        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                  }];
}

// bank account address

- (void) setBankAccountAddressForVerify:(BOOL) isVerify {
    
    [self.networkManager getBankAccountAddressWithSuccessBlock:^(HWBankAccountAddress *bankaddress) {
        
        self.accountAddress = bankaddress;
        [self.bankAccAddressView setBankAccountAddress:bankaddress];
        self.bankAccAddressView.isEdit = (![self.bankAccAddressView isFullAllTextFieldWithYourDetails:bankaddress]);
        
        if(isVerify) {
            
            if(!(self.yourDetailsView.isEdit && self.bankAccountView.isEdit && self.bankAccAddressView.isEdit)) {
                
                [self hideCheckMyBalance];
            }
            
        }
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
    }];
}

- (void) updateBankAccountAddress:(HWBankAccountAddress *)bankAddress {
    
    [self.networkManager updateBankAccountAddress: bankAddress
                                     successBlock:^{
                                         
                                         self.bankAccAddressView.isEdit = NO;
                                         
                                     } failureBlock:^(NSError *error) {
                                         
        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                     }];
}


- (void) hideCheckMyBalance {
    
    self.contentConstreint.constant -= self.warningMessageConstraint.constant;
    self.warningMessageConstraint.constant = 0;
    
    self.contentConstreint.constant -= self.checkMyButtonConstraint.constant;
    self.checkMyButtonConstraint.constant = 0;
    self.checkMyBalanceButton.hidden = YES;
    
    
    self.withwardButtonConstraint.constant = self.heightWithward;
    self.contentConstreint.constant += self.heightWithward;
    
}


@end
