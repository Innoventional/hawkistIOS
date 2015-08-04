//
//  HWPaymentViewController.m
//  Hawkist
//
//  Created by User on 02.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWPaymentViewController.h"
#import "HWPaymentCell.h"

#import "HWPaymentOptionCell.h"
#import "HWAddressOptionCell.h"


@interface HWPaymentViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
 
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UICollectionView *paymentCollectionView;
@property (nonatomic, strong) UICollectionView *addressCollectionView;
@property (nonatomic, assign) CGFloat cellHeightl;
@property (nonatomic, assign) CGFloat screenWidth;


@property (nonatomic, strong) NSArray *paymentOptionArray;
@property (nonatomic, strong) NSArray *addressOptionArray;

@end

@implementation HWPaymentViewController

#define cellIdentifier @"cellID"

#define paymentOptionCell @"paymentOptionCell"
#define addressOptionCell @"addressOptionCell"


- (instancetype) init
{
    self = [super initWithNibName: @"HWPaymentView" bundle: nil];
    
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight =  63;//56.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HWPaymentCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];

    [self.tableView layoutIfNeeded ];
    NSLog(@"%f",self.tableView.frame.size.height);
    
    self.tableView.bounces= NO;
    CGFloat cellHeight = self.tableView.bounds.size.height;
    self.cellHeightl = cellHeight/2 - 34;
    
}

#pragma mark -
#pragma mark set/get


- (void)setPaymentCollectionView:(UICollectionView *)paymentCollectionView
{
    _paymentCollectionView = paymentCollectionView;
    
    [_paymentCollectionView registerNib:[UINib nibWithNibName:@"HWPaymentOptionCell" bundle:nil] forCellWithReuseIdentifier:paymentOptionCell];
}

-(void)setAddressCollectionView:(UICollectionView *)addressCollectionView
{
    _addressCollectionView = addressCollectionView;
    
    [_addressCollectionView registerNib:[UINib nibWithNibName:@"HWAddressOptionCell" bundle:nil] forCellWithReuseIdentifier:addressOptionCell];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(indexPath.section == 0)
        {
            self.paymentCollectionView = cell.collectionView;
        }
    else if (indexPath.section == 1)
        {
            self.addressCollectionView = cell.collectionView;
        }
    
    cell.collectionView.delegate = self;
    cell.collectionView.dataSource = self;
    
    
    return cell;


}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, frame.size.width, 20);
    
    myLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12];
    myLabel.textColor = [UIColor colorWithRed:110./255. green:110./255. blue:110./255. alpha:1];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1];
    [headerView addSubview:myLabel];
    
    return headerView;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   if(section == 0)
   {
        return @"SELECT PAYMENT OPTION";
       
   } else {
       
       return @"SELECT ADDRESS OPTION";
   }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    CGFloat width = 0;
    
    if( self.screenWidth >320)
    {
          width = (self.screenWidth - self.screenWidth/1.5)/2;
    }
    else
    {
          width = (self.screenWidth - self.screenWidth/1.2)/2;
    }

    
    
    
    
    return UIEdgeInsetsMake(5, width, 5, width); // top, left, bottom, right
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Calculate cell frame
    
    CGFloat widthForView = 0;
    
    if( self.screenWidth >320)
    {
          widthForView = ( self.screenWidth) / 1.5;
    }
    else
    {
        widthForView = ( self.screenWidth) / 1.2;
    }
    
    return CGSizeMake(widthForView, 150);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeightl;
}



#pragma mark -
#pragma mark UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:self.paymentCollectionView])
    {
        return 5;//self.paymentOptionArray.count;
        
    } else if([collectionView isEqual:self.addressCollectionView])
    {
        return 5;//self.addressOptionArray.count;
        
    } else {
        
        return 0;
    }
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([collectionView isEqual:self.paymentCollectionView])
    {
        HWPaymentOptionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:paymentOptionCell forIndexPath:indexPath];
        
        cell.im.layer.cornerRadius = 6;
        cell.im.layer.borderColor = [UIColor colorWithRed:55./255. green:185./255. blue:165./255. alpha:1].CGColor;
        cell.im.layer.borderWidth = 3;
        return cell;
        
    }
    
    else  if([collectionView isEqual:self.addressCollectionView])
    
    {
        HWAddressOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addressOptionCell forIndexPath:indexPath];
        
        cell.im.layer.cornerRadius = 6;
        cell.im.layer.borderColor = [UIColor colorWithRed:55./255. green:185./255. blue:165./255. alpha:1].CGColor;
        cell.im.layer.borderWidth = 3;
        return cell;
        
    }
    else {
        
        UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
        
        return cell;
    }
    
}




@end
