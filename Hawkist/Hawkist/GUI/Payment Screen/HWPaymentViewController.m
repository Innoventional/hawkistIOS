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
#import "HWAddCardAndAdressCell.h"
#import "NavigationVIew.h"
#import "NetworkManager.h"
#import "AddCardViewController.h"
#import "HWMyOrdersViewController.h"

@interface HWPaymentViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, NavigationViewDelegate, HWAddCardAndAdressCellDelegat>
 
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet UILabel *itemPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *shippingLable;
@property (weak, nonatomic) IBOutlet UILabel *totalLable;


@property (strong, nonatomic) NetworkManager *networkManager;

@property (nonatomic, strong) UICollectionView *paymentCollectionView;
@property (nonatomic, strong) UICollectionView *addressCollectionView;
@property (nonatomic, assign) CGFloat cellHeightl;
@property (nonatomic, assign) CGFloat screenWidth;


@property (nonatomic, strong) NSArray *paymentOptionArray;
@property (nonatomic, strong) NSArray *addressOptionArray;
@property (nonatomic, strong) NSArray *dataModelArray;



@property (nonatomic, assign) NSUInteger paymentSelectRow;
@property (nonatomic, assign) NSUInteger addressSelectRow;

@property (nonatomic, assign) CGFloat itemPrice;
@property (nonatomic, assign) CGFloat shipping;
@property (nonatomic, assign) CGFloat total;

@property (nonatomic, strong) HWItem *item;

@property (nonatomic, assign) NSInteger checkForBuy;



@end

@implementation HWPaymentViewController

#define cellWithCollectionViewIdentifier @"HWPaymentCell"
#define cellForAddDataIdentifier @"HWAddCardAndAdressCell"

#define paymentOptionCell @"paymentOptionCell"
#define addressOptionCell @"addressOptionCell"

- (instancetype)initWithItem:(HWItem*)item
{
    self = [self init];
    if (self)
    {
        // set price info
        self.item = item;
        self.itemPrice = [item.selling_price floatValue];
        self.shipping = [item.shipping_price floatValue];
        self.total = self.itemPrice + self.shipping;
        
    }
    
    return self;
}


- (instancetype) init
{
    self = [super initWithNibName: @"HWPaymentView" bundle: nil];
    
    if (self)
    {
        self.networkManager = [NetworkManager shared];
        //[self setupUserData];
    }
  
    
    return self;
}

- (void) setupUserData
{
        [self.networkManager getAllBankCards:^(NSArray *cards) {
            
            self.paymentOptionArray = cards;
            [self.tableView reloadData];
            
        } failureBlock:^(NSError *error) {
            
            [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // common setup
    
    self.navigationView.title.text = @"Payment";
    self.navigationView.delegate = self;
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    [self setupDataModelArray];
    
    self.itemPriceLable.text = [NSString stringWithFormat:@"£ %.2f",self.itemPrice];
    self.shippingLable.text = [NSString stringWithFormat:@"£ %.2f",self.shipping];
    self.totalLable.text = [NSString stringWithFormat:@"£ %.2f",self.total];
    
    
    // setup tableView
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HWPaymentCell" bundle:nil] forCellReuseIdentifier:cellWithCollectionViewIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"HWAddCardAndAdressCell" bundle:nil] forCellReuseIdentifier:cellForAddDataIdentifier];
    [self.tableView layoutIfNeeded ];
    self.tableView.bounces= NO;
    CGFloat cellHeight = self.tableView.bounds.size.height;
    self.cellHeightl = cellHeight/2 - 34;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupUserData];
    
}

- (void) setupDataModelArray
{
    self.dataModelArray = @[
                            [[HWAddDataModel alloc] initWithTitle:@"Payment details missing!"
                                                     description:@"You need to add debit or credit card to complete this transaction."
                                                  titleForButton:@"ADD DEBIT OR CREDIT CARD"],
                            
                            [[HWAddDataModel alloc]initWithTitle:@"Delivery address missing!"
                                                     description:@"You need to add delivery address to complete this transaction."
                                                  titleForButton:@"ADD DELIVERY ADDRESS"]
                            ];
 
    
}

#pragma mark -
#pragma mark set/get


- (void)setPaymentCollectionView:(UICollectionView *)paymentCollectionView
{
    _paymentCollectionView = paymentCollectionView;
    
    [_paymentCollectionView registerNib:[UINib nibWithNibName:@"HWPaymentOptionCell" bundle:nil] forCellWithReuseIdentifier:paymentOptionCell];
    
//    self.checkForBuy +=1;
    self.buyButton.enabled = YES;// (self.checkForBuy == 2);
}

-(void)setAddressCollectionView:(UICollectionView *)addressCollectionView
{
    _addressCollectionView = addressCollectionView;
    
    [_addressCollectionView registerNib:[UINib nibWithNibName:@"HWAddressOptionCell" bundle:nil] forCellWithReuseIdentifier:addressOptionCell];
    
//    self.checkForBuy +=1;
    self.buyButton.enabled = YES;// (self.checkForBuy == 2);
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWAddCardAndAdressCell *addDataCell = [tableView dequeueReusableCellWithIdentifier:cellForAddDataIdentifier];
    
    addDataCell.delegate = self;
    
    if(indexPath.section == 0 && !self.paymentOptionArray.count)
    {
        [addDataCell setCellWithData:[self.dataModelArray objectAtIndex:indexPath.section]];
        return addDataCell;
    }
    else if (indexPath.section == 1 && !self.addressOptionArray.count)
    {
        [addDataCell setCellWithData:[self.dataModelArray objectAtIndex:indexPath.section]];
        return addDataCell;
    }
    
    
    HWPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithCollectionViewIdentifier];
    
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

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
    
    if( self.screenWidth > 320) // if (iPhone >= iPhone 6)
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
        return [self.paymentOptionArray count];
        
    } else if([collectionView isEqual:self.addressCollectionView])
    {
        return [self.addressOptionArray count];
        
    } else {
        
        return 0;
    }
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([collectionView isEqual:self.paymentCollectionView])
    {
        HWPaymentOptionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:paymentOptionCell forIndexPath:indexPath];
        
        [cell setCellWithCard:[self.paymentOptionArray objectAtIndex:indexPath.row]];
        
        cell.isSelected = (indexPath.row == self.paymentSelectRow);
        
                return cell;
        
    }
    
    else  if([collectionView isEqual:self.addressCollectionView])
    
    {
        HWAddressOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addressOptionCell forIndexPath:indexPath];
        
        cell.isSelected = (indexPath.row == self.addressSelectRow);
        
        return cell;
        
    }
    else {
        
        UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
        
        return cell;
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if([collectionView isEqual:self.paymentCollectionView])
    {
        self.paymentSelectRow = indexPath.row;
        
    } else if([collectionView isEqual:self.addressCollectionView])
    {
        self.addressSelectRow = indexPath.row;
    }

    [collectionView reloadData];
}

#pragma mark -
#pragma mark Action

- (IBAction)pressBuyNowButton:(UIButton *)sender
{
    
    HWCard *card = [self.paymentOptionArray objectAtIndex:self.paymentSelectRow];
    
    [self.networkManager buyItemWithCardId:card.id
                                withItemId:self.item.id
                              successBlock:^{
                                    
                                  HWMyOrdersViewController *vc = [[HWMyOrdersViewController alloc]init];
                                  [self.navigationController pushViewController:vc animated:YES];
                                    
    
                                } failureBlock:^(NSError *error) {
                                    
                                    NSLog(@"FailureBlock");
    
                                    
                                }];

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

#pragma mark -
#pragma mark HWAddCardAndAdressCellDelegat


-(void) pressAddButton:(UIButton*)sender
{
    if ([sender.titleLabel.text isEqualToString:@"ADD DEBIT OR CREDIT CARD"])
    {
        AddCardViewController *vc = [[AddCardViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        
    }
}

@end
