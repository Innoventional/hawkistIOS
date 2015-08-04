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


@interface AddCardViewController ()
@property (nonatomic,strong)UIDatePicker* datePicker;
@property (nonatomic,assign)NSUInteger selectedMonth;
@property (nonatomic,assign)NSUInteger selectedYear;

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
}

- (void) initDefault
{
    self.navigation.delegate = self;
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    
    
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.datePicker setBackgroundColor:[UIColor color256RGBWithRed: 55  green: 184 blue: 164]];

    [self.datePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    
//    UIView* day = (UIView*)[[[self.datePicker subviews] objectAtIndex:1]objectAtIndex:2];
//    
//    day.hidden = YES;
    
    self.navigation.title.text = @"Add New Card";
    self.firstName.title.text = @"YOUR NAME";
    self.lastName.title.text=@"";
    self.cardNumber.title.text = @"CARD NUMBER";
    self.cvv.title.text = @"CVV";
    
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
    
   
    
    NSString* fullName =  [NSString stringWithFormat:@"%@ %@",self.firstName.inputField.text,self.lastName.inputField.text];
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
                                                NSLog(@"%@",error);
                                              }
                                              else
                                              {
                                              [[NetworkManager shared]addNewBankCard:tokenId successBlock:^{
                                                  
                                                  NSLog(@"OK");
                                                [self.navigationController popViewControllerAnimated:NO];
                                              } failureBlock:^(NSError *error) {
                                                  NSLog(@"%@",error);
                                                  
                                              }];
                                              }
                                          }];
    

    

}

- (IBAction)dateModify:(id)sender {
    
}
@end
