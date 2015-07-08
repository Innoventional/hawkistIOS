//
//  ChoiceTableViewController.m
//  Hawkist
//
//  Created by Anton on 06.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "ChoiceTableViewController.h"
#import "ChoiceCellView.h"
#import "HWTag.h"

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
        
        [navigationView.leftButtonOutlet setImage:[UIImage imageNamed:@"acdet_back"] forState:UIControlStateNormal];
        [navigationView.leftButtonOutlet setTitle:@" Sell" forState:UIControlStateNormal];
        [navigationView.rightButtonOutlet setTitle:@"" forState:UIControlStateNormal];

        [navigationView.title setTextColor:[UIColor whiteColor]];
        navigationView.rightButtonOutlet.enabled = NO;
        

        self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
//    long index;//= [items indexOfObject:self.previousSelected];
//    
    for (HWTag* tag in items)
    {
        if ([tag.name isEqualToString:self.previousSelected])
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[items indexOfObject:tag] inSection:0];
            [self.table selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
   
    
}

-(void) leftButtonClick
{
    if (self.navigationController.viewControllers.count>1)
        [self.navigationController popViewControllerAnimated:YES];
    else
         [self dismissViewControllerAnimated:YES completion:nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"Cell";
    ChoiceCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell==nil) {
        
        
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell = [[ChoiceCellView alloc]init];
    }
    
    HWTag* currentItem = [items objectAtIndex:indexPath.row];
    
    cell.myLabel.text = currentItem.name;
    
    if (!currentItem.children || self.isPlatform)
        cell.forwardImage.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWTag* currentItem = [items objectAtIndex:indexPath.row];
    
    
   if (!currentItem.children|| self.isPlatform)
   {
       if (self.delegate && [self.delegate respondsToSelector: @selector(SelectedItemFrom:WithItem:)])
        [self.delegate SelectedItemFrom:self.sender WithItem:currentItem];
       [self dismissViewControllerAnimated:YES completion:nil];
   }
    else
    {
        ChoiceTableViewController* v= [[ChoiceTableViewController alloc]init];
        
       
        v.items = [NSMutableArray arrayWithArray:currentItem.children];
        
        v.navigationView.title.text = self.navigationView.title.text;
        
        v.delegate = self.delegate;
        
        v.sender = self.sender;
        
        [self.navigationController pushViewController:v animated:YES];

    }
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