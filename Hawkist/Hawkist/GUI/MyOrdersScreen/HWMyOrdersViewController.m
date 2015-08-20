//
//  HWMyOrdersViewController.m
//  Hawkist
//
//  Created by User on 06.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWMyOrdersViewController.h"
#import "HWitemForOrdersCell.h"
#import "ViewItemViewController.h"
#import "NetworkManager.h"
#import "HWOrderItem.h"
#import "HWCommentViewController.h"
#import "HWLeaveFeedbackViewController.h"
#import "HWPaymentViewController.h"


@interface HWMyOrdersViewController () <HWitemForOrdersCellDelegate, NavigationViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *textField;



@property (nonatomic, strong) NetworkManager *networkManager;

@property (nonatomic, strong) NSArray *itemsArray;

@property (nonatomic, strong) UIAlertView* receivedAlert;
@property (nonatomic, strong) UIAlertView* hasIssueAlert;
@property (nonatomic, strong) HWOrderItem *selectedItem;

@end

@implementation HWMyOrdersViewController

#pragma mark - UIViewController

- (instancetype) init
{
    [self setupOrderArray];
    
    self = [super initWithNibName: @"HWMyOrdersView" bundle: nil];
    self.networkManager = [NetworkManager shared];
    
    
    if (self)
    {
        
        
    }
    return self;
}

-(void)setupOrderArray
{

    [[NetworkManager shared] getAllOrderItemWithSuccessBlock:^(NSArray *array) {
        
        self.itemsArray = array;
        
        [self.collectionView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
        
        
    }];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HWitemForOrdersCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    self.navigationView.delegate = self;
    self.navigationView.title.text = @"My Orders";
    
    [self.textField setValue:[UIColor colorWithRed:189.0/255.0 green:215.0/255.0 blue:211.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HWitemForOrdersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    HWOrderItem * orderItem = [self.itemsArray objectAtIndex:indexPath.row];
    
    
    cell.orderCellDelegate = self;
    cell.delegate = self;
    
    [cell setCellWithOrderItem:orderItem];
    
    return cell;
}


#pragma mark -
#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HWOrderItem * item = [self.itemsArray objectAtIndex:indexPath.row];
    
    ViewItemViewController *vc = [[ViewItemViewController alloc]initWithItem:item.item];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(11, 12, 15, 12); // top, left, bottom, right
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Make cell same width as application frame and 250 pixels tall.
    CGFloat width = self.view.width;
    CGFloat widthForView = (width - 36) / 2;
    
    return CGSizeMake(widthForView, ((widthForView * 488) / 291)+20);
}

#pragma mae


#pragma mark - 
#pragma mark HWitemForOrdersCellDelegate


- (void) feedbackAction:(UIButton*)sender witgUserID:(NSString*)userId withOrderId:(NSString*)orderId {
    
    HWLeaveFeedbackViewController *vc = [[HWLeaveFeedbackViewController alloc] initWithUserID:userId withOrderId:orderId];
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (void) receivedAction:(UIButton*)sender withItem:(HWOrderItem*)item
{

    self.selectedItem = item;
    
 self.receivedAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                message:@"Please confirm that you have received this item."
                              delegate:self
                     cancelButtonTitle:@"No"
                     otherButtonTitles:@"Yes", nil];
    [self.receivedAlert show];
}

-(void)tapRecevedWith:(HWOrderItem*)item
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.itemsArray indexOfObject:item] inSection:0];
    [self.networkManager orderReceivedWithOrderId:item.id
                                     successBlock:^{
                                         
                                         
                                         item.status = 1;
                                         [self reloadIndexPath:indexPath];
                                         
                                     } failureBlock:^(NSError *error) {
                                         
                                         [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                         
                                     }];

}



- (void) hasIssueAction:(UIButton*)sender withItem:(HWOrderItem*)item
{
      self.selectedItem = item;
    
    self.hasIssueAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                    message:@"Please confirm that you wish to report an issue with this item."
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [self.hasIssueAlert show];

}



-(void)tapHasIssuseWith:(HWOrderItem*)item with:(HWOrderIssuseReasons)orderIssue
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.itemsArray indexOfObject:item] inSection:0];
    [self.networkManager orderHasInIssueWithOrderId:item.id
                             withOrderIssuseReasons: orderIssue
                                       successBlock:^{
                                           item.status = 2;
                                           
                                           [self reloadIndexPath:indexPath];
                                           
                                       } failureBlock:^(NSError *error) {
                                           
                                           [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                       }];

}


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

-(void)reloadIndexPath:(NSIndexPath*)indexPath
{
    [self setupOrderArray];
    //[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark -
#pragma mark NavigationViewDelegate 


-(void) leftButtonClick
{
        NSArray *ar = self.navigationController.viewControllers;
    
    id vc = [ar objectAtIndex:ar.count-2];
    
    NSLog(@"%@",vc);
    
    if( [ vc isKindOfClass:[HWPaymentViewController class]]) {
        
        [self.navigationController popToViewController:[ar objectAtIndex:1] animated:YES];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    

    
}


-(void) rightButtonClick
{
    
}

#pragma mark - 
#pragma mark UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
     NSString* searchString = [textField.text stringByReplacingCharactersInRange: range withString:string];
    
    [self.networkManager searchInOrdersWithString:searchString
                                     successBlock:^(NSArray *array) {
                                         
                                         self.itemsArray = array ;
                                         [self.collectionView reloadData];
                                         
                                     } failureBlock:^(NSError *error) {
                                         [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                         
                                     }];
    
    
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
   if([self.receivedAlert isEqual:alertView])
   {
       switch (buttonIndex) {
           case 0:
               
               break;
           case 1:
               [self tapRecevedWith:self.selectedItem];
               
           default:
               break;
       }
   }
   else if ([self.hasIssueAlert isEqual:alertView])
   {
       
       switch (buttonIndex) {
           case 0:
               
               break;
           case 1:
                {
               
               UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:@"Why do you want to report this item?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:@"Item has not arrived",
                                        @"Item is not as described",
                                        @"Item is broken or not usable",nil];
               
               [aSheet showInView:self.view];

                }
           default:
               break;
              
       
       
      
       }
   }
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 3) return;
    
    [self tapHasIssuseWith:self.selectedItem with:buttonIndex];
    
}


@end
