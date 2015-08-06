//
//  AddCardViewController.h
//  Hawkist
//
//  Created by Anton on 03.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWBaseViewController.h"
#import "NavigationVIew.h"
#import "CustomField.h"
#import "HWCard.h"
#import "CDatePickerViewEx.h"

@interface AddCardViewController : HWBaseViewController <NavigationViewDelegate,UIPickerViewDelegate,CDatePickerViewExDelegate>

@property (strong, nonatomic) IBOutlet NavigationVIew *navigation;
@property (strong, nonatomic) IBOutlet CustomField *firstName;
@property (strong, nonatomic) IBOutlet CustomField *lastName;
@property (strong, nonatomic) IBOutlet CustomField *cardNumber;
@property (strong, nonatomic) IBOutlet CustomField *cvv;
@property (strong, nonatomic) IBOutlet CustomField *dateField;
- (IBAction)dateModify:(id)sender;
@property (strong, nonatomic) IBOutlet CustomField *addressFirst;
@property (strong, nonatomic) IBOutlet CustomField *addressSecond;
@property (strong, nonatomic) IBOutlet CustomField *city;
@property (strong, nonatomic) IBOutlet CustomField *postCode;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveAction:(id)sender;


- (instancetype) initWithCard:(HWCard*)card;

@end
