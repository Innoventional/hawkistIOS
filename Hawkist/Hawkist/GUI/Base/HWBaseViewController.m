//
//  HWBaseViewController.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/16/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWBaseViewController.h"
#import "LoginViewController.h"

@interface HWBaseViewController ()

@end

@implementation HWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Public

- (void) showHud
{
    [MBProgressHUD showHUDAddedTo: self.view animated: YES];
}

- (void) hideHud
{
    [MBProgressHUD hideAllHUDsForView: self.view animated: YES];
}

- (void) showAlertWithTitle:(NSString*)title Message:(NSString*) message
{
    if ([title isEqualToString:@"No Connection"]&& self.isInternetConnectionAlertShowed)
    {
        return;
    }
        else
        {
            if ([title isEqualToString:@"No Connection"])
            {
                self.isInternetConnectionAlertShowed = YES;
            }
        
    NSLog(@"%@",message);
    
            if ([message isEqualToString:@"Unauthorized"]||[title isEqualToString:@"Account Is Suspended"])
        
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //LoginViewController* vc = [[LoginViewController alloc]init];
            [self.navigationController popToRootViewControllerAnimated:NO];

            
        });

        
    }
            
  //  dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc]initWithTitle:title
                                   message:message
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil] show];
        
  //  });
        
        
            
            
        };
}


- (void) showAlertWithTitle:(NSString*)title Message:(NSString*) message withDelegate:(id)delegate
{
    if ([title isEqualToString:@"No Connection"]&& self.isInternetConnectionAlertShowed)
    {
        return;
    }
    else
    {
        if ([title isEqualToString:@"No Connection"])
        {
            self.isInternetConnectionAlertShowed = YES;
        }
        
        NSLog(@"%@",message);
        
        
            [[[UIAlertView alloc]initWithTitle:title
                                       message:message
                                      delegate:delegate
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil] show];
            
        
    };
}


@end
