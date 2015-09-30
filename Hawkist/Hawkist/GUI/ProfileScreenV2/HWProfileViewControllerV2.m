//
//  HWProfileViewControllerV2.m
//  Hawkist
//
//  Created by User on 26.09.15.
//  Copyright © 2015 TecSynt Solutions. All rights reserved.
//

#import "HWProfileViewControllerV2.h"

#import "HWProfileHeaderVeiw.h"

#import "NavigationVIew.h"

#import "HWButtonForSegment.h"

#import "FeedScreenCollectionViewCell.h"
#import "HWFollowInProfileCell.h"
#import "StarRatingControl.h"
#import "NetworkManager.h"
#import "HWUser.h"
#import "HWFollowUser.h"
#import "NSDate+NVTimeAgo.h"

#import "myItemCell.h"
#import "ViewItemViewController.h"
#import "HWCommentViewController.h"
#import "HWAboutUserViewController.h"
#import "UIImageView+Extensions.h"
#import "HWFeedBackViewController.h"

#import "HWZendesk.h"


#import "HWItem.h"

#import "HWFollowInProfileColViewCell.h"







@interface HWProfileViewControllerV2 () <NavigationViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, StarRatingDelegate, UIAlertViewDelegate, HWFollowInProfileCellDelegate, MyItemCellDelegate,UIActionSheetDelegate, HWProfileHeaderViewDelegate>


@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;


@property (nonatomic, strong) HWUser *user;

@property (nonatomic, strong) NSArray* selectedSegmentArray;
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) NSArray *followingArray;
@property (nonatomic, strong) NSArray *followersArray;
@property (nonatomic, strong) NSArray *wishListArray;

@property (nonatomic, strong) NetworkManager *networkManager;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, assign) NSInteger selectedArrayWithData;
@property (nonatomic, strong) id lastPressSegmentButton;



@property (nonatomic, strong) UIActionSheet *reportBlockActionSheet;
@property (nonatomic, strong) UIActionSheet *resonReportActionSheet;

@property (nonatomic, assign) NSInteger selectedReasonReport;


@property (nonatomic, assign) BOOL isBlocked;
@property (nonatomic, assign) BOOL nePOnatnoChto;

@property (nonatomic, weak) IBOutlet UIImageView *frontGround;

@property (nonatomic, strong) UIAlertView *blockAlert;

@property (nonatomic, strong) HWProfileHeaderVeiw *header;

@end




typedef NS_ENUM(NSInteger, HWReasonReport) {
    
    HWReasonReportAbusiveBehaviour = 0,
    HWReasonReportInappropriateContent = 1,
    HWReasonReportImpersonationOrHateAccount = 2,
    HWReasonReportSellingFakeItems = 3,
    HWReasonReportUnderagedAccount = 4
};

  
@implementation HWProfileViewControllerV2

#pragma mark-
#pragma mark Lifecycle

- (instancetype) initWithUser:(HWUser*)user {
    
    
    self = [super initWithNibName: @"HWProfileViewControllerV2" bundle: nil];
    
    if(self) {
        
        self.networkManager = [NetworkManager shared];
        
        self.userId = user.id;
        self.user = user;
        
        [self itemsWithUserId:self.userId];
        
    }
    
    return self;
}



- (instancetype) init
{
    self = [self initWithUser:nil];
    
    if(self)
    {
        
    }
    
    return self;
}



- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   // [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    //[self showHud];
    
//    [UIView animateWithDuration:15
//                     animations:^{
//                         
//                         
//                     } completion:^(BOOL finished) {
//                         
//                         [self hideHud];
//                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//                     }];
 
    [self.collectionView reloadData];
    self.isInternetConnectionAlertShowed = NO;

    
  if (!self.nePOnatnoChto) return;
    
    if(!self.lastPressSegmentButton   ){
        
       // [self segmentButtonAction:self.itemsButton];
        
    } else {
        
       
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    [self itemsWithUserId:self.userId];
   //[self showHud];
    
    self.navigationView.delegate = self;
    self.navigationView.title.text = @"Profile";
    
    NSString *userid = [AppEngine shared].user.id;
    NSString *userID = self.userId;
    
    if(![userID isEqual:userid]) {
        
        [self.navigationView.rightButtonOutlet setImage:[UIImage imageNamed:@"points"] forState:UIControlStateNormal];
    }

    self.selectedArrayWithData = 0;
    
    
}

-(void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self hideHud];
}

#pragma mark -
#pragma mark commonInit


-(void)commonInit
{
    self.isBlocked = [self.user.blocked boolValue];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCollection"]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"myItemCell" bundle:nil] forCellWithReuseIdentifier:@"collectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HWFollowInProfileColViewCell" bundle:nil] forCellWithReuseIdentifier:@"follow"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HWProfileHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
}



#pragma mark -
#pragma mark set/get



-(void)itemsWithUserId:(NSString*)userId {
    
    
    [self.networkManager getItemsByUserId:userId
                             successBlock:^(NSArray *arrayWithItems) {
                                 
                                 self.itemsArray = arrayWithItems;
                                 [self followingWithUserId:userId];
                                 
                             } failureBlock:^(NSError *error) {
                                 
                                 [self hideHud];
                                 //                                 [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                             }];
    
    
}

- (void) followingWithUserId:(NSString*)userId
{
    
    [self.networkManager getFollowingWithUserId:userId
                                   successBlock:^(NSArray *followingArray) {
                                       
                                       self.followingArray = followingArray;
                                       [self followersWithUserId:userId];
                                       
                                   } failureBlock:^(NSError *error) {
                                       
                                       //                                       [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                   }];
    
}

-(void) followersWithUserId:(NSString*)userId {
    
    NSString *userID = userId;
    if (!userId) {
        
        userID = self.userId;
    }
    
    [self.networkManager getFollowersWithUserId:userID
                                   successBlock:^(NSArray *followingArray) {
                                       
                                       
                                       self.followersArray = followingArray;
                                       
                                       if(!userId) {
                                           return;
                                       }
                                       [self wishListWithUserId:userId];
                                       
                                   } failureBlock:^(NSError *error) {
                                       
                                       //                                       [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                   }];
    
    
}


- (void)wishListWithUserId:(NSString*)userId {
    
    
    [self.networkManager getWishlistWithUserId:userId
                                  successBlock:^(NSArray *wishlistArray) {
                                      
                                      self.wishListArray = wishlistArray;
                                      [self.header updateSelectedButtonIndex: self.selectedArrayWithData ];
                                      
                                  } failureBlock:^(NSError *error) {
                                      
                                      //                                      [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                  }];
    
    
    
}


    



#pragma mark -
#pragma mark Actions

- (IBAction)feedbackAction:(UIButton*)sender {
    
    sender.enabled = NO;
    [self showHud];
    
    HWFeedBackViewController *vc = [[HWFeedBackViewController alloc] initWithUserID:self.userId];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark -
#pragma mark NavigationDelegate


-(void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) rightButtonClick
{
    if(![self.user.id isEqualToString:[AppEngine shared].user.id]) {
        
        NSString *str = self.isBlocked? @"Unblock" : @"Block";
        
        self.reportBlockActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"Report",str, nil];
        
        
        [self.reportBlockActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self.selectedSegmentArray objectAtIndex:indexPath.row];
    
    if ([data isKindOfClass:[HWItem class]])
    {
        myItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.item = data;
        cell.mytrash.hidden = YES;
        return cell;
       
    }
    
    if ([data isKindOfClass:[HWFollowUser class]])
    {
        HWFollowInProfileColViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"follow" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setCellWithFollowUser:data];
        return cell;
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedSegmentArray.count;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        
        HWProfileHeaderVeiw *header =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                           withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.delegate = self;
        [header updateWithUser:self.user];
        [header updateWithArrayItems:self.itemsArray
                       withFollowing:self.followingArray
                       withFollowers:self.followersArray
                        withWishlist:self.wishListArray];
        
        self.header = header;
        header.feedbackBut.enabled = YES;
        
        
        return header;
    }
    else  if (kind == UICollectionElementKindSectionFooter)
    {
        
        
        return nil;
        
    }
    return nil;
}


- (void) setSelectedSegmentArray:(NSArray *)selectedSegmentArray
{
    _selectedSegmentArray = selectedSegmentArray;
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}




#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    id data = self.selectedSegmentArray.count ? [self.selectedSegmentArray objectAtIndex:section] : nil;
    if ([data isKindOfClass:[HWItem class]])
    {
       return 10;
    }
    else if ([data isKindOfClass:[HWFollowUser class]])
    {
         return 1;
    }
    
    return 0;
   
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat width = self.view.bounds.size.width  ;
    CGFloat height = [HWProfileHeaderVeiw heightHeaderView];
    
    return CGSizeMake(width, height);
}



////


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id data = self.selectedSegmentArray.count ? [self.selectedSegmentArray objectAtIndex:indexPath.row] : nil;
    if ([data isKindOfClass:[HWItem class]])
    {
        ViewItemViewController* vc = [[ViewItemViewController alloc] initWithItem:data];
        [self.navigationController pushViewController: vc animated: YES];
    }
    
}


- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(11, 12, 15, 12); // top, left, bottom, right
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.view.width;
    id data = [self.selectedSegmentArray objectAtIndex:indexPath.row];
    
    if ([data isKindOfClass:[HWItem class]])
    {
        
        CGFloat widthForView = (width - 36) / 2;
        
        return CGSizeMake(widthForView, ((widthForView * 488) / 291)-5);
    }
    else
    {
        return CGSizeMake(width, 80);
    }
    
    
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if([actionSheet isEqual:self.reportBlockActionSheet])
    {
        if(buttonIndex == 2) return;
        
        switch (buttonIndex) {
            case 0:
                
                [self setupReportActionSheet];
                break;
            case 1:
                
                [self blockUnblok];
                NSLog(@"Block");
                
                break;
            default:
                break;
        }
        
        
        
        
    }
    
    
    else if ([actionSheet isEqual:self.resonReportActionSheet]) {
        
        if (buttonIndex == 5) return;
        [[[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                    message:@"Please confirm you want to report this user."
                                   delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK", nil] show];
        
        
        self.selectedReasonReport = buttonIndex;
        
    }
}


-(void)reportWithReason:(NSString*)reason
         withReasonCode:(HWReasonReport)reasonCode{
    
    [self.networkManager reportUserWithUserId:self.userId
                             withReportReason:reasonCode
                                 successBlock:^{
                                     
                                     [self createTicketWithDescription:reason];
                                     
                                 } failureBlock:^(NSError *error) {
                                     
                                     [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                 }];
    
}

-(void) createTicketWithDescription:(NSString*)descript {
    
    NSString *str = [NSString stringWithFormat:@"Reason: %@\nUser: %@\nUserID: %@",descript, self.user.username, self.userId];
    
    [[HWZendesk shared] createTicketWithSubject:@"User reported"
                                withDescription:str];
    
}

-(void) blockUnblok {
    
    NSString *mes;
    
    
    if(self.isBlocked) {
        
        mes = @"You have been unblocked by this user.";
    } else {
        
        mes = @"You have been blocked by this user.";
    }
    
    
    
    self.blockAlert =   [[UIAlertView alloc] initWithTitle:@"Cannot Complete Action"
                                                   message:mes
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK", nil];
    
    [self.blockAlert show];
    
    
}
-(void) setupReportActionSheet {
    
    self.resonReportActionSheet = [[UIActionSheet alloc] initWithTitle:@"Why do you want to report this user?"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles: @"Abusive behaviour",
                                   @"Inappropriate content",
                                   @"Impersonation or hate account",
                                   @"Selling fake items",
                                   @"Underaged account", nil];
    [self.resonReportActionSheet showInView:self.view];
}

#pragma mark -
#pragma mark UIAlertViewDelegate



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.blockAlert]) {
        
        if(buttonIndex == 0) return;
        
        if(self.isBlocked) {
            [self.networkManager unblockUserWithId:self.userId
                                      successBlock:^{
                                          
                                          self.isBlocked = NO;
                                      } failureBlock:^(NSError *error) {
                                          
                                          [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                      }];
        } else {
            
            [self.networkManager blockUserWithId:self.userId
                                    successBlock:^{
                                        
                                        self.isBlocked = YES;
                                    } failureBlock:^(NSError *error) {
                                        
                                        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                    }];
        }
        
        
    } else {
        
        
        
        if(buttonIndex == 0) return;
        
        switch (self.selectedReasonReport) {
            case 0:
                
                [self reportWithReason:@"Abusive behaviour" withReasonCode:HWReasonReportAbusiveBehaviour];
                NSLog(@"Abusive behaviour");
                break;
            case 1:
                
                [self reportWithReason:@"Inappropriate content" withReasonCode:HWReasonReportInappropriateContent];
                NSLog(@"Inappropriate content");
                break;
            case 2:
                
                [self reportWithReason:@"Impersonation or hate account" withReasonCode:HWReasonReportImpersonationOrHateAccount];
                NSLog(@"Impersonation or hate account");
                break;
            case 3:
                
                [self reportWithReason:@"Selling fake items" withReasonCode:HWReasonReportSellingFakeItems];
                NSLog(@"Selling fake items");
                break;
            case 4:
                
                [self reportWithReason:@"Underaged account" withReasonCode:HWReasonReportUnderagedAccount];
                NSLog(@"Underaged account");
                break;
                
                
            default:
                break;
        }
        
    }
}

#pragma mark -
#pragma mark HWFollowInProfileCellDelegate

- (void) transitionToUserProfileWithUserId:(NSString*)userId
{
    
    [self.networkManager getUserProfileWithUserID:userId
                                     successBlock:^(HWUser *user) {
                                         
                                         if(!user) {
                                             [self hideHud];
                                             [[[UIAlertView alloc] initWithTitle:@"Cannot Complete Action"
                                                                         message:@"You have been blocked by this user."
                                                                        delegate:nil
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles: nil]show];
                                             return;
                                         }
                                         
                                         HWProfileViewControllerV2 *profileVC = [[HWProfileViewControllerV2 alloc]initWithUser:user];
                                           [self.navigationController pushViewController:profileVC animated:YES];

                                         
                                     } failureBlock:^(NSError *error) {
                                         
                                         
                                     }];
 
}


- (void) followUnfollowButton:(UIButton*)button follow:(BOOL)isFollow forUser:(HWFollowUser*)user
{
    if(!isFollow){
        
        [ [NetworkManager shared] unfollowWithUserId:user.id successBlock:^{
            
            [UIView performWithoutAnimation:^{
                [button setTitle:@"  FOLLOW  "  forState:UIControlStateNormal];
                [button layoutIfNeeded];
               
            }];
             user.follow = @"0";
            
            
            
            
            button.backgroundColor = [UIColor colorWithRed:48./255. green:173./255. blue:148./255. alpha:1];
            
        } failureBlock:^(NSError *error) {
            
        }];
    } else {
        
        [ [NetworkManager shared] followWithUserId:user.id successBlock:^{
            
            
            [UIView performWithoutAnimation:^{
                [button setTitle:@" UNFOLLOW "  forState:UIControlStateNormal];
                [button layoutIfNeeded];
               
            }];
             user.follow = @"1";
            
            
            button.backgroundColor = [UIColor colorWithRed:97./255. green:97./255. blue:97./255. alpha:1];
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

- (BOOL) hideFollowUnfollowButtonForUserId:(NSString*)userId
{
    
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] objectForKey:kUSER_ID];
    
    return  ([currentUserId isEqualToString:userId]);
}




#pragma mark -
#pragma mark StarRatingDelegate

- (BOOL) enabledTouch
{
    return NO;
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

#pragma mark - HWProfileHeaderViewDelegate

- (void)itemsAction:(HWButtonForSegment *)sender
{
    self.selectedSegmentArray = self.itemsArray;
    self.selectedArrayWithData = 0;
    [self.collectionView reloadData];

}

- (void)followingAction:(HWButtonForSegment *)sender
{
    self.selectedSegmentArray = self.followingArray;
    self.selectedArrayWithData = 1;
    [self.collectionView reloadData];

}
- (void)followersAction:(HWButtonForSegment *)sender
{
    self.selectedSegmentArray = self.followersArray;
    self.selectedArrayWithData = 2;
    [self.collectionView reloadData];


}
- (void)wishlistAction:(HWButtonForSegment *)sender
{
    self.selectedSegmentArray = self.wishListArray;
    self.selectedArrayWithData = 3;
    [self.collectionView reloadData];


}

- (void)followUnfollowAction:(HWButtonForSegment *)sender withIsFollow:(BOOL)isFollow
{
    sender.enabled = NO;
    if (!isFollow)
    {
        
        [ self.networkManager followWithUserId:self.user.id successBlock:^{
            
            sender.enabled = YES;

        } failureBlock:^(NSError *error) {
            
            sender.enabled = YES;

        }];
        
    } else {
        
        [self.networkManager unfollowWithUserId:self.user.id successBlock:^{
           
            sender.enabled = YES;

        } failureBlock:^(NSError *error) {
            
            sender.enabled = YES;

        }];
        
    }
    [self followersWithUserId:nil];
    //   [self setFollowersArrayWithUserId:self.user.id];
    

}

- (void)aboutMeAction:(HWButtonForSegment *)sender
{
    HWAboutUserViewController *vc = [[HWAboutUserViewController alloc]initWithUserId:self.userId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)feedbackButton:(UIButton *)sender
{
    sender.enabled = NO;
    [self showHud];
    
    HWFeedBackViewController *vc = [[HWFeedBackViewController alloc] initWithUserID:self.userId];
    [self.navigationController pushViewController:vc animated:YES];

    
}



@end
