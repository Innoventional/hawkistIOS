//
//  FeedScreenViewController.m
//  FeedScreen
//
//  Created by Evgen Bootcov on 25.06.15.
//  Copyright (c) 2015 Evgen Bootcov. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "FeedScreenViewController.h"
#import "ViewItemViewController.h"
#import "HWProfileViewController.h"
#import "CustomizationViewController.h"
#import "AddTagsView.h"
#import "myItemCell.h"
#import "HWCommentViewController.h"
#import "PersonalisationViewController.h"


@interface FeedScreenViewController () <UITextFieldDelegate, FeedScreenCollectionViewCellDelegate, MyItemCellDelegate>

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSString* searchString;
@property (nonatomic, strong) AddTagsView* addTags;
@end

@implementation FeedScreenViewController

- (instancetype)init
{
    self = [super initWithNibName: @"FeedScreenViewController" bundle: nil];
    if(self)
    {
        self.items = [[NSMutableArray alloc]init];
        self.searchString = @"";
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.isInternetConnectionAlertShowed = NO;
    [self refresh];
}

- (void) selectedItem
{
    [self refresh];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor color256RGBWithRed: 55  green: 184 blue: 164]];
    [self.collectionView addSubview:self.refreshControl];

    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"myItemCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedToShort" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
     
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCollection"]];
    
    self.searchView.backgroundColor = [UIColor color256RGBWithRed: 55  green: 184 blue: 164];
    [self.searchField setValue:[UIColor colorWithRed:189.0/255.0 green:215.0/255.0 blue:211.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    self.searchField.delegate = self;
    
    
    
    
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
    
    cell.delegate = self;
    cell.item = [self.items objectAtIndex: indexPath.row];
    cell.mytrash.hidden = YES;
    
    return cell;
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
    return CGSizeMake(widthForView, (widthForView * 488) / 291 - 5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath
{
    
    UICollectionReusableView *theView;
    
    if(kind == UICollectionElementKindSectionFooter)
    {
       
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:theIndexPath];
        
        self.addTags = (AddTagsView*)[[theView subviews]lastObject];
        self.addTags.delegate = self;
    }
    
    return theView;
}


- (void)refresh
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Fetching listings..."];
    
    [self.refreshControl beginRefreshing];
    
    [[NetworkManager shared] getAvaliableTags:^(NSMutableArray *tags) {
        
        if ([AppEngine shared].tags.count == tags.count)
        {
            
            CustomizationViewController* vc = [[CustomizationViewController alloc]init];
            vc.avaliableTags = tags;
            
            [self.navigationController pushViewController:vc animated:NO];
            
        }
        
        else
        {
            __weak typeof(self) weakSelf = self;
            [self.addTags addTagsToView:tags successBlock:^{
                        if (weakSelf.items.count==0)
                [weakSelf.collectionView setContentOffset:CGPointMake(0, weakSelf.collectionView.contentSize.height-500) animated:YES];
                
                [[NetworkManager shared] getItemsWithPage: 1 searchString: weakSelf.searchString successBlock:^(NSArray *arrayWithItems, NSInteger page, NSString *searchString) {
                    [weakSelf.items removeAllObjects];
                    [weakSelf.items addObjectsFromArray: arrayWithItems];
                    [weakSelf.collectionView reloadData];
                    [weakSelf.refreshControl endRefreshing];
                    if (weakSelf.items.count>0)
                    [weakSelf.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
                    
                    
                    
                } failureBlock:^(NSError *error) {
                    [weakSelf.refreshControl endRefreshing];
                    [weakSelf showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                }];

                
            } failureBlock:^(NSError *error) {
                
                
            }];
        }
    } failureBlock:^(NSError *error) {
        [self.refreshControl endRefreshing];
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        
    }];
    
    
   
    
}

- (void)clickToPersonalisation
{
    PersonalisationViewController* vc = [[PersonalisationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
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

#pragma mark -
#pragma mark  FeedScreenCollectionViewCellDelegate

- (BOOL) willTransitionToUserProfileButton
{
    return YES;
}
- (void) transitionToProfileScreenWithUserId:(NSString*)userId
{
    HWProfileViewController *profileVC = [[HWProfileViewController alloc]initWithUserID:userId];
    [self.navigationController pushViewController:profileVC animated:YES];
}

#pragma mark -
#pragma mark  textFieldDelegate

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* searchString = [textField.text stringByReplacingCharactersInRange: range withString:string];
    self.searchString = searchString;
    [self refresh];
    return YES;
}

- (BOOL) textFieldShouldReturn: (UITextField*) textField
{
    self.searchString = textField.text;
    [self refresh];
    [self.view endEditing: YES];
    return YES;
}


@end
