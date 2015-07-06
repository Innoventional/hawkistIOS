//
//  SellAnItemViewController.h
//  Hawkist
//
//  Created by Anton on 01.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationVIew.h"
#import "CustomButton.h"
#import "HWBaseViewController.h"
#import "MoneyField.h"
#import "ChoiceTableViewController.h"

@interface SellAnItemViewController : HWBaseViewController <NavigationViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UITextViewDelegate,CustomButtonDelegate,ChoiceTableViewDelegata,MoneyFieldDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NavigationVIew *nav;


@property (weak, nonatomic) IBOutlet UIImageView *barCode;
@property (weak, nonatomic) IBOutlet UIImageView *takePic1;
@property (weak, nonatomic) IBOutlet UIImageView *takePic2;
@property (weak, nonatomic) IBOutlet UIImageView *takePic3;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;

@property (weak, nonatomic) IBOutlet CustomButton *platform;
@property (weak, nonatomic) IBOutlet CustomButton *category;
@property (weak, nonatomic) IBOutlet CustomButton *condition;
@property (weak, nonatomic) IBOutlet CustomButton *color;
- (IBAction)LinkAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet MoneyField *retailPrice;
@property (weak, nonatomic) IBOutlet MoneyField *sellingPrice;
@property (weak, nonatomic) IBOutlet UILabel *youGetLabel;


@property (weak, nonatomic) IBOutlet UIButton *checkBox1;
- (IBAction)checkBox1Action:(id)sender;
@property (weak, nonatomic) IBOutlet MoneyField *priceForShipping;
- (IBAction)checkBox2Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkBox2;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UITextField *postField;

- (IBAction)sellAction:(id)sender;


- (IBAction)imageClick:(id)sender;
@end
