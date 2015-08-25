//
//  NotificationScreenViewController.m
//  Hawkist
//
//  Created by Anton on 25.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "NotificationScreenViewController.h"
#import "NotificationCell.h"

@interface NotificationScreenViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *messages;
@end

@implementation NotificationScreenViewController
#define notificationCellIdentifier @"notification"

- (instancetype) init{
    
    self = [super initWithNibName: @"NotificationScreen" bundle: nil];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"NotificationCell" bundle:nil] forCellReuseIdentifier:notificationCellIdentifier];
    
    
    self.messages = [NSMutableArray arrayWithObject:@"ad"];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [[NetworkManager shared] getNotifications:^(NSArray *notifications) {
//        
//        self.messages = [NSMutableArray arrayWithArray:notifications];
//        
//    } failureBlock:^(NSError *error) {
//        
//        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
//    }];
    
    
    [[NetworkManager shared]getNotificationsCount:^(NSInteger count) {
        
        NSLog(@"%ld",count);
        
    } failureBlock:^(NSError *error) {
        
         [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        
        NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:notificationCellIdentifier forIndexPath:indexPath];
//        cell = [self setupCommentCell:cell withIndexPath:indexPath];
        return cell;
    
}


@end
