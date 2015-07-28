//
//  WantToSellViewController.m
//  Hawkist
//
//  Created by Anton on 30.06.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "WantToSellViewController.h"
#import "SellAnItemViewController.h"
#import "myItemsViewController.h"

@interface WantToSellViewController ()
@property (nonatomic,strong) MyItemsViewController* itemsViewController;
@end

@implementation WantToSellViewController
@synthesize itemsViewController;

- (instancetype) init
{
    self = [super initWithNibName: @"WantToSell" bundle: [NSBundle mainBundle]];
    if(self)
    {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    itemsViewController = [[MyItemsViewController alloc]init];
    
    itemsViewController.view.frame = self.contentView.frame;
    
    [self.view addSubview: itemsViewController.view];
    
    
    [self addChildViewController:itemsViewController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnWantToSell:(id)sender {
    [self.navigationController pushViewController: [[SellAnItemViewController alloc] init]  animated: YES];
    
}
@end
