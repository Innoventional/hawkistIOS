//
//  SettingsViewController.m
//  Hawkist
//
//  Created by Anton on 05.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "SettingsViewController.h"
#import "HWAccountMenuCell.h"
#import "StarRatingControl.h"
#import "HWMyAccountViewController.h"
#import "PersonalisationViewController.h"
#import "HWMyOrdersViewController.h"
#import "HWProfileViewController.h"
#import "myFavouritesViewController.h"
#import "HolidayModeViewController.h"
#import "HWMyBalanceViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sectionFirst;
@property (nonatomic, strong) NSArray *sectionSecond;
@property (nonatomic, strong) NSArray *sectionThird;
@property (nonatomic, strong) NSArray *sectionFourth;

@property (nonatomic, strong) NSArray *groupArray;

@property (weak, nonatomic) IBOutlet UILabel *raiting;
@property (weak, nonatomic) IBOutlet StarRatingControl *starRatingControl;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

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
    
    HWUser* userInfo = [AppEngine shared].user;

    self.starRatingControl.rating = [userInfo.rating integerValue];
    self.userName.text = userInfo.username;
    self.raiting.text = [NSString stringWithFormat:@"%@ (%@ reviews)", userInfo.rating,userInfo.review];
    
    [self avatarInit:userInfo.avatar];
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width /2;
    self.avatar.layer.masksToBounds = YES;
}


- (void) avatarInit:(NSString*)url
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.avatar setImageWithURLRequest:request
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              
                                              self.avatar.image = image;
                                              
                                              
                                          });
                                          
                                          
                                      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                          
                                          
                                          self.avatar.image = [UIImage imageNamed:@"noPhoto"];
                                      }];
    
    
    
    
}

- (void) setupMenuArray
{
    self.sectionFirst = @[
                          [[HWAccountMenuDataModel alloc]initWithImageName:@"1" withTitle:@"Manage My Account"]];
    
    self.sectionSecond = @[
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"2" withTitle:@"My Favourites"],
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"3" withTitle:@"My Balance"],
                                 [[HWAccountMenuDataModel alloc]initWithImageName:@"4" withTitle:@"My Orders"],
                                [[HWAccountMenuDataModel alloc]initWithImageName:@"5" withTitle:@"Personalisation"]
                                 ];
    
    self.sectionThird = @[
                                          [[HWAccountMenuDataModel alloc]initWithImageName:@"6" withTitle:@"Holiday Mode"]
                                          ];
    self.sectionFourth = @[
                           [[HWAccountMenuDataModel alloc]initWithImageName:@"7" withTitle:@"Find Friends"]
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
            
            [self sectionFirst:indexPath.row];
            break;
        case 1:
            
            [self sectionSecond:indexPath.row];
            break;
        case 2:
            
            [self sectionThird:indexPath.row];
            break;
            
        case 3:
            
            [self sectionFourth:indexPath.row];
            break;
            
        default:
            break;
    }
    
}




-(void)sectionFirst:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            //NSLog(@"Manage My account");
            HWMyAccountViewController *vc = [[HWMyAccountViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        default:
            break;
    }
}


-(void)sectionSecond:(NSInteger)row

{
    switch (row) {
        case 0:
        {
            NSLog(@"My Fav");
            myFavouritesViewController *vc = [[myFavouritesViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
            break;
        }
        case 1:
        {
            HWMyBalanceViewController *vc = [[HWMyBalanceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            NSLog(@"My Balance");
            break;
        }
        case 2:
        {
            HWMyOrdersViewController *vc = [[HWMyOrdersViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            NSLog(@"My Orgers");
            break;
        }
        case 3:{
            PersonalisationViewController* vc = [[PersonalisationViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            break;
        }
        default:
            break;
    }
}

-(void)sectionThird:(NSInteger)row

{
    
    switch (row) {
        case 0:
        {
            HolidayModeViewController *vc = [[HolidayModeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"Holiday Mode");
            break;
        }
        default:
            break;
    }
    
    
}

-(void)sectionFourth:(NSInteger)row

{
    
    switch (row) {
        case 0:
            
            NSLog(@"Find Friends");
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
- (IBAction)nickNameSelect:(id)sender {
    
    HWProfileViewController *profileVC = [[HWProfileViewController alloc] initWithUserID:[AppEngine shared].user.id];
    
    [self.navigationController pushViewController:profileVC animated:YES];
}


@end
