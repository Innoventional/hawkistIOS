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


@interface HWMyBalanceViewController () <HWMyBalanceYourDetailsViewDelegate,HWMyBalanceBankAccAddressViewDelegate,HWBankAccountViewDelegate, NavigationViewDelegate>

@property (nonatomic, weak) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningMessageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentConstreint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withwardButtonConstraint;

@property (weak, nonatomic) IBOutlet HWMyBalanceCurrentBalanceView *balanceView;
@property (weak, nonatomic) IBOutlet HWMyBalanceYourDetailsView *yourDetailsView;
@property (weak, nonatomic) IBOutlet HWBankAccountView *bankAccountView;
@property (weak, nonatomic) IBOutlet HWMyBalanceBankAccAddressView *bankAccAddressView;
@property (nonatomic, weak) IBOutlet NavigationVIew *navView;

@property (nonatomic, strong) NetworkManager *networkManager;


@property (nonatomic, strong) HWBankUserInfo *yourDetails;
@property (nonatomic, strong) HWBankAccountInfo *accountInfo;
@property (nonatomic, strong) HWBankAccountAddress *accountAddress;

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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkManager = [NetworkManager shared];
    self.yourDetailsView.delegate = self;
    self.bankAccAddressView.delegete = self;
    self.bankAccountView.delegate = self;
    self.navView.delegate = self;
    
    [self setBalance];
    
    
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
    
    NSLog(@"saveEditDetailsWithButton");
}

#pragma mark - HWMyBalanceBankAccAddressViewDelegate

- (void) saveEditBankAccAddressWithButton:(UIButton*) sender {
    
     NSLog(@"saveEditBankAccAddressWithButton");
}

- (void) sameAsBillingWithButton:(UIButton*) sender {
    
     NSLog(@"sameAsBillingWithButton");
}

#pragma mark - HWBankAccountViewDelegate

- (void) saveEditBankAccountWithButton:(UIButton*)sender {
    
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
- (void)setYourDetails {
    
    [self.networkManager getBankUserInfoWithSuccessBlock:^(HWBankUserInfo *userInfo) {
        
        self.yourDetails = userInfo;
        [self.yourDetailsView setUserDetailsWith:userInfo];
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
    }];
}

-(void)updateYourDetails:(HWBankUserInfo*) userInfo {
    
    [self.networkManager updateBankUserInfo:userInfo
                               successBlock:^{
                                   
                                  
                               } failureBlock:^(NSError *error) {
                                   
         [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                               }];
}


//bank account

- (void) setBankAccount {
    
    [self.networkManager getBankAccountInfoWithSuccessBlock:^(HWBankAccountInfo *accInfo) {
        
        self.accountInfo = accInfo;
        [self.bankAccountView setBankAccount:accInfo];
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
    }];
}

- (void) updateBankAccount:(HWBankAccountInfo*)bankAcc {
    
    [self.networkManager updateBankAccountInfo:bankAcc
                                  successBlock:^{
                                      
                                      
                                      
                                  } failureBlock:^(NSError *error) {
                                      
        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                  }];
}

// bank account address

- (void) setBankAccountAddress {
    
    [self.networkManager getBankAccountAddressWithSuccessBlock:^(HWBankAccountAddress *bankaddress) {
        
        self.accountAddress = bankaddress;
        [self.bankAccAddressView setBankAccountAddress:bankaddress];
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
    }];
}

- (void) updateBankAccountAddress:(HWBankAccountAddress *)bankAddress {
    
    [self.networkManager updateBankAccountAddress: bankAddress
                                     successBlock:^{
                                         
                                         
                                     } failureBlock:^(NSError *error) {
                                         
        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                     }];
}



@end
