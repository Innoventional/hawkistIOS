//
//  SupportScreenViewController.m
//  Hawkist
//
//  Created by Anton on 25.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "SupportScreenViewController.h"
#import "HWAccountMenuCell.h"
#import "WebViewController.h"
#import "HWZendesk.h"


@interface SupportScreenViewController () <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *sectionFirst;
@property (nonatomic, strong) NSArray *sectionSecond;
@property (nonatomic, strong) NSArray *sectionThird;
@property (nonatomic, strong) NSArray *groupArray;
@property(nonatomic, strong) NSArray *nameForGroupArray;

@end

@implementation SupportScreenViewController
#define menuCellIdentifier @"CELL"

- (instancetype) init{
    
    self = [super initWithNibName: @"supportScreen" bundle: nil];
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
                          [[HWAccountMenuDataModel alloc]initWithImageName:@"faq" withTitle:@"FAQs & Support"],
                          [[HWAccountMenuDataModel alloc]initWithImageName:@"maccount" withTitle:@"Managing My Account"],
                          [[HWAccountMenuDataModel alloc]initWithImageName:@"buysell" withTitle:@"Buying & Selling"],
                          [[HWAccountMenuDataModel alloc]initWithImageName:@"moreabout" withTitle:@"More About Hawkist"]
];
    
    self.sectionSecond = @[
                           [[HWAccountMenuDataModel alloc]initWithImageName:@"comment" withTitle:@"Comments and Suggestions are welcome"]];
    
    self.sectionThird = @[
                          [[HWAccountMenuDataModel alloc]initWithImageName:@"refund" withTitle:@"Refund Policy"],
                          [[HWAccountMenuDataModel alloc]initWithImageName:@"privacy" withTitle:@"Privacy Policy"],
                          [[HWAccountMenuDataModel alloc]initWithImageName:@"terms" withTitle:@"Terms and Conditions"],
                          ];
    
    self.nameForGroupArray = @[@"STICKY POSTS", @"CONTACT HAWKIST SUPPORT", @"OUR POLICIES"];
    
    self.groupArray = @[self.sectionFirst, self.sectionSecond,self.sectionThird];
    
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
     NSString *groupName = [self.nameForGroupArray objectAtIndex:section];
    return groupName;
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

        default:
            break;
    }
    
}




-(void)sectionFirst:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            HWZendesk *zendesk = [HWZendesk shared];
            [zendesk supportView];
            
            NSLog(@"FAQs&Support");
            
            break;
        }
        case 1:
        {
            NSLog(@"Managing My Acc");
            
            break;
        }
        case 2:
        {
            NSLog(@"Buying");
            
            break;
        }
        case 3:
        {
            NSLog(@"More about");
            
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
            
            [[HWZendesk shared] myTiket];
            
            NSLog(@"Comments");
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
            NSLog(@"Refund Policy");
            break;
        }
        case 1:
        {
            NSLog(@"Privacy");
            WebViewController *vc = [[WebViewController alloc]initWithUrl:@"http://www.hawkist.com/privacy-policy/" andTitle:@"Privacy policy"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            NSLog(@"Terms");
            WebViewController *vc = [[WebViewController alloc]initWithUrl:@"http://www.hawkist.com/terms-conditions/" andTitle:@"Terms and Conditions"];
            [self.navigationController pushViewController:vc animated:YES];
            

            break;
        }
  
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


@end
