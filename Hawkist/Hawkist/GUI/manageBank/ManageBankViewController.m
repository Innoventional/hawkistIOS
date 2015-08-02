//
//  ManageBankViewController.m
//  Hawkist
//
//  Created by Anton on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "ManageBankViewController.h"
#import "cardView.h"

@interface ManageBankViewController ()
@property (nonatomic,strong)NSArray* cards;
@end

@implementation ManageBankViewController

- (instancetype)init
{
    self = [super initWithNibName: @"ManageBankView" bundle: [NSBundle mainBundle]];
    if(self)
    {
        
    }
    return self;
}

-(void)viewDidLoad
{
self.navigation.delegate = self;
    
    HWCard* card1 = [[HWCard alloc]init];
    
    card1.cardName = @"my Great Card";
    
    card1.lastNumber = @"9873";
    
    card1.month = @"05";
    
    card1.year = @"10";
    
    self.cards = [NSArray arrayWithObjects:card1, nil];
}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cards count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        [cell addSubview:[[cardView alloc]init]];
    }
    
    return cell;
}

@end
