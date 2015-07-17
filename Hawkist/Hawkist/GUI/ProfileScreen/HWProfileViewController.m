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

@property (nonatomic, strong) NSArray* selectedSegmentArray;

@property (nonatomic, strong) HWUser *user;


@end

@implementation HWProfileViewController

#pragma mark-
#pragma mark Lifecycle


- (instancetype) initWithUserID:(NSString *)userID
{
    self = [self init];
    if(self)
    {
        
        [[NetworkManager shared]getUserProfileWithUserID:@"12"
                                            successBlock:^(HWUser *user) {
                                                
                                                self.user = user;
                                                [self updateUser];
                                                
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


-(void)viewDidAppear:(BOOL)animated{
    
    [self segmentButtonAction:self.itemsButton];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    self.navigationView.delegate = self;
    self.navigationView.title.text = @"Profile";
    
    [self.navigationView.title setFont:[UIFont systemFontOfSize:20]];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateUser
{

     [self.avatarView setImageWithURL: [NSURL URLWithString: self.user.avatar] placeholderImage:nil];

    
    /*
     
     
 
     
    
   
     
     @property (nonatomic, strong) NSString<Optional>* city;
     @property (nonatomic, strong) NSString<Optional>* last_activity;
     @property (nonatomic, strong) NSString<Optional>* number_of_sales;
     @property (nonatomic, strong) NSString<Optional>* rating;
     @property (nonatomic, strong) NSString<Optional>* review;
     @property (nonatomic, strong) NSString<Optional>* response_time;
     

     
     
     
     @property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
     
     @property (weak, nonatomic) IBOutlet UILabel *salesLabel;
     @property (weak, nonatomic) IBOutlet UILabel *locationLabel;
     @property (weak, nonatomic) IBOutlet UILabel *lastSeenLabel;
     @property (weak, nonatomic) IBOutlet UILabel *responsTimeLabel;
     @property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
     
     */
}


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
    [self.tableView registerNib:[UINib nibWithNibName:@"HWFollowInProfileCell" bundle:nil] forCellReuseIdentifier:@"123"];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, yOriginForTableAndCollection, widthScreen, 500) collectionViewLayout:layout];
    [self.scrollView addSubview:self.collectionView];
    self.collectionView.hidden = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCollection"]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedScreenCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionViewCell"];
    
    [self setupSegmentButtonsConfig];
    
    self.starRatingView.delegate = self;
    
    
   
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
    self.itemsButton.count.text = @"45";
    
    self.followersButton.titleButton.text = @"FOLLOWERS";
    self.followersButton.count.text = @"124";
    
    self.followingButton.titleButton.text = @"FOLLOWING";
    self.followingButton.count.text = @"341";
    
    self.wishlistButton.titleButton.text = @"WISHLIST";
    self.wishlistButton.count.text = @"12";
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
       [sender setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
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
    switch (sender.tag) {
        case 1:
            [self reloadTableAndCollectionViewWithData:nil forTableView:NO];
            break;
        case 2:
            [self reloadTableAndCollectionViewWithData:nil forTableView:YES];
            break;
        case 3:
            [self reloadTableAndCollectionViewWithData:nil forTableView:YES];
            break;
        case 4:
            [self reloadTableAndCollectionViewWithData:nil forTableView:NO];
            break;
            
        default:
            break;
    }
    

    
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
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWFollowInProfileCell* cell = [tableView dequeueReusableCellWithIdentifier:@"123" forIndexPath:indexPath];
    
    

    
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
    return 41;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeedScreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    return cell;
}


#pragma mark -
#pragma mark UICollectionViewDelegate

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
