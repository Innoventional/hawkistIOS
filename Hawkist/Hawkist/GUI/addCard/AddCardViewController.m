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
#import "CDatePickerViewEx.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface AddCardViewController ()
@property (nonatomic,strong)CDatePickerViewEx* datePicker;
@property (nonatomic,assign)NSUInteger selectedMonth;
@property (nonatomic,assign)NSUInteger selectedYear;
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,strong) HWCard* card;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (nonatomic, strong) CardIOView* cameraInput;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

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
    if ([self.cameraInput superview]==self.view)
    {
        [self.cameraInput removeFromSuperview];
        self.saveButton.hidden = NO;
    }
    else
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [self initDefault];
    
    if (![CardIOUtilities canReadCardWithCamera]) {
        self.cameraButton.hidden = YES;
    }
    
    [CardIOUtilities preload];
    
    self.cameraInput = [[CardIOView alloc]initWithFrame:self.view.bounds];
    
    self.cameraInput.delegate = self;
    
    self.cameraInput.hideCardIOLogo = YES;
    
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
        

        
        [self.datePicker settingDate:[self.card.exp_month intValue] year:[self.card.exp_year intValue]];
        
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adjustKeyboardFrame:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    self.navigation.delegate = self;
    self.datePicker = [[CDatePickerViewEx alloc]init];//WithFrame:CGRectMake(0, 0, 200, 50)];
    
    self.datePicker.deleg = self;
    


    
    
    
    [self.datePicker setBackgroundColor:[UIColor color256RGBWithRed: 55  green: 184 blue: 164]];

    [self.datePicker setMonthTextColor:[UIColor whiteColor]];
    [self.datePicker setYearTextColor:[UIColor whiteColor]];
    
    [self.datePicker selectToday];

    self.navigation.title.text = @"Add New Card";
    self.firstName.title.text = @"FIRST NAME";
    self.lastName.title.text=@"LAST NAME";
    self.cardNumber.title.text = @"CARD NUMBER";
    self.cvv.title.text = @"CVV";
    self.cvv.isCVV = YES;
    self.cvv.inputField.secureTextEntry = YES;
    
    
    
    self.cvv.inputField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.cardNumber.inputField.keyboardType = UIKeyboardTypeNumberPad;
    self.cardNumber.isCardNumber = YES;

    
    self.dateField.title.text = @"EXPIRATION DATE";
    self.dateField.forward.hidden = NO;
    
    self.dateField.inputField.inputView = self.datePicker;
    
    self.addressFirst.title.text = @"ADDRESS LINE 1";
    self.addressSecond.title.text = @"ADDRESS LINE 2";
    
    self.city.title.text = @"CITY";
    self.postCode.title.text = @"POST CODE";
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(hideKeyboard)];
    
    
    UIButton* customButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"signBut"] forState:UIControlStateNormal];
    
    [customButton setTitle:@"Done" forState:UIControlStateNormal];
    
    [customButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchDown];
    
    doneButton.customView = customButton;
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           doneButton,
                           nil];
    [numberToolbar sizeToFit];
    
    
    self.dateField.inputField.inputAccessoryView = numberToolbar;
    

    
    
}

- (void) hideKeyboard
{
    [self.dateField.inputField resignFirstResponder];
}

- (void)didSelect
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM - MMMM YYY"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:usLocale];
    
    self.dateField.inputField.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
    [formatter setDateFormat:@"M"];
    self.selectedMonth = [[formatter stringFromDate:self.datePicker.date] integerValue];
    [formatter setDateFormat:@"YYY"];
    self.selectedYear = [[formatter stringFromDate:self.datePicker.date] integerValue];
}






- (IBAction)saveAction:(id)sender {
    
    if ([self validation])
    {
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
                                                  [self stripeErrorHandler:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
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
        [self didSelect];
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

}


- (BOOL) validation
{
    NSString* action;
    
    if (self.isEdit)
    {
        action = @"update";
    }
    else
    {
        action = @"add";
    }
    
    NSMutableArray* fields = [NSMutableArray array];
    
    if ([self.firstName.inputField.text isEqualToString:@""])
    {
        [fields addObject:@"First Name"];
    }
    
    if ([self.lastName.inputField.text isEqualToString:@""])
    {
        [fields addObject:@"Last Name"];
    }
    
    if ([self.cardNumber.inputField.text isEqualToString:@""])
    {
        [fields addObject:@"Card Number"];
    }
    
    if ([self.cvv.inputField.text isEqualToString:@""])
    {
        [fields addObject:@"CVV"];
    }
    
    if ([self.dateField.inputField.text isEqualToString:@""])
    {
        [fields addObject:@"Expiration Date"];
    }
    
    
    if ([self.addressFirst.inputField.text isEqualToString:@""])
    {
        [fields addObject:@"Address line 1"];
    }
    
    if ([self.city.inputField.text isEqualToString:@""])
    {
        [fields addObject:@"City"];
    }
    
    if ([self.postCode.inputField.text isEqualToString:@""])
    {
        [fields addObject:@"Post Code"];
    }

    if (fields.count == 0)
        return YES;
    
    if (fields.count == 1)
    {
        NSString* titleMessage = [[fields objectAtIndex:0] stringByAppendingString:@" Missing"];
    
        NSString* descMessage = [NSString stringWithFormat:@"You must input the %@ in order to %@ bank card.",[fields objectAtIndex:0],action];
        
        [self showAlertWithTitle:titleMessage  Message:descMessage];
            return NO;
}

    if (fields.count == 2)
    {
        
        NSString* titleMessage = [NSString stringWithFormat:@"%@ & %@ Missing",[fields objectAtIndex:0],[fields objectAtIndex:1]];
        
        NSString* descMessage = [NSString stringWithFormat:@"You must select the %@ and %@ in order to %@ a new bank card.",[fields objectAtIndex:0],[fields objectAtIndex:1],action];
        
        [self showAlertWithTitle:titleMessage  Message:descMessage];
        return NO;
    }
    else
    {
//    TItle: (field_name), (field_name), (field_name), (field_name) & (field_name) Missing
//    Content: You must select the (field_name), (field_name), (field_name), (field_name) and (field_name)  in order to add a new bank card.
        
        NSString* titleMessage = @"";
        
        for (int i=0;i<fields.count;i++)
        {
            titleMessage = [titleMessage stringByAppendingString:[fields objectAtIndex:i]];
            if (i < fields.count - 2)
            {
                titleMessage = [titleMessage stringByAppendingString:@", "];
            }
            if (i == fields.count -2)
            {
                titleMessage = [titleMessage stringByAppendingString:@" & "];
            }
        }
        
        titleMessage = [NSString stringWithFormat:@"%@ Missing",titleMessage];
        
        
        
        
        NSString* descMessage = @"";
        
        for (int i=0;i<fields.count;i++)
        {
            descMessage = [descMessage stringByAppendingString:[fields objectAtIndex:i]];
            if (i < fields.count - 2)
            {
                descMessage = [descMessage stringByAppendingString:@", "];
            }
            if (i == fields.count -2)
            {
                descMessage = [descMessage stringByAppendingString:@" and "];
            }
        }
        
        descMessage = [NSString stringWithFormat:@"You must select the %@ in order to %@ a new bank card.",descMessage,action];
        
        [self showAlertWithTitle:titleMessage  Message:descMessage];
        return NO;
    }

}


- (void) stripeErrorHandler:(NSString*)message
{
    
    if ([message isEqualToString:@"Your card's number is invalid"]){
        [self showAlertWithTitle:@"Invalid Card Number" Message:@"The card number is not a valid card number. Please try again."];
        return;}
    
    if ([message isEqualToString:@"Your card's expiration month is invalid"]){
        [self showAlertWithTitle:@"Card Expired" Message:@"This card has expired. Please try another card."];
        return;}
    if ([message isEqualToString:@"Your card's expiration year is invalid"]){
            [self showAlertWithTitle:@"Card Expired" Message:@"This card appears to be expired. Please try another card."];
        return;}
    if ([message isEqualToString:@"Your card's security code is invalid"]){
        [self showAlertWithTitle:@"Security Code Invalid" Message:@"The security code for this card is invalid. Please try again."];
        return;}
    if ([message isEqualToString:@"Your card number is incorrect."]){
        [self showAlertWithTitle:@"Card Number Incorrect" Message:@"The card number is incorrect. Please try again."];
        return;}
    if ([message isEqualToString:@"Your card has expired."]){
        [self showAlertWithTitle:@"Card Expired." Message:@"This card has expired. Please try another card."];
        return;}
    if ([message isEqualToString:@"Your card's security code is incorrect."]){
        [self showAlertWithTitle:@"Security Code Incorrect" Message:@"The security code for this card is incorrect. Please check the security code."];
        return;}
    if ([message isEqualToString:@"Your card's zip code failed validation."]){
        [self showAlertWithTitle:@"Post Code Failed" Message:@"Post code validation has failed for this card. Please check the post code."];
        return;}
    if ([message isEqualToString:@"Your card was declined."]){
        [self showAlertWithTitle:@"Card Declined." Message:@"The card was declined. Please try another payment method."];
        return;}
    if ([message isEqualToString:@"An error occurred while processing the card."]){
        [self showAlertWithTitle:@"Payment Error" Message:@"An error occurred while processing this card. Please try again."];
        return;}
    
    [self showAlertWithTitle:@"Payment Error" Message:@"An error occurred while processing this card. Please try again."];
    
}


- (void) adjustKeyboardFrame: (NSNotification*) notification
{
   if ([self.dateField.inputField isFirstResponder] && [self.dateField.inputField.text isEqualToString:@""])
   {
       [self didSelect];
   }
}


- (IBAction)test:(id)sender {
    
    [self.view endEditing:YES];
   
    [self.view addSubview:self.cameraInput];
    [self.view bringSubviewToFront: self.navigation];
    self.saveButton.hidden = YES;
   
    
}



- (void)cardIOView:(CardIOView *)cardIOView didScanCard:(CardIOCreditCardInfo *)info {
   
    self.cardNumber.inputField.text = info.cardNumber;
    
    NSMutableString *mu = [NSMutableString stringWithString:info.cardNumber];
    [mu insertString:@" " atIndex:4];
    [mu insertString:@" " atIndex:9];
    [mu insertString:@" " atIndex:14];

    self.cardNumber.inputField.text = mu;
    
    if (info.expiryMonth != 0)
    {
    
    [self.datePicker settingDate:info.expiryMonth year:info.expiryYear];
    [self didSelect];
    
    }
    [cardIOView removeFromSuperview];
    self.saveButton.hidden = NO;
}




@end
