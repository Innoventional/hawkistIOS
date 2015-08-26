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
#import "HWPaymentBalanceCell.h"
#import "HWPaymentNewCardCell.h"
#import "HWAddNewAddressCell.h"
#import "HWAddressCollectionOnlyCell.h"
#import "AddAddressViewController.h"




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

@property (nonatomic, strong) NSString *balance;

@property (nonatomic, strong) HWItem *item;

@property (nonatomic, assign) NSInteger checkForBuy;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;


@end

@implementation HWPaymentViewController

#define cellWithCollectionViewIdentifier @"HWPaymentCell"
#define cellForAddDataIdentifier @"HWAddCardAndAdressCell"



#define addNewAddressCell @"HWAddNewAddressCell"
#define addressOptionCell @"addressOptionCell"
#define addressCollectionOnlyCell @"collectiomOnly"


#define paymentOptionCell @"paymentOptionCell"
#define paymentBalanceCell @"paymentCell"
#define paymentNewCell @"HWPaymentNewCardCell"


#pragma mark - UIViewController

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
        
    }
  
    
    return self;
}

- (void) setupUserData
{
    
    [self setupAddressArrayData];
}


- (void) setupAddressArrayData {
    
    [self.networkManager getAddresses:^(NSArray *addresses) {
        
        self.addressOptionArray = addresses;
        [self setupPaymentArrayData];
        
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];

    
}


- (void) setupPaymentArrayData {
    
    [self.networkManager getAllBankCards:^(NSArray *cards, NSString *balance) {
        
        self.balance = balance;
        self.paymentOptionArray = cards;
        [self.tableView reloadData];
        [self.paymentCollectionView reloadData];
        [self.addressCollectionView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.indicator stopAnimating];
    
    // common setup
    
    self.navigationView.title.text = @"Payment";
    self.navigationView.delegate = self;
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    [self setupDataModelArray];
    
    self.itemPriceLable.text = [NSString stringWithFormat:@"£%.2f",self.itemPrice];
    self.shippingLable.text = [NSString stringWithFormat:@"£%.2f",self.shipping];
    self.totalLable.text = [NSString stringWithFormat:@"£%.2f",self.total];
    
    
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
    [_paymentCollectionView registerNib:[UINib nibWithNibName:@"HWPaymentBalanceCell" bundle:nil] forCellWithReuseIdentifier:paymentBalanceCell];
    [_paymentCollectionView registerNib:[UINib nibWithNibName:@"HWPaymentNewCardCell" bundle:nil] forCellWithReuseIdentifier:paymentNewCell];
    
//    self.checkForBuy +=1;
    self.buyButton.enabled = YES;// (self.checkForBuy == 2);
}

-(void)setAddressCollectionView:(UICollectionView *)addressCollectionView
{
    _addressCollectionView = addressCollectionView;
    
    [_addressCollectionView registerNib:[UINib nibWithNibName:@"HWAddressOptionCell" bundle:nil] forCellWithReuseIdentifier:addressOptionCell];
    [_addressCollectionView registerNib:[UINib nibWithNibName:@"HWAddNewAddressCell" bundle:nil] forCellWithReuseIdentifier:addNewAddressCell];
    [_addressCollectionView registerNib:[UINib nibWithNibName:@"HWAddressCollectionOnlyCell" bundle:nil] forCellWithReuseIdentifier:addressCollectionOnlyCell ];
    
//    self.checkForBuy +=1;
    self.buyButton.enabled = YES;// (self.checkForBuy == 2);
}


#pragma mark -
#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWAddCardAndAdressCell *addDataCell = [tableView dequeueReusableCellWithIdentifier:cellForAddDataIdentifier];
    
    addDataCell.delegate = self;
    //проверяем, есть ли карточка или адрес и создаём соотвтетствующую ячейку
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
    
    
    // если есть адрес или карточка то создаёв ячейку с collectionView
    
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


#pragma mark -https://omicron.atlassian.net/secure/attachment/10886/sms_sharing.PNG
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
    
    if(section == 1) {
        
        UIImageView *iV = [[UIImageView alloc]initWithFrame:CGRectMake(0, -1, frame.size.width, 1)];
        iV.image = [UIImage imageNamed:@"line"];
        [headerView addSubview:iV];
    }
    
    return headerView;
}
// how would the user ever find the item in this way? Perhaps send message to short code in order to get download link
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
        return [self.paymentOptionArray count] + 2;// + balance + addNewCard
        
    } else if([collectionView isEqual:self.addressCollectionView])
    {
        NSInteger count = self.item.collection_only ? 2 : 1;
        
        return [self.addressOptionArray count] + count ; // +collectionOnly + addNewAddress
        
    } else {
        
        return 0;
    }
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([collectionView isEqual:self.paymentCollectionView])
    {
        // balance cell
        
        if(indexPath.row == [self.paymentOptionArray count]){
            
            HWPaymentBalanceCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:paymentBalanceCell forIndexPath:indexPath];
            [cell setCellWithBalance:self.balance];
            cell.isSelected = (indexPath.row == self.paymentSelectRow);
            
            return cell;
        }
        
        // add new card
        if(indexPath.row == [self.paymentOptionArray count] +1  ){
         
            HWPaymentNewCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:paymentNewCell forIndexPath:indexPath];
            cell.isSelected = (indexPath.row == self.paymentSelectRow);
            
            return cell;
            
        }
        
        // init card
        
        HWPaymentOptionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:paymentOptionCell forIndexPath:indexPath];
        
        [cell setCellWithCard:[self.paymentOptionArray objectAtIndex:indexPath.row]];
        
        cell.isSelected = (indexPath.row == self.paymentSelectRow);
        
                return cell;
        
    }
    
    else  if([collectionView isEqual:self.addressCollectionView])
    
    {
        // collection only cell
        
        if(self.item.collection_only) {
        
                if(self.addressOptionArray.count == indexPath.row){
                    
                    HWAddressCollectionOnlyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addressCollectionOnlyCell forIndexPath:indexPath];
                     cell.isSelected = (indexPath.row == self.addressSelectRow);
                    
                    return cell;
                }
                
                // new address cell
                
                if((self.addressOptionArray.count +1) == indexPath.row){
                    
                    HWAddNewAddressCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addNewAddressCell forIndexPath:indexPath];
                     cell.isSelected = (indexPath.row == self.addressSelectRow);
                    return cell;
                    
                }
        } else {
            
            if(self.addressOptionArray.count == indexPath.row){
                
                HWAddNewAddressCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addNewAddressCell forIndexPath:indexPath];
                cell.isSelected = (indexPath.row == self.addressSelectRow);
                return cell;
                
            }
            
        }
        
        
        HWAddressOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addressOptionCell forIndexPath:indexPath];
        
        cell.isSelected = (indexPath.row == self.addressSelectRow);
        [cell setCellWithAddress: [self.addressOptionArray objectAtIndex:indexPath.row]];
        
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
        
        //press add card
        
        if((self.paymentOptionArray.count + 1) == indexPath.row){
            
            AddCardViewController *vc = [[AddCardViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            self.paymentSelectRow = 0;
            [collectionView reloadData];
 
            return;
            
        }
        
    }
    else if([collectionView isEqual:self.addressCollectionView])
    {
        self.addressSelectRow = indexPath.row;
      
        // press add address
        
        if (!self.item.collection_only) {
            
            if((self.addressOptionArray.count ) == indexPath.row){
                
                AddAddressViewController *vc = [[AddAddressViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
                self.addressSelectRow = 0;
                [collectionView reloadData];
                
                return;
            }
            
            
        }
        
        if((self.addressOptionArray.count + 1) == indexPath.row){
            
            AddAddressViewController *vc = [[AddAddressViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            self.addressSelectRow = 0;
            [collectionView reloadData];
            
            return;
        }

    }

    [collectionView reloadData];
}

#pragma mark -
#pragma mark Action

- (IBAction)pressBuyNowButton:(UIButton *)sender
{
    
    if(!(self.addressOptionArray.count && self.paymentOptionArray.count)) {
        
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"Please add the address or card"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil]show];
        return;
    }
    
    NSString *desc =
    [NSString stringWithFormat:@"You have purchased \"%@\" for £%@. Please confirm when you have received the item.",self.item.title, self.item.selling_price];
   
    NSString *cardId  = nil;
    NSString *itemId  = self.item.id;
    NSString *collectioOnly  = nil;
    NSString *addressID  = nil;
    NSString *wallet  = nil;

    
    sender.enabled = NO;
    [self.indicator startAnimating];
    
    if(self.paymentSelectRow == self.paymentOptionArray.count)
    {
        
      wallet = @"Yes";
    } else{
        
        HWCard *card = [self.paymentOptionArray objectAtIndex:self.paymentSelectRow];
        cardId = card.id;
    }
    
    //if(self.item.collection_only) {
        
        if(self.addressSelectRow == self.addressOptionArray.count)
        {
            
            collectioOnly = @"Yes";
        } else{
            
            HWAddress *address = [self.addressOptionArray objectAtIndex:self.addressSelectRow];
            addressID = address.id;
        }
   // } else {
        
        
   // }
    
    
    
    
    
    
    
    
    
    
    
  
    
    [self.networkManager buyItemWithCardId: cardId
                         withPayWithWallet: wallet
                                withItemId: itemId
                         withCollectioOnly: collectioOnly
                             withAddressID: addressID
                              successBlock:^{
                                  
                                  [[[UIAlertView alloc]initWithTitle:@"Purchase Completed"
                                                             message:desc
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil ]show];
                                  
                                  [self.indicator stopAnimating];
                                  
                                  HWMyOrdersViewController *vc = [[HWMyOrdersViewController alloc]init];
                                  [self.navigationController pushViewController:vc animated:YES];
                                  

                                  
                              } failureBlock:^(NSError *error) {
                                  
                                  [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                  [self.indicator stopAnimating];
                                  sender.enabled = YES;

                              }];
    
    
    
//    [self.networkManager buyItemWithCardId:card.id
//                                withItemId:self.item.id
//                              successBlock:^{
//                                  
//                                 
//                                  [[[UIAlertView alloc]initWithTitle:@"Purchase Completed"
//                                                             message:desc
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"OK"
//                                                   otherButtonTitles: nil ]show];
//                                  
//                                   [self.indicator stopAnimating];
//                                  
//                                  HWMyOrdersViewController *vc = [[HWMyOrdersViewController alloc]init];
//                                  [self.navigationController pushViewController:vc animated:YES];
//                                    
//    
//                                } failureBlock:^(NSError *error) {
//                                    
//                                    [self showAlertWithTitle:error.domain Message:error.localizedDescription];
//                                    [self.indicator stopAnimating];
//                                    sender.enabled = YES;
//
//                                    
//                                }];

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
        AddAddressViewController *vc = [[AddAddressViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
