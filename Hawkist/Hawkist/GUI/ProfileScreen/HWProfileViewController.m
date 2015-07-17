//
//  HWProfileViewController.m
//  Hawkist
//
//  Created by User on 14.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWProfileViewController.h"
#import "NavigationVIew.h"

#import "HWButtonForSegment.h"

#import "FeedScreenCollectionViewCell.h"
#import "HWFollowInProfileCell.h"
#import "StarRatingControl.h"
#import "NetworkManager.h"
#import "HWUser.h"


#import "MyItemCellView.h"
#import "ViewItemViewController.h"


@interface HWProfileViewController () <NavigationViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, StarRatingDelegate, UIAlertViewDelegate>

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


@end

@implementation HWProfileViewController

#pragma mark-
#pragma mark Lifecycle


- (instancetype) initWithUserID:(NSString *)userID
{
    self = [self init];
    if(self)
    {
        
        [[NetworkManager shared]getUserProfileWithUserID:@"77"
                                            successBlock:^(HWUser *user) {
                                                
                                                self.user = user;
                                                [self updateUser];
                                                [self setArrayForSegmentView];
                                                
                                            } failureBlock:^(NSError *error) {
            
                                                
                                                NSString *errorMessage = [NSString stringWithFormat:@"%@", error.localizedDescription];
       
                                                [[[UIAlertView alloc]initWithTitle:@"Error!"
                                                                           message:errorMessage
                                                                          delegate:self
                                                                 cancelButtonTitle:@"Ok!"
                                                                 otherButtonTitles: nil] show];
                                            
                                        }];
        
    }
    
    return self;
}

- (instancetype) init
{
    self = [super initWithNibName: @"HWProfileViewController" bundle: nil];
    
    if(self)
    {
    
    }
    
    return self;
}


//-(void)viewDidAppear:(BOOL)animated{
//    
//    [self segmentButtonAction:self.itemsButton];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    self.navigationView.delegate = self;
    self.navigationView.title.text = @"Profile";
    
    [self.navigationView.title setFont:[UIFont systemFontOfSize:20]];
   
}


#pragma mark -
#pragma mark set/get


-(void)commonInit
{
    
    CGFloat widthScreen = [UIScreen mainScreen].bounds.size.width;
    CGFloat yOriginForTableAndCollection = self.segmentView.frame.origin.y + self.segmentView.frame.size.height - 10;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, yOriginForTableAndCollection, widthScreen, 200) style:UITableViewStylePlain];
    [self.scrollView addSubview:self.tableView];
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HWFollowInProfileCell" bundle:nil] forCellReuseIdentifier:@"tableViewCell"];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, yOriginForTableAndCollection, widthScreen, 500) collectionViewLayout:layout];
    [self.scrollView addSubview:self.collectionView];
    self.collectionView.hidden = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCollection"]];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"myItemCell" bundle:nil] forCellWithReuseIdentifier:@"collectionViewCell"];
    
    [self setupSegmentButtonsConfig];
    
    self.starRatingView.delegate = self;
    
    
    
}

- (void) setArrayForSegmentView
{
    // items
    
    [[NetworkManager shared]getItemsByUserId:self.user.id
                                successBlock:^(NSArray *arrayWithItems) {
                                    
                                    self.itemsArray = arrayWithItems;
                                    [self setupSegmentButtonsConfig];
                                    [self segmentButtonAction:self.itemsButton];
                                    
                                } failureBlock:^(NSError *error) {
                                    
                                    
                                }];
    
    // following
    
    //followers
    
    //wishlist
    
}


- (void) updateUser
{

    [self.avatarView setImageWithURL: [NSURL URLWithString: self.user.avatar] placeholderImage:nil];
    self.userNameLabel.text = self.user.username;
    self.locationLabel.text = self.user.city;
   
    self.lastSeenLabel.text = self.user.last_activity;
    
    self.ratingLabel.text = self.user.rating;
    self.salesLabel.text = self.user.number_of_sales;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSDate *dateFromString = [dateFormatter dateFromString:self.user.last_activity];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"hh:mm a MMM dd, yyyy"];
    
    self.lastSeenLabel.text = [dateFormatter1 stringFromDate:dateFromString];
    
}



#pragma mark - 
#pragma mark StarRatingDelegate

- (BOOL) enabledTouch
{
    return NO;
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
#pragma mark reloadData

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
    
    
}


- (void) setupHeightScrollView:(CGFloat) height
{
    CGFloat heightForScrollView = self.segmentView.frame.origin.y + self.segmentView.frame.size.height + height;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, heightForScrollView)];
    
}



#pragma mark -
#pragma mark Actions


- (IBAction)aboutAction:(UIButton *)sender {
}

- (IBAction)followUnfollowAction:(UIButton *)sender {
    
   if ([sender.titleLabel.text isEqualToString:@"  FOLLOW  "])
   {
       [sender setTitle:@" UNFOLLOW " forState:UIControlStateNormal];
   } else {
       [sender setTitle:@"  FOLLOW  " forState:UIControlStateNormal];
      
   }
}

- (IBAction)segmentButtonAction:(HWButtonForSegment *)sender {
    
   for (HWButtonForSegment *button in self.buttonSegmentCollection)
   {
       button.selectedImage.hidden = YES;
   }
    
    sender.selectedImage.hidden = NO;
    BOOL isTableView = NO;
    
    switch (sender.tag) {
        case 1:
            isTableView = NO;
            self.selectedSegmentArray = self.itemsArray;
            break;
        case 2:
            isTableView = YES;
            self.selectedSegmentArray = self.followingArray;
            break;
        case 3:
            isTableView = YES;
            self.selectedSegmentArray = self.followersArray;
            break;
        case 4:
           isTableView = NO;
            self.selectedSegmentArray = self.wishListArray;
            break;
            
        default:
            break;
    }
    
      [self reloadTableAndCollectionViewWithData:self.selectedSegmentArray forTableView:isTableView];
    
}



#pragma mark -
#pragma mark NavigationDelegate


-(void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) rightButtonClick
{
    
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selectedSegmentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWFollowInProfileCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    
    

    
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


#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.selectedSegmentArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyItemCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    
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
}



- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 12, 15, 12); // top, left, bottom, right
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Make cell same width as application frame and 250 pixels tall.
    CGFloat width = self.view.width;
    CGFloat widthForView = (width - 36) / 2;
    return CGSizeMake(widthForView, (widthForView * 488) / 291);
}

#pragma mark -
#pragma mark UIAlertViewDelegate



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
