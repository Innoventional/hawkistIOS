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


@interface FeedScreenViewController () <UITextFieldDelegate, FeedScreenCollectionViewCellDelegate>

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSString* searchString;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    //[self.refreshControl setBackgroundColor:[UIColor whiteColor]];
    [self.refreshControl setTintColor:[UIColor color256RGBWithRed: 55  green: 184 blue: 164]];
   // [self.refreshControl tintColorDidChange];
    
    [self.collectionView addSubview:self.refreshControl];
    
    //self.collectionView.alwaysBounceVertical = YES;
    
   
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedScreenCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCollection"]];
    
    self.searchView.backgroundColor = [UIColor color256RGBWithRed: 55  green: 184 blue: 164];
    [self.searchField setValue:[UIColor colorWithRed:189.0/255.0 green:215.0/255.0 blue:211.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    self.searchField.delegate = self;

    
    [[NetworkManager shared] getItemsWithPage: self.currentPage + 1 searchString: nil successBlock:^(NSArray *arrayWithItems, NSInteger page, NSString *searchString) {
        [self.items addObjectsFromArray: arrayWithItems];
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* searchString = [textField.text stringByReplacingCharactersInRange: range withString:string];
    self.searchString = searchString;
    [[NetworkManager shared] getItemsWithPage: 1 searchString: searchString successBlock:^(NSArray *arrayWithItems, NSInteger page, NSString *searchString) {
        self.currentPage = 1;
        [self.items removeAllObjects];
        [self.items addObjectsFromArray: arrayWithItems];
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        self.currentPage = 1;
    }];
    return YES;
}

- (BOOL) textFieldShouldReturn: (UITextField*) textField
{
    self.searchString = textField.text;
    [[NetworkManager shared] getItemsWithPage: 1 searchString: self.searchString successBlock:^(NSArray *arrayWithItems, NSInteger page, NSString *searchString) {
        self.currentPage = 1;
        [self.items removeAllObjects];
        [self.items addObjectsFromArray: arrayWithItems];
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        self.currentPage = 1;
    }];

    [self.view endEditing: YES];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}


- (FeedScreenCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FeedScreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.delegate = self;
    cell.item = [self.items objectAtIndex: indexPath.row];
    
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
    
    [[NetworkManager shared] getItemsWithPage: 1 searchString: self.searchString successBlock:^(NSArray *arrayWithItems, NSInteger page, NSString *searchString) {
        [self.items removeAllObjects];
        [self.items addObjectsFromArray: arrayWithItems];
        [self.collectionView reloadData];
        [self.refreshControl endRefreshing];
    } failureBlock:^(NSError *error) {
        [self.refreshControl endRefreshing];
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


@end
