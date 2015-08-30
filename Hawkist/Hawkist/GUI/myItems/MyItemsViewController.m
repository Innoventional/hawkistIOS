//
//  MyItemsViewController.m
//  Hawkist
//
//  Created by Anton on 14.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "MyItemsViewController.h"
#import "UIColor+Extensions.h"
#import "myItemCell.h"
#import "ViewItemViewController.h"
#import "HWCommentViewController.h"


@interface MyItemsViewController ()<UICollectionViewDataSource,UITabBarDelegate>

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) NSMutableArray* items;
@property (nonatomic, assign) BOOL showSold;

@property (strong, nonatomic) IBOutlet UITabBar *tabBar;

@end

@implementation MyItemsViewController

- (instancetype)init
{
    self = [super initWithNibName: @"MyItemsView" bundle: nil];
    if(self)
    {
        self.items = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingTabBar];

    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor color256RGBWithRed: 55  green: 184 blue: 164]];
    
    [self.collectionView addSubview:self.refreshControl];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"myItemCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCollection"]];


  }


- (void) settingTabBar
{
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    
    self.showSold = NO;
    
    for (UITabBarItem *item in [self.tabBar items]) {
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"OpenSans" size:20.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    }}

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
    
    [[NetworkManager shared] getItemsByUserId:[AppEngine shared].user.id successBlock:^(NSArray *arrayWithItems) {
        
        [self.items removeAllObjects];
        
        for (HWItem* item in arrayWithItems)
        {
        if (self.showSold)
        {
            if ([item.status isEqualToString:@"2"])
                [self.items addObject:item];
        }
        else
        {
            if (![item.status isEqualToString:@"2"])
                [self.items addObject:item];

        }
        }
        //[self.items addObjectsFromArray: arrayWithItems];
        [self.collectionView reloadData];
        [self.refreshControl endRefreshing];
        
        if (self.items.count == 0)
        {
            self.view.hidden = YES;
            
        }
        else
        {
            self.view.hidden = NO;
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
    
    [[NetworkManager shared] likeDislikeWhithItemId:item.id
                                       successBlock:^{
                                           
                                       } failureBlock:^(NSError *error) {
                                           
                                       }];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([self.tabBar selectedItem].tag == 1) {
        self.showSold = YES;
    }
    else
        self.showSold = NO;
    [self refresh];
}

@end
