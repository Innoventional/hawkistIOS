//
//  myFavouritesViewController.m
//  Hawkist
//
//  Created by Anton on 22.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "myFavouritesViewController.h"
#import "NavigationView.h"
#import "UIColor+Extensions.h"
#import "HWCommentViewController.h"
#import "myItemCell.h"
#import "ViewItemViewController.h"

@interface myFavouritesViewController () <NavigationViewDelegate,UICollectionViewDataSource,MyItemCellDelegate>

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) NSMutableArray* items;


@property (strong, nonatomic) IBOutlet NavigationVIew *navigation;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSString *selectedId;
@property (strong, nonatomic) UIView* placeHolder;


@end

@implementation myFavouritesViewController

- (instancetype)init
{
    self = [super initWithNibName: @"myFavourites" bundle: nil];
    if(self)
    {
        self.items = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor color256RGBWithRed: 55  green: 184 blue: 164]];
    
    [self.collectionView addSubview:self.refreshControl];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"myItemCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCollection"]];
    
    self.navigation.title.text = @"My Favourites";
    self.navigation.delegate = self;
    self.placeHolder =  [[[NSBundle mainBundle]loadNibNamed:@"defaultFavourites" owner:self options:nil]firstObject];
    self.placeHolder.frame = CGRectMake(0, self.navigation.height, self.view.width, self.view.height - 65);
    [self.view addSubview:self.placeHolder];
}




- (void) viewDidAppear:(BOOL)animated
{
    self.isInternetConnectionAlertShowed = NO;
    [self refresh];
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    myItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    HWItem* currentItem = [self.items objectAtIndex:indexPath.row];
    

    
    [cell setItem:currentItem];
    cell.mytrash.hidden = YES;
    
    cell.delegate = self;
    return cell;
}

- (void) showError:(NSError *)error
{
    [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    [self refresh];
}

- (void) updateParent
{
    [self refresh];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ViewItemViewController* vc = [[ViewItemViewController alloc] initWithItem: [self.items objectAtIndex: indexPath.row]];
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
    return CGSizeMake(widthForView, ((widthForView * 488) / 291)-5);
}

- (void)refresh
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Fetching listings..."];
    [self.refreshControl beginRefreshing];

    [self showHud];
    [[NetworkManager shared] getWishlistWithUserId:[AppEngine shared].user.id successBlock:^(NSArray *arrayWithItems) {
        
        [self.items removeAllObjects];
        
        [self.items addObjectsFromArray: arrayWithItems];
        [self.collectionView reloadData];
        [self.refreshControl endRefreshing];
        
        if (self.items.count == 0)
        {
            self.placeHolder.hidden = NO;
            
        }
        else
        {
            self.placeHolder.hidden = YES;
        }
        
        [self hideHud];
        
    } failureBlock:^(NSError *error) {
        
        [self hideHud];
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self.refreshControl endRefreshing];
    }];
    
    
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
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    
//
//    self.selectedId = item.id;
//    [alert show];

    
    [[NetworkManager shared] likeDislikeWhithItemId:item.id
                                       successBlock:^{
                                           
                                       } failureBlock:^(NSError *error) {
                                           
                                       }];
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1)
//    {
//        
//        [[NetworkManager shared] likeDislikeWhithItemId:self.selectedId
//                                           successBlock:^{
//
//                                           } failureBlock:^(NSError *error) {
//                                               
//                                           }];
//        
//    }
//
//    [self refresh];
//}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
