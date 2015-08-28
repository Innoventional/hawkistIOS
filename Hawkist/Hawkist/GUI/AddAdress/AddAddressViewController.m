//
//  AddAddressViewController.m
//  Hawkist
//
//  Created by Anton on 19.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "AddAddressViewController.h"
#import "NavigationVIew.h"
#import "CustomField.h"

@interface AddAddressViewController () <NavigationViewDelegate>
@property (strong, nonatomic) IBOutlet NavigationVIew *navigation;
@property (strong, nonatomic) IBOutlet CustomField *addressLine1;
@property (strong, nonatomic) IBOutlet CustomField *addressLine2;
@property (strong, nonatomic) IBOutlet CustomField *city;
@property (strong, nonatomic) IBOutlet CustomField *postCode;
- (IBAction)saveButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxOutlet;

@property (strong, nonatomic) IBOutlet UIButton *saveOutlet;
@property (strong, nonatomic) HWAddress* currentAddress;
@property (assign, nonatomic) BOOL isEdit;
@property (strong, nonatomic) UIAlertView* addAlert;
@property (strong, nonatomic) UIAlertView* erraceData;
@end

@implementation AddAddressViewController

- (instancetype)init
{
    self = [super initWithNibName: @"AddAddressView" bundle: nil];
    if(self)
    {
        
    }
    return self;
}

- (instancetype) initWithAddress:(HWAddress*)address
{
    if (self = [self init])
    {
        
        self.currentAddress = address;
        self.isEdit = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDefault];
    
    
    
    if (self.isEdit) {
        
        self.addressLine1.inputField.text = self.currentAddress.address_line1;
        self.addressLine2.inputField.text = self.currentAddress.address_line2;
        self.city.inputField.text = self.currentAddress.city;
        self.postCode.inputField.text = self.currentAddress.postcode;
        
        self.navigation.title.text = @"Edit Address";
        [self.saveOutlet setTitle:@"UPDATE" forState:UIControlStateNormal];
        
        
    }
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) initDefault
{
    self.addressLine1.title.text = @"ADDRESS LINE 1";
    self.addressLine2.title.text = @"ADDRESS LINE 2";
    
    self.city.title.text = @"CITY";
    self.postCode.title.text = @"POST CODE";
    
    self.navigation.delegate = self;
    self.navigation.title.text = @"Add New Address";
    
    self.addAlert = [[UIAlertView alloc]initWithTitle:@"Import Billing Address" message:@"Set your Shipping Address to the Billing Address of the most recently registered bank card?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];

    self.erraceData = [[UIAlertView alloc]initWithTitle:@"Clear Data" message:@"Do you want clear data?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];


}

- (IBAction)checkBox:(id)sender {
   
    
    
    if (!((UIButton*)sender).selected)
    {
        [self.addAlert show];
    }
    else
    {
        [self.erraceData show];
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == self.addAlert)
    {
    if (buttonIndex == 1)
    {
        [[NetworkManager shared]getRecentlyAddress:^(HWAddress *address) {
            
            self.addressLine1.inputField.text = address.address_line1;
            self.addressLine2.inputField.text = address.address_line2;
            self.city.inputField.text = address.city;
            self.postCode.inputField.text = address.postcode;
            self.checkBoxOutlet.selected = !self.checkBoxOutlet.selected;
            
            self.addressLine1.inputField.enabled = NO;
            self.addressLine2.inputField.enabled = NO;
            self.city.inputField.enabled = NO;
            self.postCode.inputField.enabled = NO;
            
            
        } failureBlock:^(NSError *error) {
            [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            
        }];
    }
    }
    
    if (alertView == self.erraceData)
    {
        if (buttonIndex == 0)
        {
            self.addressLine1.inputField.text = @"";
            self.addressLine2.inputField.text = @"";
            self.city.inputField.text = @"";
            self.postCode.inputField.text = @"";
        }
        self.checkBoxOutlet.selected = !self.checkBoxOutlet.selected;
        self.addressLine1.inputField.enabled = YES;
        self.addressLine2.inputField.enabled = YES;
        self.city.inputField.enabled = YES;
        self.postCode.inputField.enabled = YES;
    }
    
}

- (IBAction)saveButton:(id)sender {
    
    if (!self.isEdit)
    {
    HWAddress *address = [[HWAddress alloc]init];
    
    address.address_line1 = self.addressLine1.inputField.text;
    address.address_line2 = self.addressLine2.inputField.text;
    address.city = self.city.inputField.text;
    address.postcode = self.postCode.inputField.text;
    
    
    [[NetworkManager shared]addNewAddress:address successBlock:^{
        
        NSLog(@"Saved");
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
    }
    
    else
    {
        
        [self showHud];
        
        HWAddress* address = [[HWAddress alloc]init];
        
        
        address.id = self.currentAddress.id;
        
        address.city = self.city.inputField.text;
        address.postcode = self.postCode.inputField.text;
        address.address_line1 = self.addressLine1.inputField.text;
        address.address_line2 = self.addressLine2.inputField.text;
        
        [[NetworkManager shared]updateAddress:address successBlock:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
            });
            [self.navigationController popViewControllerAnimated:NO];
            
        } failureBlock:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
            });
            
            [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];

        }];
    }
}
@end
