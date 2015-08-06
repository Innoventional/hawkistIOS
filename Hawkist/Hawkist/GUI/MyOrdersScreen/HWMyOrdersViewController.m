//
//  HWMyOrdersViewController.m
//  Hawkist
//
//  Created by User on 06.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWMyOrdersViewController.h"
#import "HWitemForOrdersCell.h"

@interface HWMyOrdersViewController () <HWitemForOrdersCellDelegate, NavigationViewDelegate>

@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end

@implementation HWMyOrdersViewController


- (instancetype) init
{
    self = [super initWithNibName: @"HWMyOrdersView" bundle: nil];
    
    if (self)
    {
        
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HWitemForOrdersCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    self.navigationView.delegate = self;
    self.navigationView.title.text = @"My Orders";
    
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HWitemForOrdersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.orderCellDelegate = self;
    cell.delegate = self;
    
    return cell;
}


#pragma mark -
#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
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



- (void) receivedAction:(UIButton*)sender withItem:(HWItem*)item
{
    
}

- (void) hasIssueAction:(UIButton*)sender withItem:(HWItem*)item
{
    
}

- (void) pressCommentButton:(UIButton*)sender withItem:(HWItem*)item
{
    
}

- (void) pressLikeButton:(UIButton*) sender withItem:(HWItem*)item
{
    
}


#pragma mark -
#pragma mark NavigationViewDelegate 


-(void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void) rightButtonClick
{
    
}


@end
