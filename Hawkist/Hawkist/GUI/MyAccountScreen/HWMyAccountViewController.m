//
//  HWMyAccountViewController.m
//  Hawkist
//
//  Created by User on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWMyAccountViewController.h"
#import "HWAccountMenuDataModel.h"
#import "HWAccountMenuCell.h"
#import "NavigationVIew.h"
#import "HWSingOutCell.h"
#import "NetworkManager.h"
#import "ManageAddressViewController.h"
#import "ManageBankViewController.h"
#import "AccountDetailViewController.h"
#import "NotificationSettingsViewController.h"

#import "WebViewController.h"

@interface HWMyAccountViewController () <UITableViewDataSource, UITableViewDelegate, NavigationViewDelegate,HWSingOutCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;
@property (nonatomic, strong) NetworkManager *networkManager;

@property (nonatomic, strong) NSArray *accountDetailsArray;
@property (nonatomic, strong) NSArray *paymentOptionsArray;
@property (nonatomic, strong) NSArray *sharingAndNitificationsArray;
@property (nonatomic, strong) NSArray *privacyArray;

@property(nonatomic, strong) NSArray *nameForGroupArray;
@property (nonatomic, strong) NSArray *groupArray;

@property (nonatomic, weak) IBOutlet UIButton *signOutButton;

@property (nonatomic, assign) BOOL isFavorItem;


@end

@implementation HWMyAccountViewController

#define menuCellIdentifier @"HWAccountMenuCell"
#define singOutCellIdentifier @"HWSingOutCell"

-(instancetype) init{
    
    self = [super initWithNibName: @"HWMyAccountVIew" bundle: nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.networkManager = [NetworkManager shared];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight =  63;//56.0;

    self.navigationView.delegate = self;
    self.navigationView.title.text = @"My Account";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HWAccountMenuCell" bundle:nil] forCellReuseIdentifier:menuCellIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:@"HWSingOutCell" bundle:nil] forCellReuseIdentifier:singOutCellIdentifier];
    
    
    
    [self setupMenuArray];
    
}

- (void) setupMenuArray
{
    self.accountDetailsArray = @[
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"username" withTitle:@"Update Account Details"],
//                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"email" withTitle:@"Email Address"],
//                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"about me" withTitle:@"About Me"],
                                ];
    
    self.paymentOptionsArray = @[
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"manage" withTitle:@"Manage Bank Cards"],
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"manageAd" withTitle:@"Manage Addresses"]
                                ];
    
    self.sharingAndNitificationsArray = @[
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"MobileNot" withTitle:@"Mobile Notifications"],
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"EmailNot" withTitle:@"Email Notifications"]
                                 ];
    self.privacyArray = @[@"SingOut"];

    self.nameForGroupArray = @[@"ACCOUNT DETAILS", @"PAYMENT OPTIONS", @"SHARING AND NOTIFICATIONS", @"PRIVACY"];
    
    self.groupArray = @[_accountDetailsArray, _paymentOptionsArray,_sharingAndNitificationsArray,_privacyArray];
    
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.groupArray objectAtIndex:section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *ar = [self.groupArray objectAtIndex:indexPath.section];
    
    if([[ar objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
    {
        HWSingOutCell *cell = [tableView dequeueReusableCellWithIdentifier:singOutCellIdentifier];
        cell.delegate = self;
        [self favouriteWithButton:cell.notifySellerButton];
        
        return cell;
    }
    
    HWAccountMenuDataModel * model = [ar objectAtIndex:indexPath.row];

    HWAccountMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
    [cell setCellWithMenuDataModel:model];
    
    return cell;
    
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    NSArray *ar = [self.groupArray objectAtIndex:indexPath.section];
    
    if([[ar objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
    {
        return NO;
    }
    
    return YES;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *groupName = [self.nameForGroupArray objectAtIndex:section];
    return groupName;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            
            [self selectAccountDetail:indexPath.row];
            break;
        case 1:
            
            [self selectPaymentOptions:indexPath.row];
            break;
        case 2:
            
            [self selectSharingAndNotifications:indexPath.row];
            break;
            
        default:
            break;
    }
    
}




-(void)selectAccountDetail:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            AccountDetailViewController *vc = [[AccountDetailViewController alloc] initWithUser:[AppEngine shared].user.id];
            [self.navigationController pushViewController:vc animated:YES];
            
            NSLog(@"User name");
            break;
        }
        case 1:
            
            NSLog(@"Email Address");
            break;
            
        case 2:
            
            NSLog(@"About Me");
            break;
            
        default:
            break;
    }
}


-(void)selectPaymentOptions:(NSInteger)row

{
    
    
    switch (row) {
        case 0:
            {
            ManageBankViewController *vc = [[ManageBankViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            
            NSLog(@"Manage Bank Cards");
            
            break;
            }
        case 1:
        {
            NSLog(@"Manage Addresses");
            
            ManageAddressViewController *vc = [[ManageAddressViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

-(void)selectSharingAndNotifications:(NSInteger)row

{
    
    switch (row) {
        case 0:
        {
            NSLog(@"Mobile Notifications");
            
            NotificationSettingsViewController *vc = [[NotificationSettingsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 1:
            
            NSLog(@"Email Notifications");
            break;
            
        default:
            break;
    }

    
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(15, 8, frame.size.width, 20);
    
    myLabel.font =  [UIFont fontWithName:@"OpenSans-Semibold" size:10];
    myLabel.textColor = [UIColor colorWithRed:97./255. green:97./255. blue:97./255. alpha:1];//[UIColor colorWithRed:97./255. green:97./255. blue:97./255. alpha:1];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1];
    [headerView addSubview:myLabel];
    
    return headerView;
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
#pragma mark HWSingOutCellDelegate

- (void) pressNotifySellerButton:(UIButton*)sender
{
//    [sender setImage:[UIImage imageNamed:@"acdet_check"] forState:UIControlStateNormal];
    
    [self.networkManager updateUserNotificationItemFavouritedWithBool:(!self.isFavorItem)
                                                         successBlock:^(BOOL isFavourite){
                                                             
                                                             if (isFavourite) {
                                                                 
                                                                 [sender setImage:[UIImage imageNamed:@"acdet_check"] forState:UIControlStateNormal];
                                                                 self.isFavorItem = YES;
                                                                 
                                                             } else {
                                                                 
                                                                 [sender setImage:[UIImage imageNamed:@"acdet_checkempty"] forState:UIControlStateNormal];
                                                                 self.isFavorItem = NO;
                                                             }
                                                             
                                                             
                                                         } failureBlock:^(NSError *error) {
                                                             
                                                             [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                                         }];
}

- (void) pressLetMemberButton:(UIButton*)sender
{
    if([sender.imageView.image isEqual:[UIImage imageNamed:@"acdet_check"]])
    {
        [sender setImage:[UIImage imageNamed:@"acdet_checkempty"] forState:UIControlStateNormal];
    
    } else {
        [sender setImage:[UIImage imageNamed:@"acdet_check"] forState:UIControlStateNormal];
    }
}

- (IBAction) pressSingOutButton:(UIButton*)sender
{
    sender.enabled = NO;
    [self.networkManager logOutWithSuccessBlock:^{
        
        [AppEngine shared].logginedWithPhone = NO;
        [AppEngine shared].logginedWithFB = NO;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failureBlock:^(NSError *error) {
        
        sender.enabled = YES;
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        
    }];
    
}

- (void) favouriteWithButton:(UIButton*)sender {
    
    [self.networkManager getUserNotificationItemFavouritedWithSuccessBlock:^(BOOL isFavourite) {
        
        if (isFavourite) {
            
            [sender setImage:[UIImage imageNamed:@"acdet_check"] forState:UIControlStateNormal];
            self.isFavorItem = YES;
            
        } else {
            
            [sender setImage:[UIImage imageNamed:@"acdet_checkempty"] forState:UIControlStateNormal];
            self.isFavorItem = NO;
        }
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:error.localizedDescription];
    }];
}

@end
