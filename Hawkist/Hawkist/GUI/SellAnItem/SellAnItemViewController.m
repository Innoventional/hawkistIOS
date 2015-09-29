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
#import "AppEngine.h"
#import "HWTag+Extensions.h"
#import "WebViewController.h"
#import "AWSS3Manager.h"
#import "HWItem.h"



@interface SellAnItemViewController ()

@property (nonatomic,assign) long selectedImage;
@property (nonatomic, assign) BOOL isPlaceholderHidden;
@property (nonatomic, strong) UIColor *placeHolderColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic,weak) NetworkManager* netManager;
@property (nonatomic,strong) NSMutableArray* tags;
@property (nonatomic,weak) AWSS3Manager* awsManager;

@property (nonatomic,weak) NSArray* tempTagsForCategory;
@property (nonatomic,weak) NSArray* tempTagsForCondition;
@property (nonatomic,weak) NSArray* tempTagsForColor;
@property (nonatomic,assign) int idCategory;
@property (nonatomic,strong)NSString* barUrl;
@property (nonatomic,strong)NSString* img1Url;
@property (nonatomic,strong)NSString* img2Url;
@property (nonatomic,strong)NSString* img3Url;

@property (nonatomic,strong)NSString* bartUrl;
@property (nonatomic,strong)NSString* img1tUrl;
@property (nonatomic,strong)NSString* img2tUrl;
@property (nonatomic,strong)NSString* img3tUrl;

@property (nonatomic,weak) AppEngine* engine;

@property (nonatomic,assign)BOOL isCreate;
@property (nonatomic,strong)NSString* itemId;

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
@synthesize awsManager;
@synthesize engine;

- (instancetype) init
{
    if (self = [super init])
    {
        netManager = [NetworkManager shared];
        
        awsManager = [AWSS3Manager shared];
        
        UIView* v = [[[NSBundle mainBundle]loadNibNamed:@"SellAnItem" owner:self options:nil]firstObject];
        
        v.frame = self.view.frame;
      
        [self.view addSubview:v];
        
        nav.delegate = self;
        
        [nav.leftButtonOutlet setImage:[UIImage imageNamed:@"acdet_back"] forState:UIControlStateNormal];
        [nav.leftButtonOutlet setTitle:@"" forState:UIControlStateNormal];
        [nav.rightButtonOutlet setTitle:@"" forState:UIControlStateNormal];
        nav.title.text = @"Sell an Item";
        [nav.title setTextColor:[UIColor whiteColor]];
        nav.rightButtonOutlet.enabled = NO;
        
        
        platform.delegate = self;
        category.Title.text = @"CATEGORY";
        category.delegate = self;
       
        condition.Title.text = @"CONDITION";
        condition.delegate = self;
        
//        color.Title.text = @"COLOUR";
//        color.delegate = self;

        color.Title.text = @"SUB-CATEGORY";
        color.delegate = self;
       
            engine = [AppEngine shared];
            self.tags = engine.tags;
        
        
        [self initDefault];
        
                
    }
    return self;
}

- (instancetype) initWithItem:(HWItem*)currentItem
{
    if (self = [self init])
    {
        HWTag* currentTag = [HWTag getPlatformById:currentItem.platform from:self.tags];
        
        HWCategory* currentCategory = [HWTag getCategoryById:currentItem.category from:currentTag.categories];
        
        HWSubCategories* currentSubCategory = [HWTag getSubCategoryById:currentItem.subcategory from:currentCategory.subcategories];
        
       // HWColor* currentColor = [HWTag getColorById:currentItem.color from:currentSubCategory.color];
        
        HWCondition* currentCondition = [HWTag getConditionById:currentItem.condition from:currentSubCategory.condition];
        
        
        
        platform.Text.textColor = self.textColor;
        category.Text.textColor = self.textColor;
        color.Text.textColor = self.textColor;
        condition.Text.textColor = self.textColor;
        
        
        titleField.text = currentItem.title;
        descriptionField.text = currentItem.item_description;
       // descriptionField.textColor = self.textColor;
        
        descriptionField.placeholderTextColor = self.textColor;
        
        color.isEnabled = YES;
        condition.isEnabled = YES;
        category.isEnabled = YES;
        
        
        platform.Text.text = currentTag.name;
        platform.Text.tag = currentItem.platform;
        
        self.idCategory = [currentCategory.id integerValue];
        category.Text.text = currentCategory.name;
        category.Text.tag = [currentSubCategory.id integerValue];
        
        color.Text.text = currentSubCategory.name;
        color.Text.tag = [currentSubCategory.id integerValue];
        
        condition.Text.text = currentCondition.name;
        condition.Text.tag = [currentCondition.id integerValue];
        

//        if (currentSubCategory.color.count == 1 && [((HWColor*)[((NSArray*)currentSubCategory.color) firstObject]).code isEqual:@""])
//        {
//            color.notApplicable = YES;
//            color.isEnabled = YES;
//        }
//        else
//        {
//            color.isEnabled = YES;
//            color.notApplicable = NO;
//        }

        
        
        
        self.tempTagsForCategory = currentTag.categories;
        self.tempTagsForCondition = currentSubCategory.condition;
        self.tempTagsForColor = currentCategory.subcategories;
        
        
        
        
        retailPrice.textField.text = currentItem.retail_price;
        sellingPrice.textField.text = currentItem.selling_price;
        
        float val =  [currentItem.selling_price floatValue]*0.875;
        youGetLabel.text = [NSString stringWithFormat:@"%.2f.", val];

        
        if (currentItem.shipping_price)
        {
            priceForShipping.textField.text =  currentItem.shipping_price;
            checkBox1.selected = YES;
            checkBox1.enabled = YES;
            priceForShipping.textField.enabled = YES;
            priceForShipping.textField.textColor = self.textColor;
             priceForShipping.label.textColor = self.textColor;
        }
        else
        {
            checkBox1.selected = NO;
            priceForShipping.textField.enabled = NO;
            priceForShipping.textField.text = @"0.00";
            priceForShipping.textField.textColor = self.placeHolderColor;
            priceForShipping.label.textColor = self.placeHolderColor;
        }
        
        checkBox2.selected = currentItem.collection_only;
       
        
        
        postField.text = currentItem.post_code;

        postLabel.text = currentItem.city;
        
        [self setImages:currentItem.photos];
        

        
        
        
        
//        NSMutableArray* tmpArrayForImage = [[NSMutableArray alloc]init];
//        
//        if (self.barUrl)
//            [tmpArrayForImage addObject:self.barUrl];
//        
//        
//        if (self.img1Url)
//            [tmpArrayForImage addObject:self.img1Url];
//        
//        
//        if (self.img2Url)
//            [tmpArrayForImage addObject:self.img2Url];
//        
//        if (self.img3Url)
//            [tmpArrayForImage addObject:self.img3Url];
//        
//        
//        
//        currentItem.photos = [NSArray arrayWithArray:tmpArrayForImage];
        
        
        [self.sellButton setTitle:@"SAVE" forState:UIControlStateNormal];
        
      //  self.sellButton.enabled = YES;
        self.itemId = currentItem.id;
        
        self.isCreate = NO;
        
    }

    return self;
}


- (void) setImages:(NSArray*)imagesArray
{
    for(NSInteger index = 0; index < imagesArray.count; index++)
    {
        switch (index) {
            case 0:
            {
                HWImageWithThumbnail* i = [imagesArray objectAtIndex:index];
                [self.barCode setImageWithURL: [NSURL URLWithString: i.image] placeholderImage: nil];
            
                self.barUrl = i.image;
                self.bartUrl = i.thumbnail;
                
                break;
            }
            case 1:
            {
                HWImageWithThumbnail* i = [imagesArray objectAtIndex:index];
                [self.takePic1 setImageWithURL: [NSURL URLWithString: i.image] placeholderImage:nil];
                self.img1Url = i.image;
                self.img1tUrl = i.thumbnail;
                break;
            }
            case 2:
            {
                HWImageWithThumbnail* i = [imagesArray objectAtIndex:index];
                [self.takePic2 setImageWithURL: [NSURL URLWithString: i.image] placeholderImage:nil];
                self.img2Url = i.image;
                self.img2tUrl = i.thumbnail;
                break;
            }
            case 3:
            {
                HWImageWithThumbnail* i = [imagesArray objectAtIndex:index];
                [self.takePic3
                 setImageWithURL: [NSURL URLWithString: i.image] placeholderImage:nil];
                self.img3Url = i.image;
                self.img3tUrl = i.thumbnail;
                break;
            }
            default:
                break;
        }
        
}
}



- (void) initDefault
{
    
    self.sellButton.enabled = YES;
    self.isCreate = YES;
    
     self.placeHolderColor = descriptionField.textColor;
     self.textColor = titleField.textColor;
    
        platform.Text.textColor = self.placeHolderColor;
        category.Text.textColor = self.placeHolderColor;
        condition.Text.textColor = self.placeHolderColor;
        color.Text.textColor = self.placeHolderColor;
    
     platform.Text.text = @"Select a Platform";
     category.Text.text = @"Select a Category";
     condition.Text.text = @"Select a Condition";
     color.Text.text = @"Select a Subcategory";
    
     retailPrice.textField.text = @"0.00";
     retailPrice.delegate = self;
    
     sellingPrice.textField.text = @"0.00";
     sellingPrice.delegate = self;
    
     checkBox1.selected = YES;
    checkBox1.enabled = YES;
     priceForShipping.textField.enabled = YES;
    
    priceForShipping.textField.text = @"0.00";
    priceForShipping.isNoLimited = YES;
     priceForShipping.delegate = self;
    
     checkBox2.selected = YES;
     postLabel.text=@"Enter post code";
     postField.text = @"";
    
     selectedImage = 0;
    
    platform.isEnabled = YES;
    category.isEnabled = NO;
    condition.isEnabled = NO;
    color.isEnabled = NO;
    
    
    
//     category.userInteractionEnabled = NO;
//         color.userInteractionEnabled = NO;
//         condition.userInteractionEnabled = NO;
    
     descriptionField.placeholder = @"Example: Brand new in box PS3 for sale with two controllers and 3 games";
     //self.isPlaceholderHidden = NO;
    
    if(engine.postCode)
    {
        postField.text = engine.postCode;
        postLabel.text = engine.city;
    }
   
    
}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    
//    if (!self.isPlaceholderHidden)
//    {
//        descriptionField.textColor = self.textColor;
//        descriptionField.text =@"";
//
//        self.isPlaceholderHidden = YES;
//    }
//    return YES;
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == titleField)
        
    [descriptionField becomeFirstResponder];
 
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //self.sellButton.enabled = NO;
    
    if (textField == postField && [textField.text isEqualToString:@""])
    {
        self.sellButton.enabled = NO;
    }
    return YES;
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
           self.sellButton.enabled = YES;
            
            
        }
            failureBlock:^(NSError *error) {
            [self hideHud];
           [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
         //       self.sellButton.enabled = NO;
                
        }];
        }
        else
        {
            postLabel.text = @"Enter post code";
           // self.sellButton.enabled = NO;
        }
    }
    
    return YES;
}

- (void) updatePostCode:(void (^)(void)) successBlock

{
    if (postField.text.length>0)
    {
        
        [self showHud];
        [netManager getCityByPostCode:postField.text successBlock:^(NSString *city) {
            [self hideHud];
            postLabel.text = city;
            self.sellButton.enabled = YES;
            
            successBlock();
        }
                         failureBlock:^(NSError *error) {
                             [self hideHud];
                             [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                             
                         }];
    }
    else
    {
        postLabel.text = @"Enter post code";
        [self showAlertWithTitle:@"Post Code missing" Message:@"You must input the Post Code in order to create a listing."];

    }

}


- (void) textViewDidEndEditing: (UITextView*) textView
{
//    if([textView.text isEqualToString: @""])
//    {
//        descriptionField.textColor = _placeHolderColor;
//        textView.text = @"Example: Brand new in box PS3 for sale with two controllers and 3 games";
//        self.isPlaceholderHidden = NO;
//    }
    
}




- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)LinkAction:(id)sender {
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://google.com"]];
    WebViewController *vc = [[WebViewController alloc]initWithUrl:@"https://hawkist.zendesk.com/hc/en-us/articles/204424321-What-does-it-cost-to-sell-on-Hawkist" andTitle:@"More About Our Fees"];
    [self.navigationController pushViewController:vc animated:YES];

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
     [self.view endEditing:YES];
    HWItem* currentItem = [[HWItem alloc]init];
    
    [self updatePostCode:^{
        currentItem.title = titleField.text;
        
        
        currentItem.item_description = descriptionField.text;
        
        currentItem.platform = platform.Text.tag;
        currentItem.category = self.idCategory;
        
        currentItem.subcategory = color.Text.tag;
        currentItem.condition = condition.Text.tag;
        //  currentItem.color  = color.Text.tag;
        
        currentItem.retail_price = retailPrice.textField.text;
        currentItem.selling_price = sellingPrice.textField.text;
        
        if (checkBox1.selected)
            currentItem.shipping_price = priceForShipping.textField.text;
        
        else
            currentItem.shipping_price = @"not_applicable";
        
        
        
        
        currentItem.collection_only = checkBox2.selected;
        
        if (![postField.text isEqualToString:@""])
            
            
            currentItem.post_code = postField.text;
        if (![postLabel.text isEqualToString:@"Enter post code"])
            currentItem.city = postLabel.text;
        
        
        NSMutableArray *tmpArrayForImage = [NSMutableArray array];
        
    
        
        if (self.barUrl)
        {
            
            HWImageWithThumbnail *pics = [[HWImageWithThumbnail alloc]init];
            pics.image = self.barUrl;
            pics.thumbnail = self.bartUrl;
            
            [tmpArrayForImage addObject:pics];
        }
        
        if (self.img1Url)
        {
            HWImageWithThumbnail *pics = [[HWImageWithThumbnail alloc]init];
            pics.image = self.img1Url;
            pics.thumbnail = self.img1tUrl;
        
        [tmpArrayForImage addObject:pics];
        }
        
        if (self.img2Url){
            HWImageWithThumbnail *pics = [[HWImageWithThumbnail alloc]init];
        pics.image = self.img2Url;
        pics.thumbnail = self.img1tUrl;
        
        [tmpArrayForImage addObject:pics];
        }
        
        if (self.img3Url)
        {
            HWImageWithThumbnail *pics = [[HWImageWithThumbnail alloc]init];
            pics.image = self.img3Url;
            pics.thumbnail = self.img3tUrl;
            
            [tmpArrayForImage addObject:pics];
        }
        
        
        currentItem.photos = [[NSArray alloc]initWithArray:tmpArrayForImage];
        
        //  currentItem.barcode = self.barUrl;
        
        
        [self showHud];
        //
        
        currentItem.id = self.itemId;
        
        [netManager createOrUpdateItem:currentItem successBlock:^(HWItem *item) {
            
            NSLog(@"--------------------------Ok");
            [self hideHud];
            [self.navigationController popViewControllerAnimated:YES];
            
            engine.city = postLabel.text;
            engine.postCode = postField.text;
            
        } failureBlock:^(NSError *error) {
            [self hideHud];
            [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }
         ];

        
    }];
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    self.isInternetConnectionAlertShowed = NO;
    
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


- (NSString*) compressingImage:(UIImage*) image
                 withTargetSize:(CGSize)targetSize
                      andNamed:(NSString*)name
{
    
//    float height = (resolution/image.size.width) * image.size.height;
//    
//    
//    CGRect rect = CGRectMake(0,0,resolution,height);
//    
//    UIGraphicsBeginImageContext(rect.size);
    
    UIImage *sourceImage = image;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
       // CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
      //  if (widthFactor < heightFactor)
         //   scaleFactor = widthFactor;
        //else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
      //  if (widthFactor < heightFactor) {
        //    thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        //} else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        //}
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [image drawInRect:thumbnailRect];
    
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    
    UIImage *compressedImage=[UIImage imageWithData:imageData];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
//    [UIImagePNGRepresentation(compressedImage) writeToFile:filePath atomically:YES];
    [UIImagePNGRepresentation(compressedImage) writeToFile:filePath atomically:YES];

    return filePath;
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* selImage = info[UIImagePickerControllerEditedImage];
    
    
   
    switch (selectedImage) {
            case 1:
        {
            
            CGSize imageSize = {500,500};
            CGSize thumbnailSize = {250 ,250};
            
            NSString* fileImage = [self compressingImage:selImage withTargetSize:imageSize andNamed:@"img"];
            NSString* fileThumbnail = [self compressingImage:selImage withTargetSize:thumbnailSize andNamed:@"thumb"];
            
            self.barCode.image = selImage;
            [self showHud];
            
            [awsManager uploadImageWithPath:[NSURL fileURLWithPath:fileImage]
                               successBlock:^(NSString *fileURL) {
                                   self.barUrl = fileURL;
                                   
                                   
                                   [awsManager uploadImageWithPath:[NSURL fileURLWithPath:fileThumbnail]
                                                      successBlock:^(NSString *fileURL) {
                                                          self.bartUrl = fileURL;
                                                          [self hideHud];
                                                          
                                                      }
                                                      failureBlock:^(NSError *error) {
                                                          [self hideHud];
                                                          [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                                      }
                                                     progressBlock:^(CGFloat progress) {
                                                         
                                                         
                                                     }];
                                   
                
            }
                               failureBlock:^(NSError *error) {
                                   [self hideHud];
                                   [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            }
                              progressBlock:^(CGFloat progress) {
                
                                
            }];
            
     
            break;
        }
        case 2:
        {
            
            takePic1.image = selImage;
            
            CGSize imageSize = {500,500};
            CGSize thumbnailSize = {250 ,250};
            
            NSString* fileImage = [self compressingImage:selImage withTargetSize:imageSize andNamed:@"img"];
            NSString* fileThumbnail = [self compressingImage:selImage withTargetSize:thumbnailSize andNamed:@"thumb"];
            
            [self showHud];
            
            [awsManager uploadImageWithPath:[NSURL fileURLWithPath:fileImage]
                               successBlock:^(NSString *fileURL) {
                                   self.img1Url = fileURL;
                                   
                                   
                                   [awsManager uploadImageWithPath:[NSURL fileURLWithPath:fileThumbnail]
                                                      successBlock:^(NSString *fileURL) {
                                                          self.img1tUrl = fileURL;
                                                          [self hideHud];
                                                          
                                                      }
                                                      failureBlock:^(NSError *error) {
                                                          [self hideHud];
                                                          [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                                      }
                                                     progressBlock:^(CGFloat progress) {
                                                         
                                                         
                                                     }];
                                   
                                   
                               }
                               failureBlock:^(NSError *error) {
                                   [self hideHud];
                                   [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                               }
                              progressBlock:^(CGFloat progress) {
                                  
                                  
                              }];

            break;
        }
        case 3:
        {
            
            takePic2.image = selImage;
            
            CGSize imageSize = {500,500};
            CGSize thumbnailSize = {250 ,250};
            
            NSString* fileImage = [self compressingImage:selImage withTargetSize:imageSize andNamed:@"img"];
            NSString* fileThumbnail = [self compressingImage:selImage withTargetSize:thumbnailSize andNamed:@"thumb"];
            
            [self showHud];
            
            [awsManager uploadImageWithPath:[NSURL fileURLWithPath:fileImage]
                               successBlock:^(NSString *fileURL) {
                                   self.img2Url = fileURL;
                                   
                                   
                                   [awsManager uploadImageWithPath:[NSURL fileURLWithPath:fileThumbnail]
                                                      successBlock:^(NSString *fileURL) {
                                                          self.img2tUrl = fileURL;
                                                          [self hideHud];
                                                          
                                                      }
                                                      failureBlock:^(NSError *error) {
                                                          [self hideHud];
                                                          [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                                      }
                                                     progressBlock:^(CGFloat progress) {
                                                         
                                                         
                                                     }];
                                   
                                   
                               }
                               failureBlock:^(NSError *error) {
                                   [self hideHud];
                                   [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                               }
                              progressBlock:^(CGFloat progress) {
                                  
                                  
                              }];
            
            break;
        }
        case 4:
        {

            takePic3.image = selImage;
            
            CGSize imageSize = {500,500};
            CGSize thumbnailSize = {250 ,250};
            
            NSString* fileImage = [self compressingImage:selImage withTargetSize:imageSize andNamed:@"img"];
            NSString* fileThumbnail = [self compressingImage:selImage withTargetSize:thumbnailSize andNamed:@"thumb"];
            
            [self showHud];
            
            [awsManager uploadImageWithPath:[NSURL fileURLWithPath:fileImage]
                               successBlock:^(NSString *fileURL) {
                                   self.img3Url = fileURL;
                                   
                                   
                                   [awsManager uploadImageWithPath:[NSURL fileURLWithPath:fileThumbnail]
                                                      successBlock:^(NSString *fileURL) {
                                                          self.img3tUrl = fileURL;
                                                          [self hideHud];
                                                          
                                                      }
                                                      failureBlock:^(NSError *error) {
                                                          [self hideHud];
                                                          [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                                      }
                                                     progressBlock:^(CGFloat progress) {
                                                         
                                                         
                                                     }];
                                   
                                   
                               }
                               failureBlock:^(NSError *error) {
                                   [self hideHud];
                                   [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                               }
                              progressBlock:^(CGFloat progress) {
                                  
                                  
                              }];
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
        
        
        if (!((CustomButton*)sender).isEnabled)
        {
            
            //[self showAlertWithTitle:@"Choose a Category" Message:@"To select a Colour you must choose a Category first."];
            [self showAlertWithTitle:@"Choose a Category" Message:@"To select a Sub-Category you must choose a Category first."];
            return;
        }
        
//        if (((CustomButton*)sender).notApplicable)
//        {
//            
//            [self showAlertWithTitle:@"Colour Not Applicable" Message:[NSString stringWithFormat:@"The Subcategory %@ does not have a colour. Please select Not Applicable.", self.category.Text.text]];
//            return;
//        }

      

        UINavigationController* navigationController = [[UINavigationController alloc]init];
        
   
        
        ChoiceTableViewController* v= [[ChoiceTableViewController alloc]init];
      
        v.items = [NSMutableArray arrayWithArray:self.tempTagsForColor];
        
        //v.navigationView.title.text = @"Select a Colour";
        v.navigationView.title.text = @"Select a Sub-Category";
        v.delegate = self;
        v.sender = sender;
        
        [navigationController pushViewController:v animated:NO];
        
        navigationController.navigationBarHidden = YES;
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }
    
    if (sender == condition)
    {
        if (!((CustomButton*)sender).isEnabled)
        {
            [self showAlertWithTitle:@"Choose a Sub-Category" Message:@"To select a Condition you must choose a Sub-Category first."];
            return;
        }

        
        ChoiceTableViewController* v= [[ChoiceTableViewController alloc]init];
        UINavigationController* navigationController = [[UINavigationController alloc]init];

        v.items = [NSMutableArray arrayWithArray:self.tempTagsForCondition];
        v.navigationView.title.text = @"Select a Condition";
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
        v.items = [NSMutableArray arrayWithArray:self.tags];
        
        v.navigationView.title.text = @"Select a Platform";
        v.delegate = self;
        v.sender = sender;
        
      
        [navigationController pushViewController:v animated:NO];
        navigationController.navigationBarHidden = YES;
        v.isPlatform = YES;
        
        [self presentViewController:navigationController animated:YES completion:nil];


    }
    
    if (sender == category)
    {
        if (!((CustomButton*)sender).isEnabled)
        {
            [self showAlertWithTitle:@"Choose a Platform" Message:@"To select a Category you must choose a Platform first."];
            return;
        }

        
        UINavigationController* navigationController = [[UINavigationController alloc]init];
        
        
        ChoiceTableViewController* v= [[ChoiceTableViewController alloc]init];

        v.items = [NSMutableArray arrayWithArray:self.tempTagsForCategory];
        v.navigationView.title.text = @"Select a Category";
        v.delegate = self;
        v.sender = sender;
        
        
        [navigationController pushViewController:v animated:NO];
        navigationController.navigationBarHidden = YES;
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
        
    }
    
}


- (void) moneyFieldDidBeginEditing:(id)sender
{
   // self.sellButton.enabled = NO;
}

- (void) moneyFieldPriceToHight:(id)sender
{
   [[[UIAlertView alloc]initWithTitle:@"Price Too High" message:@"You cannot set a price which is greater than £5000." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
   // self.sellButton.enabled = NO;
}

- (void) moneyField:(id)sender modifyTo:(NSString *)value
{
    if (sender == sellingPrice)
    {
        float val =  [value floatValue]*0.875;
        youGetLabel.text = [NSString stringWithFormat:@"%.2f.", val];
        
//        if ([value floatValue] == 0.0f)
//        {
//            checkBox1.enabled = YES;
//           // checkBox1.selected = YES;
//            priceForShipping.textField.enabled = NO;
//            priceForShipping.textField.text = @"0.00";
//        }
//        else
//        {
//            checkBox1.enabled = YES;
//        }
    }
    
    //self.sellButton.enabled = YES;
}

- (void) SelectedItemFrom:(id)sender WithItem:(NSObject *)selection
{
    
  
    
    if (sender == platform)
    {
        
        
        platform.Text.textColor = self.textColor;
        platform.Text.text = ((HWTag*)selection).name;
        
        self.tempTagsForCategory = ((HWTag*)selection).categories;
        category.Text.textColor = self.placeHolderColor;
        category.Text.text = @"Select a Category";
        
        color.Text.textColor = self.placeHolderColor;
        color.Text.text = @"Select a Sub-Category";
        
        condition.Text.textColor = self.placeHolderColor;
        condition.Text.text = @"Select a Condition";
        
        category.isFirstSelection = YES;
//                        category.userInteractionEnabled = YES;
//        
//                            color.userInteractionEnabled = NO;
//                            condition.userInteractionEnabled = NO;
        
        category.isEnabled = YES;
        category.Text.tag = nil;
        color.isEnabled = NO;
        condition.isEnabled = NO;
        
        color.Text.tag = 0;
        condition.Text.tag = 0;
        
        
        
        
        platform.Text.tag = [((HWTag*)selection).id integerValue];
        
        return;
        
    }
    
    
    if (sender == category)
    {
        
        HWSubCategories* currentSubCategories = ((HWSubCategories*)selection);
        
        category.Text.textColor = self.textColor;
        category.Text.text = ((HWSubCategories*)selection).name;
        
        
//        if (currentSubCategories.color.count == 1 && [((HWColor*)[((NSArray*)currentSubCategories.color) firstObject]).code isEqual:@""])
//        {
//            
//            color.Text.textColor = self.textColor;
//            color.Text.text = @"Not Applicable";
//            
//            color.notApplicable = YES;
//            color.isEnabled = YES;
//
//            
//            color.Text.tag = [((HWColor*)[((HWSubCategories*)selection).color firstObject]).id integerValue];
//            
//        }
//        else
//        {
//            
//            color.Text.textColor = self.placeHolderColor;
//            color.Text.text = @"Select a Colour";
            color.isEnabled = YES;
//            color.notApplicable = NO;
//            self.tempTagsForColor = currentSubCategories.color;
        
        condition.Text.textColor = self.placeHolderColor;
        condition.Text.text = @"Select a Condition";
        condition.Text.tag = nil;
        condition.isEnabled = NO;

//
//        }
        
        self.tempTagsForColor = ((HWCategory*)selection).subcategories;
        
        color.Text.textColor = self.placeHolderColor;
        color.Text.text = @"Select a Sub-Category";
        color.Text.tag = nil;
        
//        
//        self.idCategory = ((HWSubCategories*)selection).parent_id;
//        category.Text.tag = [((HWSubCategories*)selection).id integerValue];
        
        self.idCategory = [((HWCategory*)selection).id integerValue];
       // category.Text.tag = [((HWSubCategories*)selection).id integerValue];
        
        return;
    }
    
    if (sender == color)
    {
        HWSubCategories* currentSubCategories = ((HWSubCategories*)selection);
        color.Text.textColor = self.textColor;
//        color.Text.text = ((HWColor*)selection).name;
        color.Text.text = ((HWSubCategories*)selection).name;
        
//        color.Text.tag = [((HWColor*)selection).id integerValue];
        color.Text.tag = [((HWSubCategories*)selection).id integerValue];
        
        
        self.tempTagsForCondition = currentSubCategories.condition;
        
        condition.Text.textColor = self.placeHolderColor;
        condition.Text.text = @"Select a Condition";
        condition.Text.tag = nil;

        condition.isEnabled = YES;
    }
    
    if (sender == condition)
    {
        condition.Text.textColor = self.textColor;
        condition.Text.text = ((HWCondition*)selection).name;
        
        condition.Text.tag = [((HWCondition*)selection).id integerValue];
    }
}

@end