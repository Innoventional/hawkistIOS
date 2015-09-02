//
//  NotificationSettingsViewController.m
//  Hawkist
//
//  Created by Anton on 02.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "NotificationSettingsViewController.h"
#import "NavigationVIew.h"
#import "NotificationSettingsModel.h"
#import "PushNotificationTableViewCell.h"

@interface NotificationSettingsViewController () <NavigationViewDelegate,UITableViewDataSource,UITableViewDelegate,PushNotificationTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet NavigationVIew *navigation;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *highPriorityNotifications;
@property (nonatomic, strong) NSArray *lowPriorityNotifications;
@property (nonatomic, strong) NSArray *enableNotifications;

@property(nonatomic, strong) NSArray *nameForGroupArray;
@property (nonatomic, strong) NSArray *groupArray;
@end

@implementation NotificationSettingsViewController

#define CellIdentifier @"NotificationSettingsCell"


-(instancetype) init{
    
    self = [super initWithNibName: @"PushNotificationSettings" bundle: nil];
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight =  45;
    
    self.navigation.delegate = self;
    self.navigation.title.text = @"Mobile Notifications";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PushNotificationSettingsCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
  
    [self setupMenuArray];
    
}

- (void) setupMenuArray
{
    self.highPriorityNotifications = @[
                                 [[NotificationSettingsModel alloc]initWithImageName:@"Notification_newComment" withTitle:@"New Comments" withStatus:YES withType:0],
                                  [[NotificationSettingsModel alloc]initWithImageName:@"Notification_itemsold" withTitle:@"Item Sold" withStatus:YES withType:1],
                                  [[NotificationSettingsModel alloc]initWithImageName:@"Notification_ItemRecieved" withTitle:@"Item Received" withStatus:YES withType:2],
                                  [[NotificationSettingsModel alloc]initWithImageName:@"Notification_newfeedback" withTitle:@"New FeedBack" withStatus:YES withType:3],
                                  [[NotificationSettingsModel alloc]initWithImageName:@"Notification_fundsrel" withTitle:@"Founds Released" withStatus:YES withType:4]
                                 ];
    
    self.lowPriorityNotifications = @[
                                      [[NotificationSettingsModel alloc]initWithImageName:@"Notification_LeaveFeedback" withTitle:@"Leave Feedback" withStatus:YES withType:5],
                                      [[NotificationSettingsModel alloc]initWithImageName:@"Notification_itemfav" withTitle:@"Item is Favourited" withStatus:YES withType:6],
                                      [[NotificationSettingsModel alloc]initWithImageName:@"Notification_fitemsold" withTitle:@"A Favourite item is Sold" withStatus:YES withType:7],
                                      [[NotificationSettingsModel alloc]initWithImageName:@"Notification_newfollowers" withTitle:@"New Followers" withStatus:YES withType:8],
                                      [[NotificationSettingsModel alloc]initWithImageName:@"Notification_newitem" withTitle:@"New Items" withStatus:YES withType:9],
                                      [[NotificationSettingsModel alloc]initWithImageName:@"Notification_mentions" withTitle:@"Mentions" withStatus:YES withType:10]
                                 ];
    
    self.enableNotifications = @[
                                       [[NotificationSettingsModel alloc]initWithImageName:@"Notification_Enable" withTitle:@"Enable Push Notifications" withStatus:YES withType:11]
                                       ];

    

    self.nameForGroupArray = @[@"HIGH PRIORITY NOTIFICATIONS", @"LOW PRIORITY NOTIFICATIONS", @""];
    
    self.groupArray = @[self.highPriorityNotifications, self.lowPriorityNotifications,self.enableNotifications];
    
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
    
    NotificationSettingsModel * model = [ar objectAtIndex:indexPath.row];
    
    PushNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setCellWithMenuDataModel:model];
    
    cell.delegate = self;

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
    if (section == 2)
        return 17;
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


- (void) changed:(id)sender
{
    PushNotificationTableViewCell *cell = (PushNotificationTableViewCell*)sender;
    
    NSLog(@"tag - %ld, status - %d", [cell getType], [cell getValue]);
}



@end