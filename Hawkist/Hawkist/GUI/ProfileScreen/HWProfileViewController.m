//
//  HWProfileViewController.m
//  Hawkist
//
//  Created by User on 14.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWProfileViewController1.h"
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


@interface HWProfileViewController () <NavigationViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, StarRatingDelegate, UIAlertViewDelegate, HWFollowInProfileCellDelegate, MyItemCellDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;

@property (weak, nonatomic) IBOutlet StarRatingControl *starRatingView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSeenLabel;
@property (weak, nonatomic) IBOutlet UILabel *responsTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (weak, nonatomic) IBOutlet UIButton *followUnfollowButton;

@property (strong, nonatomic) IBOutletCollection(HWButtonForSegment) NSArray *buttonSegmentCollection;
@property (weak, nonatomic) IBOutlet HWButtonForSegment *itemsButton;
@property (weak, nonatomic) IBOutlet HWButtonForSegment *followingButton;
@property (weak, nonatomic) IBOutlet HWButtonForSegment *followersButton;
@property (weak, nonatomic) IBOutlet HWButtonForSegment *wishlistButton;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;

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
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic, strong) UIActionSheet *reportBlockActionSheet;
@property (nonatomic, strong) UIActionSheet *resonReportActionSheet;

@property (nonatomic, assign) NSInteger selectedReasonReport;


@property (nonatomic, assign) BOOL isBlocked;

@property (nonatomic, weak) IBOutlet UIButton *feedbackBut;

@property (nonatomic, assign) BOOL nePOnatnoChto;

@property (nonatomic, weak) IBOutlet UIImageView *frontGround;

@property (nonatomic, strong) UIAlertView *blockAlert;

@end




typedef NS_ENUM(NSInteger, HWReasonReport) {
    
    HWReasonReportAbusiveBehaviour = 0,
    HWReasonReportInappropriateContent = 1,
    HWReasonReportImpersonationOrHateAccount = 2,
    HWReasonReportSellingFakeItems = 3,
    HWReasonReportUnderagedAccount = 4
};



typedef NS_ENUM (NSInteger, HWArrayWithDataForSegmentView)
{
    HWArrayWithItems = 10,
    HWArrayWithFollowers = 20,
    HWArrayWithFollowing = 30,
    HWArrayWithWishlist = 40
};


@implementation HWProfileViewController

#pragma mark-
#pragma mark Lifecycle

-(instancetype) initWithUser:(HWUser*)user {
    
    
    self = [super initWithNibName: @"HWProfileViewController" bundle: nil];
   
    if(self) {
    
       self.networkManager = [NetworkManager shared];
        
        self.userId = user.id;
        self.user = user;
        
        [self OOOItemsWithUserId:self.userId];

    }
    
    return self;
}

- (instancetype) initWithUserID:(NSString *)userID
{
    self = [super initWithNibName: @"HWProfileViewController" bundle: nil];
     self.frontGround.hidden = NO;
    if(self)
    {
        self.networkManager = [NetworkManager shared];
        self.userId = userID;
       // [self showHud];
        
        [self.networkManager getUserProfileWithUserID:userID
                                            successBlock:^(HWUser *user) {
                                                
                                                
                                                if(!user) {
                                                    
                                                   // self.view.hidden = YES;
                                                    
                                                   [[[UIAlertView alloc] initWithTitle:@"Cannot Complete Action"
                                                                               message:@"You have been blocked by this user."
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles: nil]show];
                                                    
                                                    [self.navigationController popViewControllerAnimated:NO];
                                                    [self hideHud];
                                                    
                                                    
                                                    
                                                } else {
                                                
                                                      self.user = user;
                                                      [self updateUser];
                                                      [self OOOItemsWithUserId:user.id];
                                                    
                                                    
                                                    self.nePOnatnoChto = YES;
                                                }
                                                
                                            } failureBlock:^(NSError *error) {
 
 
                                        }];
      
    
    }
    
    return self;
}

- (instancetype) init
{
    self = [self initWithUserID:nil];
    
    if(self)
    {
    
    }
    
    return self;
}



- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [self showHud];
    
    [UIView animateWithDuration:15
                     animations:^{
                         
                         
                     } completion:^(BOOL finished) {
                         
                         [self hideHud];
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }];
    
     self.feedbackBut.enabled = YES;
     self.isInternetConnectionAlertShowed = NO;
    
    
    if (!self.nePOnatnoChto) return;
    
    if(!self.lastPressSegmentButton   ){
        
        [self segmentButtonAction:self.itemsButton];
        
    } else {
    
        [self segmentButtonAction:self.lastPressSegmentButton];
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    [self updateUser];
    [self OOOItemsWithUserId:self.userId];

    
    [self showHud];
    self.navigationView.delegate = self;
    self.navigationView.title.text = @"Profile";
    
    NSString *userid = [AppEngine shared].user.id;
    
    NSString *userID = self.userId;
    
    if(![userID isEqual:userid]) {
        
        [self.navigationView.rightButtonOutlet setImage:[UIImage imageNamed:@"points"] forState:UIControlStateNormal];
    }
 
    
        
        
      [self updateUser];
    
  [self segmentButtonAction:self.itemsButton];

   
   
}

-(void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    
    
    [self hideHud];
}

#pragma mark -
#pragma mark commonInit


-(void)commonInit
{
    
    CGFloat widthScreen = [UIScreen mainScreen].bounds.size.width;
    CGFloat yOriginForTableAndCollection = self.segmentView.frame.origin.y + self.segmentView.frame.size.height - 10;
    
    
    // init tableView
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, yOriginForTableAndCollection, widthScreen, 200) style:UITableViewStylePlain];
    [self.scrollView addSubview:self.tableView];
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HWFollowInProfileCell" bundle:nil] forCellReuseIdentifier:@"tableViewCell"];
    
    
    // init tableView
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, yOriginForTableAndCollection, widthScreen, 500) collectionViewLayout:layout];
    [self.scrollView addSubview:self.collectionView];
    self.collectionView.hidden = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCollection"]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"myItemCell" bundle:nil] forCellWithReuseIdentifier:@"collectionViewCell"];
 
    self.starRatingView.delegate = self;
    
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] objectForKey:kUSER_ID];
    if([currentUserId isEqualToString:self.userId])
    {
      
        self.followUnfollowButton.hidden = YES;
    }
   
}



- (void) updateUser
{
    self.frontGround.hidden = YES;
    [self hideHud];
    
    if([self.user.following integerValue] == 1)
    {
        [self.followUnfollowButton setTitle:@" UNFOLLOW " forState:UIControlStateNormal];
        self.followUnfollowButton.backgroundColor = [UIColor colorWithRed:97./255. green:97./255. blue:97./255. alpha:1];
    }
    [self.avatarView setImageWithUrl:[NSURL URLWithString: self.user.avatar]
                       withIndicator:self.indicator];
    
  
    self.userNameLabel.text = self.user.username;
    if(self.user.city)
    {
        self.locationLabel.text =  [NSString stringWithFormat:@"%@, United Kingdom  ", self.user.city];
    }
    self.starRatingView.rating = [self.user.rating integerValue];
    self.ratingLabel.text = [NSString stringWithFormat:@"%@ (%@ reviews)",self.user.rating,self.user.review];
    self.salesLabel.text = self.user.number_of_sales;
    NSString *aboutTitle = [NSString stringWithFormat:@"    ABOUT %@",self.user.username.uppercaseString];
    [self.aboutButton setTitle:aboutTitle forState:UIControlStateNormal];
    
    NSDate *lastActivityDate = [NSDate dateFromServerFormatString:self.user.last_activity];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a MMM dd, yyyy"];
    
    self.isBlocked = [self.user.blocked boolValue];
    
    self.lastSeenLabel.text = [dateFormatter stringFromDate:lastActivityDate];
    
    NSInteger time = [self.user.response_time integerValue];
    
    NSUInteger d = time / (3600 *24);
    NSUInteger h = (time - d*(3600 *24)) / 3600;
    NSUInteger m = (time / 60) % 60;
    NSString *strTime;
    
    
    
    if(d || d>=3) {
        
        strTime = d>=3 ? @"72 hours+" : [NSString stringWithFormat:@"%lu day %lu hrs", (unsigned long)d, (unsigned long)h];

    } else if(h) {
        
        strTime =  [NSString stringWithFormat:@"%lu hrs %lu min", (unsigned long)h, (unsigned long)m];
    } else  {
        
        strTime =  [NSString stringWithFormat:@"%lu min", (unsigned long)m];
    }
    
    
    self.responsTimeLabel.text = strTime;
}

 
- (void) setupSegmentButtonsConfig
{
    self.itemsButton.titleButton.text = @"ITEMS";
    self.itemsButton.count.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.itemsArray.count];
    
    self.followersButton.titleButton.text = @"FOLLOWERS";
    self.followersButton.count.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.followersArray.count];
    
    self.followingButton.titleButton.text = @"FOLLOWING";
    self.followingButton.count.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.followingArray.count];
    
    self.wishlistButton.titleButton.text = @"WISHLIST";
    self.wishlistButton.count.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.wishListArray.count];
    
    
}



#pragma mark -
#pragma mark set/get

 



-(void)OOOItemsWithUserId:(NSString*)userId {
    
    
    [self.networkManager getItemsByUserId:userId
                             successBlock:^(NSArray *arrayWithItems) {
                                 
                                 self.itemsArray = arrayWithItems;
                                 [self hideHud];
                                 
                                 [self OOOfollowingWithUserId:userId];
                                 
                                 
                             } failureBlock:^(NSError *error) {
                                 
                                 [self hideHud];
//                                 [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                             }];

    
}

- (void) OOOfollowingWithUserId:(NSString*)userId
{
    
    [self.networkManager getFollowingWithUserId:userId
                                   successBlock:^(NSArray *followingArray) {
                                       
                                       self.followingArray = followingArray;
                                       
                                       [self OOOfollowersWithUserId:userId];
                                       
                                   } failureBlock:^(NSError *error) {
                                       
//                                       [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                   }];
    
}

-(void) OOOfollowersWithUserId:(NSString*)userId {
    
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
                                       [self OOOWishListWithUserId:userId];
                                       
                                   } failureBlock:^(NSError *error) {
                                       
//                                       [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                   }];

    
}


-(void)OOOWishListWithUserId:(NSString*)userId {
    
    
    [self.networkManager getWishlistWithUserId:userId
                                  successBlock:^(NSArray *wishlistArray) {
                                      
                                      self.wishListArray = wishlistArray;
                                      
                                      [self selectedButConfig];
                                      
                                      
                                  } failureBlock:^(NSError *error) {
                                      
//                                      [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                  }];

    
    
}

-(void) selectedButConfig {
    
    
    
    switch (self.selectedArrayWithData) {
        case HWArrayWithItems:
            
            [self reloadDataIfSuccessBlockForTable:NO withDataArray:self.itemsArray];
            
            break;
        case HWArrayWithFollowing:
            
            [self reloadDataIfSuccessBlockForTable:YES withDataArray:self.followingArray];
            
            break;
        case HWArrayWithFollowers:
            
            [self reloadDataIfSuccessBlockForTable:YES withDataArray:self.followersArray];
            
            break;
        case HWArrayWithWishlist:
            
            
            [self reloadDataIfSuccessBlockForTable:NO withDataArray:self.wishListArray];
            
            
            break;
        default:
            break;
    }
    

    
}


- (void) setItemsArrayWithUserId:(NSString*)userId
{
    
    [self.networkManager getItemsByUserId:userId
                             successBlock:^(NSArray *arrayWithItems) {
                                 
                                 self.itemsArray = arrayWithItems;
                                 [self hideHud];
                                 
                                 if (self.selectedArrayWithData == HWArrayWithItems)
                                 {
                                     [self reloadDataIfSuccessBlockForTable:NO withDataArray:arrayWithItems];
                                 }
                                 
                                 
                             } failureBlock:^(NSError *error) {
                                 
                                 [self hideHud];
                                 [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                             }];
    
}
//// following
//
//- (void) setFollowingArrayWithUserId:(NSString*)userId
//{
//    [self.networkManager getFollowingWithUserId:userId
//                                   successBlock:^(NSArray *followingArray) {
//                                       
//                                       self.followingArray = followingArray;
//                                     
//                                       if (self.selectedArrayWithData == HWArrayWithFollowing)
//                                       {
//                                           [self reloadDataIfSuccessBlockForTable:YES withDataArray:followingArray];
//                                       }
//
//                                   } failureBlock:^(NSError *error) {
//                                       
//                                        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
//                                   }];
//}
//
////followers
//
//- (void) setFollowersArrayWithUserId:(NSString*)userId
//{
//    [self.networkManager getFollowersWithUserId:userId
//                                   successBlock:^(NSArray *followersArray) {
//                                       
//                                      self.followersArray = followersArray;
//                                       
//                                       if (self.selectedArrayWithData == HWArrayWithFollowers)
//                                       {
//                                           [self reloadDataIfSuccessBlockForTable:YES withDataArray:followersArray];
//                                       }
//                                       
//                                } failureBlock:^(NSError *error) {
//                                    
//                                   [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
//                                   }];
//    
//}
//
//// wishlist
//
//- (void) setWishlistArrayWithUsetId:(NSString*)userId
//{
//    [self.networkManager getWishlistWithUserId:userId
//                                  successBlock:^(NSArray *wishlistArray) {
//                                      
//                                      self.wishListArray = wishlistArray;
//                                      
//                                      if (self.selectedArrayWithData == HWArrayWithWishlist)
//                                      {
//                                          [self reloadDataIfSuccessBlockForTable:NO withDataArray:wishlistArray];
//                                      }
//                                      
//                                  } failureBlock:^(NSError *error) {
//                                      
//                                       [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
//                                  }];
//}
//

#pragma mark -
#pragma mark Actions

- (IBAction)feedbackAction:(UIButton*)sender {
    
    sender.enabled = NO;
    [self showHud];
    
    HWFeedBackViewController *vc = [[HWFeedBackViewController alloc] initWithUserID:self.userId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)aboutAction:(UIButton *)sender
{
    HWAboutUserViewController *vc = [[HWAboutUserViewController alloc] initWithUserId:self.user.id];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)followUnfollowAction:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"  FOLLOW  "])
    {

        [ self.networkManager followWithUserId:self.user.id successBlock:^{
        
            
            [sender setTitle:@" UNFOLLOW " forState:UIControlStateNormal];
            sender.backgroundColor = [UIColor colorWithRed:97./255. green:97./255. blue:97./255. alpha:1];

            
            
        } failureBlock:^(NSError *error) {
            
        }];
        
    } else {
        
            [self.networkManager unfollowWithUserId:self.user.id successBlock:^{
            [sender setTitle:@"  FOLLOW  " forState:UIControlStateNormal];
            sender.backgroundColor = [UIColor colorWithRed:55./255. green:185./255. blue:165./255. alpha:1];
            
        } failureBlock:^(NSError *error) {
            
            
        }];
        
    }
    [self OOOfollowersWithUserId:nil];
 //   [self setFollowersArrayWithUserId:self.user.id];
    
}

- (IBAction)segmentButtonAction:(HWButtonForSegment *)sender {
    
    
    for (HWButtonForSegment *button in self.buttonSegmentCollection)
    {
        button.selectedImage.hidden = YES;
    }
    
    self.lastPressSegmentButton = sender;
    sender.selectedImage.hidden = NO;
    
    switch (sender.tag) {
        case 1:
            self.selectedArrayWithData = HWArrayWithItems;
            
            break;
        case 2:
            
            self.selectedArrayWithData = HWArrayWithFollowing;
            
            break;
        case 3:
            
            self.selectedArrayWithData = HWArrayWithFollowers;
            
            break;
        case 4:
            
            self.selectedArrayWithData  = HWArrayWithWishlist;
            
            break;
        default:
            break;
    }
    
    [self selectedButConfig];
  //  [self OOOItemsWithUserId:self.userId];
    
    
    
//
//    
//    [self setItemsArrayWithUserId:self.userId];
//    [self setFollowersArrayWithUserId:self.userId];
//    [self setFollowingArrayWithUserId:self.userId];
//    [self setWishlistArrayWithUsetId:self.userId];
    
}


#pragma mark -
#pragma mark reloadData

- (void) reloadDataIfSuccessBlockForTable:(BOOL)isTableView withDataArray:(NSArray *)array
{
    self.selectedSegmentArray = array;
    [self setupSegmentButtonsConfig];
    [self reloadTableAndCollectionViewWithData:self.selectedSegmentArray forTableView:isTableView];
    
}

- (void) reloadTableAndCollectionViewWithData:(NSArray*)dataArray forTableView:(BOOL)forTableView
{
    
    CGFloat yOriginForTableAndCollection = self.segmentView.frame.origin.y + self.segmentView.frame.size.height;
    
    self.selectedSegmentArray = dataArray;
    CGFloat heightForCollectionOrTable = 0;
    
    if(!forTableView)
    {
        self.tableView.hidden = YES;
        
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
        heightForCollectionOrTable = self.collectionView.contentSize.height;
        
        CGRect frameCollection = self.collectionView.bounds;
        
        frameCollection.origin.y = yOriginForTableAndCollection;
        frameCollection.size.height = self.collectionView.contentSize.height;
        self.collectionView.frame = frameCollection;
        
    }
    else
    {
        self.collectionView.hidden = YES;
        self.tableView.hidden = NO;
        
        [self.tableView reloadData];
 
        [self.tableView layoutIfNeeded];
        heightForCollectionOrTable = self.tableView.contentSize.height;
        
        CGRect frameTable = self.tableView.bounds;
        frameTable.size.height = self.tableView.contentSize.height;
        frameTable.origin.y = yOriginForTableAndCollection;
        self.tableView.frame = frameTable;
        
    }
    
    [self setupHeightScrollView:heightForCollectionOrTable];
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
}


- (void) setupHeightScrollView:(CGFloat) height
{
    CGFloat heightForScrollView = self.segmentView.frame.origin.y + self.segmentView.frame.size.height + height;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, heightForScrollView)];
    
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


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selectedSegmentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if([[self.selectedSegmentArray objectAtIndex:indexPath.row] isKindOfClass:[HWItem class]]) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ddd"];
        return cell;
        
    }
    
    HWFollowInProfileCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
      cell.delegate = self;
    
    [cell.followButton setTitle:@" " forState:UIControlStateNormal];
    
        [cell setCellWithFollowUser:[self.selectedSegmentArray objectAtIndex:indexPath.row]];
  
    
  
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.selectedSegmentArray objectAtIndex:indexPath.row] isKindOfClass:[HWItem class]]) {
        
        
        return ;
    }
    
    HWFollowInProfileCell *cell1 = (id)cell;
    
  if(!cell1.isFollow)
  {
      [UIView performWithoutAnimation:^{
          [cell1.followButton setTitle:@"  FOLLOW  "  forState:UIControlStateNormal];
          [cell1.followButton layoutIfNeeded];
      }];
  } else {
      
      [UIView performWithoutAnimation:^{
          [cell1.followButton setTitle:@" UNFOLLOW "  forState:UIControlStateNormal];
          [cell1.followButton layoutIfNeeded];

       }];
      
  }
       
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 400)];
    
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        view.backgroundColor = [UIColor redColor];
        [reusableview addSubview: view];
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        
        reusableview;
    }
    
    return reusableview;
}


#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.selectedSegmentArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    myItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.item = [self.selectedSegmentArray objectAtIndex:indexPath.row];
    cell.mytrash.hidden = YES;
    return cell;
}


#pragma mark -
#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HWItem *item = [self.selectedSegmentArray objectAtIndex:indexPath.row];
    ViewItemViewController* vc = [[ViewItemViewController alloc] initWithItem:item];
    [self.navigationController pushViewController: vc animated: YES];
    
    self.selectedSegmentArray = nil;
    
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
 
    return CGSizeMake(widthForView, ((widthForView * 488) / 291)-5);
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
    HWProfileViewController *profileVC = [[HWProfileViewController alloc]initWithUserID:userId];
    [self.navigationController pushViewController:profileVC animated:YES];
    
}


- (void) followUnfollowButton:(UIButton*)button follow:(BOOL)isFollow forUserId:(NSString*)userId
{
    if(!isFollow){
        
        [ [NetworkManager shared] unfollowWithUserId:userId successBlock:^{
            
            [UIView performWithoutAnimation:^{
                 [button setTitle:@"  FOLLOW  "  forState:UIControlStateNormal];
                [button layoutIfNeeded];
            }];
            
           
            
            
             button.backgroundColor = [UIColor colorWithRed:48./255. green:173./255. blue:148./255. alpha:1];
            
                                      } failureBlock:^(NSError *error) {
                        
                    }];
    } else {
        
        [ [NetworkManager shared] followWithUserId:userId successBlock:^{
            
            
            [UIView performWithoutAnimation:^{
                [button setTitle:@" UNFOLLOW "  forState:UIControlStateNormal];
                [button layoutIfNeeded];
            }];
          
            
            
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




@end
