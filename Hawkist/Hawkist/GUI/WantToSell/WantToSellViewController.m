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
#import "SocialManager.h"
#import "NetworkManager.h"

@interface WantToSellViewController () <UIAlertViewDelegate>
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

- (void) viewDidAppear:(BOOL)animated
{
    self.isInternetConnectionAlertShowed = NO;
    
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
    
    [[NetworkManager shared]check_selling_ability:^{
        
        if ([[AppEngine shared].user.facebook_id isEqualToString:@""])
        {
            [[[UIAlertView alloc]initWithTitle:@"Facebook Account Required" message:@"In order to sell on Hawkist, you must connect a Facebook account to verify your identity." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];
        }
        else
            [self.navigationController pushViewController: [[SellAnItemViewController alloc] init]  animated: YES];
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self showHud];
        [[SocialManager shared] loginFacebookSuccess:^(NSDictionary *response) {
            [[NetworkManager shared] linkFacebookAccountWithToken:[response objectForKey:SocialToken] successBlock:^(HWUser *user) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideHud];
                });
                
        [self.navigationController pushViewController: [[SellAnItemViewController alloc] init]  animated: YES];
                
            } failureBlock:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideHud];
                });
                 [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            }];
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
            });
            [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }];
    }
}
@end
