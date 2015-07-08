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

@property (nonatomic,assign) long selectedImage;
@property (nonatomic, assign) BOOL isPlaceholderHidden;
@property (nonatomic, strong) UIColor *placeHolderColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic,weak) NetworkManager* netManager;
@property (nonatomic,strong) NSMutableArray* tags;



@property (nonatomic,weak) NSArray* tempTagsForCategory;



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
        [self downloadData];
        
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
    

    
}


- (void) downloadData
{
    [netManager getListOfTags:^(NSMutableArray *tags) {
        
        
        self.tags = tags;
        
    } failureBlock:^(NSError *error) {
        
        [self showAlert:error];
    }];

}

- (void) showAlert: (NSError*)error
{
    NSLog(@"%@",error);
    
    switch(error.code) {
        case 7:
        {
       
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc]initWithTitle:@"Incorrect Post Code"
                                           message:error.domain
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil] show];
                
            });
            break;
        }
            
            
        
case 8:
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc]initWithTitle:@"Post Code Not Found"
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
        
       if (textField.text.length>0)
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
        else
        {
            postLabel.text = @"Enter post code";
        }
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
 
    HWItem* currentItem = [[HWItem alloc]init];
    
    currentItem.title = titleField.text;
    currentItem.item_description = descriptionField.text;
   
    
    currentItem.platform = platform.Text.tag;
    currentItem.category = 30;      //TODO: Why 0?
    
    
    currentItem.subcategory = category.Text.tag;
    currentItem.condition = condition.Text.tag;
    currentItem.color  = color.Text.tag;
    
    currentItem.retail_price = retailPrice.textField.text;
    currentItem.selling_price = sellingPrice.textField.text;
    
    currentItem.shipping_price = priceForShipping.textField.text;
    
    currentItem.collection_only = checkBox2.selected;
    
    if (![postField.text isEqualToString:@""])
    
    
    currentItem.post_code = postField.text;
    if (![postLabel.text isEqualToString:@"Enter post code"])
        currentItem.city = postLabel.text;

    currentItem.photos = [NSArray arrayWithObjects:@"http://www.thetimes.co.uk/tto/multimedia/archive/00309/108787995_309592c.jpg",nil];
    
//    @property (nonatomic, strong) NSString<Optional>* barcode;
//    @property (nonatomic, strong) NSArray<Optional>* photos;
    
    
    
    [netManager createItem:currentItem successBlock:^(HWItem *item) {
        
        NSLog(@"--------------------------Saved");
    } failureBlock:^(NSError *error) {
        
        [self showAlert:error];
    }
     ];
    
}

- (IBAction)imageClick:(id)sender {
    
    UIActionSheet* popup = [[UIActionSheet alloc] initWithTitle: nil
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
        UINavigationController* navigationController = [[UINavigationController alloc]init];
        
   
        
        ChoiceTableViewController* v= [[ChoiceTableViewController alloc]init];
//        
//        v.items = [NSMutableArray arrayWithObjects:@"Black",@"White",@"Red",@"Blue",@"Green",@"Orange",@"Yellow",@"Purple",@"Not Applicable",nil];
        
        for (HWTag* tag in self.tags)
        {
            if ([tag.name isEqualToString:@"colour"])
            {
                v.items = [NSMutableArray arrayWithArray:tag.children];
//                
//                    for (HWTags* nameColor in tag.children)
//                    {
//                        [v.items addObject:nameColor];
//                    }
            }
        }
        
       v.navigationView.title.text = @"Choice Color";
        v.delegate = self;
        v.sender = sender;
        
        [navigationController pushViewController:v animated:NO];
        
        navigationController.navigationBarHidden = YES;
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }
    
    if (sender == condition)
    {
        ChoiceTableViewController* v= [[ChoiceTableViewController alloc]init];
        UINavigationController* navigationController = [[UINavigationController alloc]init];

//        v.items = [NSMutableArray arrayWithObjects:@"Brand New in Box",@"Like New",@"Used",@"Refurbished",@"Not Working or Parts Only",nil];
        
        for (HWTag* tag in self.tags)
        {
            if ([tag.name isEqualToString:@"condition"])
            {
                v.items = [NSMutableArray arrayWithArray:tag.children];
            }

        }
        v.navigationView.title.text = @"Choice Condition";
        v.delegate = self;
        v.sender = sender;
            
        [navigationController pushViewController:v animated:NO];
        navigationController.navigationBarHidden = YES;
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
        
        }
    
    if (sender == platform)
    {
        UINavigationController* navigationController = [[UINavigationController alloc]init];
        

        ChoiceTableViewController* v= [[ChoiceTableViewController alloc]init];
        
        for (HWTag* tag in self.tags)
        {
            if ([tag.name isEqualToString:@"platform"])
            {
                v.items = [NSMutableArray arrayWithArray:tag.children];
            }
            
        }
        v.navigationView.title.text = @"Choice Platform";
        v.delegate = self;
        v.sender = sender;
        
      
        [navigationController pushViewController:v animated:NO];
        navigationController.navigationBarHidden = YES;
        v.isPlatform = YES;
        
        [self presentViewController:navigationController animated:YES completion:nil];
        

    }
    
    if (sender == category)
    {
        UINavigationController* navigationController = [[UINavigationController alloc]init];
        
        
        ChoiceTableViewController* v= [[ChoiceTableViewController alloc]init];
        
//        for (HWTag* tag in self.tags)
//        {
//            if ([tag.name isEqualToString:@"category"])
//            {
//                v.items = [NSMutableArray arrayWithArray:tag.children];
//            }
//            
//        }
        
        v.items = self.tempTagsForCategory;
        v.navigationView.title.text = @"Choice Category";
        v.delegate = self;
        v.sender = sender;
        
        
        [navigationController pushViewController:v animated:NO];
        navigationController.navigationBarHidden = YES;
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
        
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

- (void) SelectedItemFrom:(id)sender WithItem:(HWTag *)tag
{
    
    CustomButton* currentButton = (CustomButton*)sender;
    
    currentButton.Text.textColor = self.textColor;
    currentButton.Text.text = tag.name;
    currentButton.Text.tag = [tag.id integerValue];
    
//    
//    if (sender == color)
//    {
//        color.Text.textColor = self.textColor;
//        color.Text.text = tag.name;
//    }
//    
//    if (sender == condition)
//    {
//        condition.Text.textColor = self.textColor;
//        condition.Text.text = tag.name;
//    }
//    
    if (sender == platform)
    {
        platform.Text.textColor = self.textColor;
        platform.Text.text = tag.name;
        
        self.tempTagsForCategory = tag.children;
        category.Text.textColor = self.placeHolderColor;
        category.Text.text = @"Select Category";
    }

}



@end