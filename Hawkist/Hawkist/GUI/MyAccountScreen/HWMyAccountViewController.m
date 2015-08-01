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

@interface HWMyAccountViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *accountDetailsArray;
@property (nonatomic, strong) NSArray *paymentOptionsArray;
@property (nonatomic, strong) NSArray *sharingAndNitificationsArray;

@property(nonatomic, strong) NSArray *nameForGroupArray;
@property (nonatomic, strong) NSArray *groupArray;


@end

@implementation HWMyAccountViewController

#define menuCellIdentifier @"accountMenuCell"

-(instancetype) init{
    
    self = [super initWithNibName: @"HWMyAccountVIew" bundle: nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight =  63;//56.0;

    
    [self.tableView registerNib:[UINib nibWithNibName:@"HWAccountMenuCell" bundle:nil] forCellReuseIdentifier:menuCellIdentifier];
    
    [self setupMenuArray];
    
}

- (void) setupMenuArray
{
    self.accountDetailsArray = @[
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"username" withTitle:@"User name"],
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"email" withTitle:@"Email Address"],
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"about me" withTitle:@"About Me"],
                                ];
    
    self.paymentOptionsArray = @[
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"manage" withTitle:@"Manage Bank Cards"],
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"manageAd" withTitle:@"Manage Addresses"]
                                ];
    
    self.sharingAndNitificationsArray = @[
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"manage" withTitle:@"Mobile Notifications"],
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"manageAd" withTitle:@"Email Notifications"]
                                 ];

    self.nameForGroupArray = @[@"ACCOUNT DETAILS", @"PAYMENT OPTIONS", @"SHARING AND NOTIFICATIONS", @"PRIVACY"];
    
    self.groupArray = @[_accountDetailsArray, _paymentOptionsArray,_sharingAndNitificationsArray];
    
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
    
    HWAccountMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
    
    NSArray *ar = [self.groupArray objectAtIndex:indexPath.section];
    HWAccountMenuDataModel * model = [ar objectAtIndex:indexPath.row];
    [cell setCellWithMenuDataModel:model];
    
    return cell;
    
}





- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *groupName = [self.nameForGroupArray objectAtIndex:section];
    return groupName;
}
#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
    
}
@end
