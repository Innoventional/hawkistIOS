//
//  SettingsViewController.m
//  Hawkist
//
//  Created by Anton on 05.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "SettingsViewController.h"
#import "HWAccountMenuCell.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sectionFirst;
@property (nonatomic, strong) NSArray *sectionSecond;
@property (nonatomic, strong) NSArray *sectionThird;
@property (nonatomic, strong) NSArray *sectionFourth;

@property (nonatomic, strong) NSArray *groupArray;

@end

@implementation SettingsViewController
#define menuCellIdentifier @"HWAccountMenuCell"

- (instancetype) init{
    
    self = [super initWithNibName: @"SettingView" bundle: nil];
    
    return self;
}


- (void) viewDidLoad
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight =  63;//56.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HWAccountMenuCell" bundle:nil] forCellReuseIdentifier:menuCellIdentifier];
    
    [self setupMenuArray];

}

- (void) setupMenuArray
{
    self.sectionFirst = @[
                          [[HWAccountMenuDataModel alloc]initWithImageName:@"username" withTitle:@"Manage My Account"]];
    
    self.sectionSecond = @[
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"manage" withTitle:@"My Favourites"],
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"manageAd" withTitle:@"My Balance"],
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"manage" withTitle:@"My Orders"],
                                [[HWAccountMenuDataModel alloc]initWithImageName:@"manage" withTitle:@"Personalisation"]
                                 ];
    
    self.sectionThird = @[
                                          [[HWAccountMenuDataModel alloc]initWithImageName:@"manage" withTitle:@"Holiday Mode"]
                                          ];
    self.sectionFourth = @[
                           [[HWAccountMenuDataModel alloc]initWithImageName:@"manage" withTitle:@"Find Friends"]
                           ];

    
    self.groupArray = @[self.sectionFirst, self.sectionSecond,self.sectionThird,self.sectionFourth];
    
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
   // NSString *groupName = [self.nameForGroupArray objectAtIndex:section];
    return @"";
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
            
            NSLog(@"User name");
            break;
            
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
            
            NSLog(@"Manage Bank Cards");
            break;
            
        case 1:
            
            NSLog(@"Manage Addresses");
            break;
            
        default:
            break;
    }
}

-(void)selectSharingAndNotifications:(NSInteger)row

{
    
    switch (row) {
        case 0:
            
            NSLog(@"Mobile Notifications");
            break;
            
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
    return 20;
    
}


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


@end
