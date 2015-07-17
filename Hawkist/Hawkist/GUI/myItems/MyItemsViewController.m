//
//  MyItemsViewController.m
//  Hawkist
//
//  Created by Anton on 14.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "MyItemsViewController.h"
#import "UIColor+Extensions.h"
#import "MyItemCellView.h"
#import "ViewItemViewController.h"

@interface MyItemsViewController ()

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) NSMutableArray* items;


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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor color256RGBWithRed: 55  green: 184 blue: 164]];
    
    [self.collectionView addSubview:self.refreshControl];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"myItemCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCollection"]];
    

    
    [[NetworkManager shared] getItemsByUserId:[AppEngine shared].user.id successBlock:^(NSArray *arrayWithItems) {
        
        [self.items addObjectsFromArray: arrayWithItems];
        [self.collectionView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
}




-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}


- (MyItemCellView *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyItemCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
   
    HWItem* currentItem = [self.items objectAtIndex:indexPath.row];
    
    [cell setItem:currentItem];
   
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
    return CGSizeMake(widthForView, (widthForView * 488) / 291);
}

- (void)refresh
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Fetching listings..."];
    
    [[NetworkManager shared] getItemsByUserId:[AppEngine shared].user.id successBlock:^(NSArray *arrayWithItems) {
        
        [self.items removeAllObjects];
        
        [self.items addObjectsFromArray: arrayWithItems];
        [self.collectionView reloadData];
        [self.refreshControl endRefreshing];
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self.refreshControl endRefreshing];
    }];

    
}


@end