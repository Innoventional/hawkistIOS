//
//  AddCardViewController.m
//  Hawkist
//
//  Created by Anton on 03.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "AddCardViewController.h"
#import "ManageBankViewController.h"
#import "StripeManager.h"
#import "UIColor+Extensions.h"
#import "HWCard.h"


@interface AddCardViewController ()
@property (nonatomic,strong)UIDatePicker* datePicker;
@property (nonatomic,assign)NSUInteger selectedMonth;
@property (nonatomic,assign)NSUInteger selectedYear;
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,strong) HWCard* card;

@end

@implementation AddCardViewController

- (instancetype)init
{
    self = [super initWithNibName: @"AddCardView" bundle: nil];
    if(self)
    {
        
    }
    return self;
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [self initDefault];
    
    if (self.isEdit) {
        NSArray  *arrayOfNames = [self.card.name componentsSeparatedByString:@" "];
        
        if ([arrayOfNames count] == 2 )
        {
            self.firstName.inputField.text = [arrayOfNames objectAtIndex:0];
            self.lastName.inputField.text = [arrayOfNames objectAtIndex:1];
        }
        else
            self.firstName.inputField.text = self.card.name;
        
        NSString* first = @"●●●● ●●●● ●●●● ";
        
        self.cardNumber.inputField.text = [first stringByAppendingString:self.card.last4];
        self.cvv.inputField.text = @"***";
        self.cvv.inputField.enabled = NO;
        self.cardNumber.inputField.enabled = NO;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        
        
        [components setMonth:[self.card.exp_month intValue]];
        [components setYear:[self.card.exp_year intValue]];
        
        
        NSDate *date = [calendar dateFromComponents:components];
        
        self.datePicker.date = date;
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"M - MMMM YYY"];
        self.dateField.inputField.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
        
        self.addressFirst.inputField.text = self.card.address_line1;
        self.addressSecond.inputField.text = self.card.address_line2;
        self.city.inputField.text = self.card.city;
        self.postCode.inputField.text = self.card.postcode;
        
        self.navigation.title.text = @"Edit Card";
        [self.saveButton setTitle:@"UPDATE" forState:UIControlStateNormal];
        
    }
}


- (instancetype) initWithCard:(HWCard*)card
{
    if (self = [self init])
    {
    
        self.card = card;
        self.isEdit = YES;
    }
    return self;
}


- (void) initDefault
{
    self.navigation.delegate = self;
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    
    
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    
    
    
    [self.datePicker setBackgroundColor:[UIColor color256RGBWithRed: 55  green: 184 blue: 164]];

    [self.datePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    
    self.navigation.title.text = @"Add New Card";
    self.firstName.title.text = @"YOUR NAME";
    self.lastName.title.text=@"";
    self.cardNumber.title.text = @"CARD NUMBER";
    self.cvv.title.text = @"CVV";
    self.cvv.isCVV = YES;
    self.cvv.inputField.secureTextEntry = YES;
    self.cvv.inputField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.cardNumber.inputField.keyboardType = UIKeyboardTypeNumberPad;
    self.cardNumber.isCardNumber = YES;
    self.postCode.inputField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.dateField.title.text = @"EXPIRATION DATE";
    self.dateField.forward.hidden = NO;
    
    self.dateField.inputField.inputView = self.datePicker;
    
    self.addressFirst.title.text = @"ADDRESS LINE 1";
    self.addressSecond.title.text = @"ADDRESS LINE 2";
    
    self.city.title.text = @"CITY";
    self.postCode.title.text = @"POST CODE";
    
    
}


- (void)dateChanged
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"M - MMMM YYY"];
    self.dateField.inputField.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
    [formatter setDateFormat:@"M"];
    self.selectedMonth = [[formatter stringFromDate:self.datePicker.date] integerValue];
    [formatter setDateFormat:@"YYY"];
    self.selectedYear = [[formatter stringFromDate:self.datePicker.date] integerValue];
}




- (IBAction)saveAction:(id)sender {
    
    if (!self.isEdit){
    
    NSString* fullName =  [NSString stringWithFormat:@"%@ %@",self.firstName.inputField.text,self.lastName.inputField.text];
        [self showHud];
        
    [[StripeManager shared]createTokenFromCardNumber:self.cardNumber.inputField.text
                                            expMonth:self.selectedMonth
                                             expYear:self.selectedYear
                                                 cvc:self.cvv.inputField.text
                                        addressLine1:self.addressFirst.inputField.text
                                        addressLine2:self.addressSecond.inputField.text
                                                name:fullName
                                            postCode:self.postCode.inputField.text
                                                city:self.city.inputField.text
                                          completion:^(NSString *tokenId, NSError *error) {
                                              
                                              if (error)
                                              {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self hideHud];
                                                  });

                                                  [self showAlertWithTitle:@"Stripe" Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                              }
                                              else
                                              {
                                              [[NetworkManager shared]addNewBankCard:tokenId successBlock:^{
                                                  
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
                                          }];
    

    }
    
    else
    {
        
        NSString* fullName =  [NSString stringWithFormat:@"%@ %@",self.firstName.inputField.text,self.lastName.inputField.text];
        [self showHud];
        
        HWCard* card = [[HWCard alloc]init];
        
        card.name = fullName;
        card.exp_month = [NSString stringWithFormat:@"%ld", self.selectedMonth];
        card.exp_year = [NSString stringWithFormat:@"%ld", self.selectedYear];
        card.id = self.card.id;
        card.city = self.city.inputField.text;
        card.postcode = self.postCode.inputField.text;
        card.address_line1 = self.addressFirst.inputField.text;
        card.address_line2 = self.addressSecond.inputField.text;

            [[NetworkManager shared]updateBankCard:card successBlock:^{
                
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

- (IBAction)dateModify:(id)sender {
    
}
@end
