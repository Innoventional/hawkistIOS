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
#import "HWTag+Extensions.h"

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
//    for (HWTag* tag in items)
//    {
//        if ([tag.platforms.name isEqualToString:self.previousSelected])
//        {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[items indexOfObject:tag] inSection:0];
//            [self.table selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//        }
//    }
   
    
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
        
        cell = [[ChoiceCellView alloc]init];
    }
    
    NSObject* currentItem = [items objectAtIndex:indexPath.row];
    
    if ([currentItem isKindOfClass:[HWCategory class]])
              {
                  cell.myLabel.text = ((HWCategory*)currentItem).name;
                  cell.forwardImage.hidden = NO;
              }
    else
    {
        cell.myLabel.text = ((HWTag*)currentItem).name;
        cell.forwardImage.hidden = YES;
        
         if ([currentItem isKindOfClass:[HWColor class]])
         {
             NSString* hex = ((HWColor*)currentItem).code;
             if (![hex isEqualToString:@""])
                // [cell setBackgroundColor:[HWTag colorWithHexString:hex]];
             {
                 cell.colorView.hidden = NO;
                 UIColor* color = [HWTag colorWithHexString:hex];
                 [cell.colorView setBackgroundColor:color];
                 
                 cell.colorView.layer.cornerRadius = cell.colorView.width/2;
                 
                 
                 [cell.colorView.layer setBorderColor:[HWTag darkerColorForColor:color].CGColor];
                 cell.colorView.layer.borderWidth = 1.0f;
             
             }
                
         }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSObject* currentItem = [items objectAtIndex:indexPath.row];
    
    if ([currentItem isKindOfClass:[HWCategory class]])
    {
        ChoiceTableViewController* v= [[ChoiceTableViewController alloc]init];
        
        
                v.items = [NSMutableArray arrayWithArray:((HWCategory*)currentItem).subcategories];
        
                v.navigationView.title.text = @"Select a Subcategory";
        
                v.delegate = self.delegate;
        
                v.sender = self.sender;
        
                [self.navigationController pushViewController:v animated:YES];
        
    }
    
    else
    {
        if (self.delegate && [self.delegate respondsToSelector: @selector(SelectedItemFrom:WithItem:)])
            [self.delegate SelectedItemFrom:self.sender WithItem:currentItem];
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }
    
   
    
    
// //  if (!currentItem.children|| self.isPlatform)
//   {
//       if (self.delegate && [self.delegate respondsToSelector: @selector(SelectedItemFrom:WithItem:)])
//        [self.delegate SelectedItemFrom:self.sender WithItem:currentItem];
//       [self dismissViewControllerAnimated:YES completion:nil];
//   }
//    else
//    {
//        ChoiceTableViewController* v= [[ChoiceTableViewController alloc]init];
//        
//       
// //       v.items = [NSMutableArray arrayWithArray:currentItem.children];
    
//        v.navigationView.title.text = self.navigationView.title.text;
//        
//        v.delegate = self.delegate;
//        
//        v.sender = self.sender;
//        
//        [self.navigationController pushViewController:v animated:YES];
//        if (self.delegate && [self.delegate respondsToSelector: @selector(SelectedItemFrom:WithItem:)])
//            [self.delegate SelectedItemFrom:self.sender WithItem:currentItem];
//
   // }
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
