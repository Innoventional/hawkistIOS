//
//  ChoiceTableViewController.m
//  Hawkist
//
//  Created by Anton on 06.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "ChoiceTableViewController.h"

@interface ChoiceTableViewController ()

@end

@implementation ChoiceTableViewController
@synthesize navigationView;

@synthesize items;

- (instancetype) init
{
 
    {
        UIView* v = [[[NSBundle mainBundle]loadNibNamed:@"ChoiceTable" owner:self options:nil]firstObject];
        
         v.frame = self.view.frame;
        
        [self.view addSubview:v];
        
        navigationView.delegate = self;
        
        [navigationView.leftButtonOutlet setBackgroundImage:[UIImage imageNamed:@"acdet_back"] forState:UIControlStateNormal];
        [navigationView.leftButtonOutlet setTitle:@"" forState:UIControlStateNormal];
        [navigationView.rightButtonOutlet setTitle:@"" forState:UIControlStateNormal];

        [navigationView.title setTextColor:[UIColor whiteColor]];
        navigationView.rightButtonOutlet.enabled = NO;

    }
    return self;
}

-(void) leftButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
    }
    
    cell.detailTextLabel.text = [items objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(SelectedItemFrom:WithName:)])
        [self.delegate SelectedItemFrom:self.sender WithName:[items objectAtIndex:indexPath.row]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
