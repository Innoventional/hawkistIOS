//
//  ViewItemViewController.m
//  Hawkist
//
//  Created by Evgen Bootcov on 02.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "ViewItemViewController.h"
//#import "FeedScreenCollectionViewCell.h"
#import "HWItem.h"
#import "UIImageView+AFNetworking.h"
#import "AppEngine.h"
#import "HWTag+Extensions.h"
#import "BuyThisItemViewController.h"
#import "HWProfileViewController.h"
#import "SellAnItemViewController.h"
#import "myItemCell.h"
#import "UIImageView+Extensions.h"

#import "HWCommentViewController.h"
#import <pop/POP.h>


#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface ViewItemViewController () <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,MyItemCellDelegate>

@property (nonatomic, strong) HWItem* item;
@property (nonatomic, strong) NSMutableArray* imagesArray;

@property (nonatomic, strong) NSArray *selectedItemsArray;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat lastHeightCollectionView;

@property (nonatomic, assign) BOOL isLikeItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UIActionSheet* editActionSheet;
@property (nonatomic, strong) UIActionSheet *sendToFrandActionSheet;


@property (nonatomic, strong) SLComposeViewController *mySLComposerSheet;



@end



@implementation ViewItemViewController


#pragma mark - UIViewController

- (instancetype) initWithItem: (HWItem*) item
    {
        self = [super initWithNibName: @"ViewItemViewController" bundle: nil];
        if(self)
        {
            self.imagesArray = [NSMutableArray array];
            self.item = item;
//            [[NetworkManager shared] getItemById: self.item.id
//            successBlock:^(HWItem *item) {
//                self.item = item;
//                
//               // [self updateItem];
//            } failureBlock:^(NSError *error) {
//                
//                 [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
//            }];
            
            
            
            
            
        }
        
      
        
        return self;
        
        
    }



- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NetworkManager shared] getItemById: self.item.id
                            successBlock:^(HWItem *item) {
                                self.item = item;
                                
                                [self updateItem];
                            } failureBlock:^(NSError *error) {
                                
                                 [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                            }];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.title.text = @"View Item";
    
    _starRatingControl.delegate = self;
    
    
   self.smallImage1.layer.cornerRadius = 5.0f;
   self.smallImage1.layer.masksToBounds = YES;
    
    
    self.smallImage2.layer.cornerRadius = 5.0f;
    self.smallImage2.layer.masksToBounds = YES;
    
    
    self.smallImage3.layer.cornerRadius = 5.0f;
    self.smallImage3.layer.masksToBounds = YES;
    
    
    self.smallImage4.layer.cornerRadius = 5.0f;
    self.smallImage4.layer.masksToBounds = YES;
    
    self.bigImage.layer.cornerRadius = 5.0f;
    self.bigImage.layer.masksToBounds = YES;
    
    [self.navigationView.rightButtonOutlet setImage:[UIImage imageNamed:@"points"] forState:UIControlStateNormal];

#pragma mark implementation model user and item
    
      
    self.sellerAvatar.layer.cornerRadius = self.sellerAvatar.frame.size.width /2;
    self.sellerAvatar.layer.masksToBounds = YES;
    self.sellerAvatar.layer.borderWidth = 0;
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"OpenSans" size:14.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    
  
#pragma mark ending
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"myItemCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCollection"]];
    
    self.navigationView.delegate = self;
    
    
    [self setImages];
    
}


#pragma mark -
#pragma mark Navigation Delegate

- (void) viewDidAppear:(BOOL)animated
{
    self.isInternetConnectionAlertShowed = NO;
    
}


- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [self updateItem];
}

- (void) rightButtonClick
{
    
    
    
    if([[AppEngine shared].user.id isEqualToString:self.item.user.id])
    {
        self.editActionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                           delegate: self
                                  cancelButtonTitle: @"Cancel"
                             destructiveButtonTitle: nil
                                  otherButtonTitles: @"Edit", nil];
    } else {
        
        self.editActionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                           delegate: self
                                  cancelButtonTitle: @"Cancel"
                             destructiveButtonTitle: nil
                                  otherButtonTitles: @"Report", nil];
    }
    
    
    [self.editActionSheet showInView:self.view];

     
}



#pragma mark - update item
- (void) updateItem
{
    self.navigationView.title.text = self.item.title;
    self.reviews.text = [NSString stringWithFormat:@"%@ (%@ reviews)", self.item.user.rating,self.item.user.review];
    self.starRatingControl.rating = [self.item.user.rating integerValue];
    self.isLikeItem = [self.item.liked integerValue];
    if (self.isLikeItem)
    {
        [self.smallImage4 setImage:[UIImage imageNamed:@"Newstar"]];
    }
    
    
    self.sellerName.text = self.item.user_username;
    
    [self avatarInit];
    
    self.counts.text = self.item.views;
    self.nameOoStuff.text = self.item.title;
    self.comments.text = self.item.comments;
    self.sellerPrice.text = self.item.selling_price;
    self.oldPrice.text = self.item.retail_price;

    [self setupDescription];
    
    self.added.text = [self.item stringItemCreationDate];
    
    HWTag* itemPlatform = [HWTag getPlatformById:self.item.platform from:[AppEngine shared].tags];
    
    self.platform.text =  itemPlatform.name;
    
    HWCategory* itemCategory = [HWTag getCategoryById:self.item.category from:itemPlatform.categories];
    self.category.text = itemCategory.name;
 
    HWSubCategories* itemSubCategory = [HWTag getSubCategoryById:self.item.subcategory from: itemCategory.subcategories];
    HWCondition* itemCondition = [HWTag getConditionById:self.item.condition from: itemSubCategory.condition];
    self.condition.text = itemCondition.name;
   
    HWColor* itemColor = [HWTag getColorById:self.item.color from:itemSubCategory.color];
    self.colour.text = itemColor.name;
    if(self.item.collection_only  )
    {
       self.delivery.text = @"Collection only";
        
        if (self.item.shipping_price) {
            self.delivery.text = [NSString stringWithFormat:@"£ %@ or Collection only", self.item.shipping_price];
        }

        
    } else {
        
    self.delivery.text = [NSString stringWithFormat:@"£ %@", self.item.shipping_price];
    }
    
    if (self.item.discount == nil || [self.item.discount isEqualToString: @"0"]) {
        self.discount.text = @"-1%";
    } else {
        self.discount.text = [NSString stringWithFormat:@"-%@%%",self.item.discount];
    }
    [self.imagesArray removeAllObjects];
    
    if(self.item.photos)
        [self.imagesArray addObjectsFromArray: self.item.photos];
    if(self.item.barcode)
        [self.imagesArray addObject: self.item.barcode];
    
    [self setImages];
    
    
    
    self.selectedItemsArray = self.item.similar_items;
    
    [self.collectionView reloadData];
    [self reloadScrollViewSize];
    
    
    
    
    if ([[AppEngine shared].user.id isEqualToString:self.item.user_id] || [self.item.status isEqualToString:@"1"])
    {
        self.buyThisItem.enabled = NO;
        
        if([[AppEngine shared].user.id isEqualToString:self.item.user_id])
                self.smallImage4.alpha = 0.5;
    }
    else
    {
         self.buyThisItem.enabled = YES;
    }
    
    
}

- (void) setupDescription
{
    NSString *str = [NSString stringWithFormat:@"%@\n%@", self.item.title, self.item.item_description];
    NSRange rangeTitle = [str rangeOfString:self.item.title];
    NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc] initWithString: str ];
    
    [atrStr beginEditing];
    
    UIColor *color = [UIColor colorWithRed:94./255. green:94./255. blue:94./255. alpha:1];
    UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : color, NSFontAttributeName : font  };
    [atrStr addAttributes:attrs
                        range:rangeTitle];
    
    [atrStr endEditing];

    self.descriptionOfItem.attributedText = atrStr;

    
}
- (void) avatarInit
{

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: self.item.user_avatar]];

    [self.sellerAvatar setImageWithURLRequest:request
                           placeholderImage:nil
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                         
                                           self.sellerAvatar.image = image;
                                           

                                       });
                                        
                                        
                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        
                                     
                                        self.sellerAvatar.image = [UIImage imageNamed:@"noPhoto"];
                                    }];
    
    


}

 - (void)setSellerAvatar:(UIImageView *)sellerAvatar
{
    _sellerAvatar = sellerAvatar;
}

- (void) reloadScrollViewSize
{
    
    //reload scroll view size
    
    
    [self.collectionView layoutIfNeeded];
    [self.scrollView layoutIfNeeded];
    
    CGSize size = self.scrollView.contentSize;
    size.height += self.collectionView.contentSize.height - self.lastHeightCollectionView;
    self.scrollView.contentSize = size;
   
    self.lastHeightCollectionView = self.collectionView.contentSize.height ;
    
}

- (void) setImages
{
    for(NSInteger index = 0; index < self.imagesArray.count; index++)
    {
        switch (index) {
            case 0:
            {
                [self.bigImage setImageWithUrl:[NSURL URLWithString: [self.imagesArray objectAtIndex: index]]
                                 withIndicator:self.activityIndicator];
                break;
            }
            case 1:
            {
             
                [self setImageWithString:[self.imagesArray objectAtIndex: index] withImageView:self.smallImage1];

                break;
            }
            case 2:
            {
                [self setImageWithString:[self.imagesArray objectAtIndex: index] withImageView:self.smallImage2];
                
                break;
            }
            case 3:
            {
                [self setImageWithString:[self.imagesArray objectAtIndex: index] withImageView:self.smallImage3];
               
                break;
            }
            default:
                break;
        }
        
    }
}


-(void) setImageWithString:(NSString*)urlStr withImageView:(UIImageView*)iv
{
    
    if(urlStr)
    {
        [iv setImageWithURL: [NSURL URLWithString: urlStr] placeholderImage:nil];
    } else {
        
        iv.image = [UIImage imageNamed:@"noPhoto"];
         
    }
    
}

#pragma mark -
#pragma mark UISegmentedControl
 

- (IBAction)segmentSwith:(UISegmentedControl *)sender {
    
    //select similar or user's items
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.selectedItemsArray = self.item.similar_items;
            break;
            
        case 1:
            self.selectedItemsArray = self.item.user_items;
            break;
            
        default:
            break;
    }
    
    [self.collectionView reloadData];
    [self reloadScrollViewSize];
    
}


#pragma mark ending
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.selectedItemsArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    myItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
   
    HWItem *item  = [self.selectedItemsArray objectAtIndex: indexPath.row] ;
    cell.mytrash.hidden = YES;
    cell.item = item;
    cell.delegate = self;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     HWItem *item =  [self.selectedItemsArray objectAtIndex: indexPath.row];
    ViewItemViewController* vc = [[ViewItemViewController alloc] initWithItem:item];
    [self.navigationController pushViewController: vc animated: YES];
}





- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 12, 0, 12); // top, left, bottom, right
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Calculate cell frame
    CGFloat width = self.view.width;
    CGFloat widthForView = (width - 36) / 2;
    return CGSizeMake(widthForView, (widthForView * 488) / 291);
}


#pragma mark - 
#pragma mark Action



- (IBAction)imageTapped:(id)sender {
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender;
    
    NSInteger tag = recognizer.view.tag;
    
    if(tag == 4)
    {
        [[NetworkManager shared] likeDislikeWhithItemId:self.item.id
                                           successBlock:^{
                                               
                                               if (self.isLikeItem)
                                               {
                                                   self.isLikeItem = NO;
                                                   [self.smallImage4 setImage:[UIImage imageNamed:@"fav"]];
                                               } else {
                                                   
                                                   self.isLikeItem = YES;
                                                   [self.smallImage4 setImage:[UIImage imageNamed:@"Newstar"]];
                                               }
                                               
                                               POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                                               sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
                                               sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(10, 10)];
                                               sprintAnimation.springBounciness = 20.f;
                                               [self.smallImage4 pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
             
                                         } failureBlock:^(NSError *error) {
            
                                         
                                             NSLog(@"ерунда");
                                         }
        
        
         ];
        return;
    }
    if(tag >= self.imagesArray.count)
        return;
    // shift array
    NSArray* buff = [self.imagesArray subarrayWithRange: NSMakeRange(0, tag)];
    [self.imagesArray removeObjectsInRange: NSMakeRange(0, tag)];
    [self.imagesArray addObjectsFromArray: buff];
    [self setImages];
}

- (IBAction)buyButton:(id)sender {

    [self.navigationController pushViewController: [[BuyThisItemViewController alloc] initWithItem:self.item]  animated: YES];
}


- (IBAction)askButton:(id)sender {
    
    HWCommentViewController *commentVC = [[HWCommentViewController alloc]initWithItem:self.item];
    [self.navigationController pushViewController:commentVC animated:YES];
    
}

- (IBAction)transitionToProfile:(UIButton *)sender {
    
    HWProfileViewController *profileVC = [[HWProfileViewController alloc]initWithUserID:self.item.user_id];
    [self.navigationController pushViewController:profileVC animated:YES];
    
}


- (IBAction)sendToAFriendAction:(id)sender {
    
    self.sendToFrandActionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                       delegate: self
                                              cancelButtonTitle: @"Cancel"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: @"Share on Facebook", @"Share on Twitter", @"  Send an email", @"Send a text message", nil];
    
    
    [self.sendToFrandActionSheet showInView:self.view];
  
    
    
}


#pragma mark - 
#pragma mark FeedScreenCollectionViewCellDelegate

- (BOOL) willTransitionToUserProfileButton
{
    return YES;
}

- (void) transitionToProfileScreenWithUserId:(NSString*)userId
{
    HWProfileViewController *profileVC = [[HWProfileViewController alloc] initWithUserID:userId];
    
    [self.navigationController pushViewController:profileVC animated:YES];
}


#pragma mark -
#pragma mark MyItemCellDelegate

- (void) pressCommentButton:(UIButton*)sender withItem:(HWItem*)item
{
    HWCommentViewController *vc = [[HWCommentViewController alloc] initWithItem:item];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (void) pressLikeButton:(UIButton*) sender withItem:(HWItem*)item
{
    
    [[NetworkManager shared] likeDislikeWhithItemId:item.id
                                      successBlock:^{
    
    
                                      } failureBlock:^(NSError *error) {
    
    
                                      }];
    
}



#pragma mark -Action Sheet

- (void) actionSheet: (UIActionSheet*) actionSheet clickedButtonAtIndex: (NSInteger) buttonIndex
{
    
    if([actionSheet isEqual:self.editActionSheet])
    {
            if(buttonIndex == 1) return;
            
            if([[AppEngine shared].user.id isEqualToString:self.item.user.id])
            {
                
                SellAnItemViewController* vc = [[SellAnItemViewController alloc]initWithItem:self.item];
                [self.navigationController pushViewController:vc animated:NO];
                
            } else {
                
                
                
            }
    }
    
    else if ([actionSheet isEqual:self.sendToFrandActionSheet])
        
    {
        NSLog(@"%ld", (long)buttonIndex);
        switch (buttonIndex) {
            case 0:
                 //Share on Facebook
                
                [self shareOnSocialWithNameNet:SLServiceTypeFacebook];
                break;
            case 1:
                //Share on Twitter
                
                [self shareOnSocialWithNameNet:SLServiceTypeTwitter];
                break;
            case 2:
                // Send an email
                
                [self shareOnEmail];
                break;
            case 3:
                //Send a text message
                
                [self shareOnMessage];
                
                break;
                
            default:
                break;
        }
        
        
    }

}

#pragma mark -
#pragma mark Share

-(void)shareOnSocialWithNameNet:(NSString*)socialNetName
{
    NSString *socialName;
    
    if([socialNetName isEqualToString:SLServiceTypeFacebook])
    {
        socialName = @"Facebook";
    } else {
        
        socialName = @"Twitter";
    }
    
    if([SLComposeViewController isAvailableForServiceType:socialNetName]) //check if Facebook Account is linked
    {
        _mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        _mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:socialNetName]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        
        NSString *postText = [NSString stringWithFormat:@"%@ for sale on Hawkist.com. Only £%@",self.item.title, self.item.selling_price];
        
        
        [_mySLComposerSheet setInitialText:postText]; //the message you want to post
        
        UIImage *image = self.bigImage.image;
        
        [_mySLComposerSheet addImage:image];
        
     
        [self presentViewController:_mySLComposerSheet animated:YES completion:nil];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign in!" message:@"Please first Sign In!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [_mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        } //check if everything worked properly. Give out a message on the state.
        
        
     
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:socialName message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
     }];
    
}




-(void) shareOnEmail
{
        
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
       // [mailCont setSubject:@"Your email"];
        
        NSString *messageText = [NSString stringWithFormat:
                                 @"Hey, I found this %@ for sale on Hawkist.com. Thought you might be interested as it’s only £%@",self.item.title, self.item.selling_price];
        
        [mailCont setMessageBody:messageText isHTML:NO];
        
        UIImage *image = self.bigImage.image;
        NSData *data =  UIImageJPEGRepresentation (image, 1.0);
        
        [mailCont addAttachmentData:data
                          mimeType: @"image/jpeg"
                           fileName:self.item.title];
        
        [self presentViewController:mailCont animated:YES completion:nil];
        
    
    }
    
}

-(void) shareOnMessage
{
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"%@ for sale on Hawkist.com. Only £%@", self.item.title, self.item.selling_price];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
    
    
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    //handle any error
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}



    

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
        else if (result == MessageComposeResultSent)
            NSLog(@"Message sent");
            else
                NSLog(@"Message failed");
                
}



@end

