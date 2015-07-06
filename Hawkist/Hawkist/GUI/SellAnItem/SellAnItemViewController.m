//
//  SellAnItemViewController.m
//  Hawkist
//
//  Created by Anton on 01.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "SellAnItemViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIView+Extensions.h"
#import "Masonry.h"
#import "ChoiceTableViewController.h"
#import "NetworkManager.h"

@interface SellAnItemViewController ()

@property (nonatomic,assign)int selectedImage;
@property (nonatomic, assign) BOOL isPlaceholderHidden;
@property (nonatomic, strong) UIColor *placeHolderColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic,weak) NetworkManager* netManager;
@end

@implementation SellAnItemViewController 
@synthesize nav;
@synthesize scrollView;
@synthesize titleField;
@synthesize barCode;
@synthesize takePic1;
@synthesize takePic2;
@synthesize takePic3;
@synthesize descriptionField;
@synthesize platform;
@synthesize category;
@synthesize condition;
@synthesize color;
@synthesize retailPrice;
@synthesize sellingPrice;
@synthesize checkBox1;
@synthesize priceForShipping;
@synthesize checkBox2;
@synthesize postLabel;
@synthesize postField;
@synthesize selectedImage;
@synthesize youGetLabel;
@synthesize netManager;

- (instancetype) init
{
    if (self = [super init])
    {
        netManager = [NetworkManager shared];
        
        UIView* v = [[[NSBundle mainBundle]loadNibNamed:@"SellAnItem" owner:self options:nil]firstObject];
        
        v.frame = self.view.frame;
      
        [self.view addSubview:v];
        
        nav.delegate = self;
        
        [nav.leftButtonOutlet setBackgroundImage:[UIImage imageNamed:@"acdet_back"] forState:UIControlStateNormal];
        [nav.leftButtonOutlet setTitle:@"" forState:UIControlStateNormal];
        [nav.rightButtonOutlet setTitle:@"" forState:UIControlStateNormal];
        nav.title.text = @"Sell An Item";
        [nav.title setTextColor:[UIColor whiteColor]];
        nav.rightButtonOutlet.enabled = NO;
        
        
        platform.delegate = self;
        category.Title.text = @"CATEGORY";
        category.delegate = self;
       
        condition.Title.text = @"CONDITION";
        condition.delegate = self;
        
        color.Title.text = @"COLOR";
        color.delegate = self;
        

        
//        [self registerForKeyboardNotifications];
        
        [self initDefault];
        
    }
    return self;
}


- (void) initDefault
{

     self.placeHolderColor = descriptionField.textColor;
     self.textColor = titleField.textColor;
    
        platform.Text.textColor = self.placeHolderColor;
        category.Text.textColor = self.placeHolderColor;
        condition.Text.textColor = self.placeHolderColor;
        color.Text.textColor = self.placeHolderColor;
    
     platform.Text.text = @"Select a Platform";
     category.Text.text = @"Select a Category";
     condition.Text.text = @"Select a Condition";
     color.Text.text = @"Select a Colour";
    
     retailPrice.textField.text = @"0.00";
     retailPrice.delegate = self;
    
     sellingPrice.textField.text = @"0.00";
     sellingPrice.delegate = self;
    
    checkBox1.selected = YES;
    
     priceForShipping.textField.text = @"0.00";
     priceForShipping.delegate = self;
    
    checkBox2.selected = YES;
     postLabel.text=@"Enter post code";
     postField.text = @"";
    
   
    selectedImage = 0;
    
   
    
    descriptionField.text = @"Brand new in box PS3 for sale with two controllers and 3 games";
    self.isPlaceholderHidden = NO;
    
    sellingPrice.textField.text = @"1.00";
    
}

- (void) showAlert: (NSError*)error
{
    NSLog(@"%@",error);
    
    switch(error.code) {
        case 8:
        {
       
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc]initWithTitle:@"Post Code"
                                           message:error.domain
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil] show];
                
            });
            break;
        }
            
            
        
case 7:
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc]initWithTitle:@"Post Code"
                                       message:error.domain
                                      delegate:nil
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil] show];
            
        });
        break;
    }
    
    
}

    }


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!self.isPlaceholderHidden)
    {
        descriptionField.textColor = self.textColor;
        descriptionField.text =@"";

        self.isPlaceholderHidden = YES;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == titleField)
        
    [descriptionField becomeFirstResponder];
 
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if (textField == postField)
    {
        [self showHud];
        [netManager getCityByPostCode:textField.text successBlock:^(NSString *city) {
            [self hideHud];
            postLabel.text = city;
            
        }
            failureBlock:^(NSError *error) {
            [self hideHud];
            [self showAlert:error];
        }];
    }
    return YES;
}

- (void) textViewDidEndEditing: (UITextView*) textView
{
    if([textView.text isEqualToString: @""])
    {
        descriptionField.textColor = _placeHolderColor;
        textView.text = @"Brand new in box PS3 for sale with two controllers and 3 games";
        self.isPlaceholderHidden = NO;
    }
    
}




- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated: YES];
}


- (void) rightButtonClick
{
    NSLog(@"RightButton");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)LinkAction:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://google.com"]];
}
- (IBAction)checkBox1Action:(id)sender {
   
    ((UIButton*)sender).selected =!((UIButton*)sender).selected;
    
        priceForShipping.textField.enabled =((UIButton*)sender).selected;
    
    if (!priceForShipping.textField.enabled)
    {
        priceForShipping.textField.textColor = self.placeHolderColor;
        priceForShipping.label.textColor = self.placeHolderColor;
    }
    else
    {
        priceForShipping.textField.textColor = self.textColor;
        priceForShipping.label.textColor = self.textColor;
    }
    
}
- (IBAction)checkBox2Action:(id)sender {
 
        ((UIButton*)sender).selected =!((UIButton*)sender).selected;
  
}

- (IBAction)sellAction:(id)sender {
}

- (IBAction)imageClick:(id)sender {
    
    UIActionSheet* popup = [[UIActionSheet alloc] initWithTitle: @""
                                                       delegate: self
                                              cancelButtonTitle: @"Cancel"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: @"Take Photo", @"Choose Photo", nil];
    popup.tag = 1;
    [popup showInView: [UIApplication sharedApplication].keyWindow];
    
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender;
    selectedImage = recognizer.view.tag;



}

- (void)    actionSheet: (UIActionSheet*) popup
   clickedButtonAtIndex: (NSInteger) buttonIndex
{
    switch (popup.tag)
    {
        case 1:
        {
            switch (buttonIndex)
            {
                case 0:
                    [self takePhoto: YES
                        fromGallery: NO];
                    break;
                    
                case 1:
                    [self takePhoto: YES
                        fromGallery: YES];
                    break;
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;
            
    }
}

- (void) takePhoto: (BOOL)photo
       fromGallery:(BOOL)gallery
{
    UIImagePickerControllerSourceType source = gallery ? UIImagePickerControllerSourceTypePhotoLibrary :
    UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: source])
    {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        
        picker.delegate      = self;
        picker.allowsEditing = YES;
        if(photo)
        picker.mediaTypes    = @[(NSString*) kUTTypeImage];
        picker.sourceType    = source;
        
        [self presentViewController: picker animated: YES completion: NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* selImage = info[UIImagePickerControllerEditedImage];
   
    switch (selectedImage) {
            case 1:
        {
            barCode.image = selImage;
                break;
        }
        case 2:
        {
         
            takePic1.image = selImage;
            break;
        }
        case 3:
        {
            
            takePic2.image = selImage;
            break;
        }
        case 4:
        {
            
            takePic3.image = selImage;
            break;
        }
            default:
                break;
        }
    
    
    
    [picker dismissViewControllerAnimated: YES completion:^{
        
    }];
}
    

- (void) selectAction:sender
{
 
    if (sender == color)
    {
        
        
        ChoiceTableViewController* v= [[ChoiceTableViewController alloc]init];
        
        v.items = [NSMutableArray arrayWithObjects:@"Black",@"White",@"Red",@"Blue",@"Green",@"Orange",@"Yellow",@"Purple",@"Not Applicable",nil];
        
       v.navigationView.title.text = @"Choice Color";
        v.delegate = self;
        v.sender = sender;
        
        if (![color.Text.text isEqualToString:@"Select a Colour"])
        {
            v.previousSelected = color.Text.text;
        }
        
        [self presentViewController:v animated:YES completion:nil];
        
    }
    
    if (sender == condition)
    {
        ChoiceTableViewController* v= [[ChoiceTableViewController alloc]init];
        
        v.items = [NSMutableArray arrayWithObjects:@"Brand New in Box",@"Like New",@"Used",@"Refurbished",@"Not Working or Parts Only",nil];
        
        v.navigationView.title.text = @"Choice Condition";
        v.delegate = self;
        v.sender = sender;
        if (![condition.Text.text isEqualToString:@"Select a Condition"])
        {
            v.previousSelected = condition.Text.text;
        }

        
        [self presentViewController:v animated:YES completion:nil];
        
    }
}

- (void) moneyField:(id)sender ModifyTo:(NSString *)value
{
    if (sender == sellingPrice)
    {
        
        float val =  [value floatValue]*0.875;
        youGetLabel.text = [NSString stringWithFormat:@"%.2f.", val];
    }
}

- (void) SelectedItemFrom:(id)sender WithName:(NSString *)name
{
    if (sender == color)
    {
        color.Text.textColor = self.textColor;
        color.Text.text = name;
    }
    
    if (sender == condition)
    {
        condition.Text.textColor = self.textColor;
        condition.Text.text = name;
    }
}



@end