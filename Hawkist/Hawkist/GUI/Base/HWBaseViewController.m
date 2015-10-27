//
//  HWBaseViewController.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/16/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWBaseViewController.h"
#import "LoginViewController.h"
#import "AFNetworking.h"
#import <FBSDKAppEvents.h>

@interface HWBaseViewController ()

@property (nonatomic, strong) UIView *noConnectView;

@end

@implementation HWBaseViewController

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:)
                                                 name: AFNetworkingReachabilityDidChangeNotification
                                               object:nil];

    

    
}

-(void) viewDidDisappear:(BOOL)animated {
    
    
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AFNetworkingReachabilityDidChangeNotification
                                                  object:nil];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.noConnectView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.noConnectView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.noConnectView];
    CGRect frLabel = self.noConnectView.bounds;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frLabel.size.width - 20, frLabel.size.height - 20)];
    
    
    label.text = @"Connection Error\n\nCould not complete the last action. Please try again.";
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
    [self.noConnectView addSubview:label];
    
    label.center = self.noConnectView.center;
    
    
    
    self.noConnectView.hidden = YES;
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - notification method

- (void)reachabilityDidChange:(NSNotification *)notification {
   
    NSNumber *status = [notification userInfo][AFNetworkingReachabilityNotificationStatusItem];
    
     [self.view bringSubviewToFront:self.noConnectView];
    
    switch ([status integerValue]) {
        case 0:
            
            NSLog(@"Net ineta");
            
            if(self.noConnectView.hidden) {
                
                self.noConnectView.hidden = NO;
                
            } else {
                
                return;
            }
            

            break;
        
        default:
            
            if(self.noConnectView.hidden) {
                
                return;
            } else {
                
                self.noConnectView.hidden = YES;
                
                [self viewDidLoad];
            }
            
            NSLog(@"Est inet");
            break;
    }

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
   // [self.navigationController popViewControllerAnimated:NO];
    
    
    if (![self.noConnectView isHidden])
    {
        return;
    }
    
    
    if ([title isEqualToString:@"Connection Error"]&& self.isInternetConnectionAlertShowed)
    {
        return;
    }
        else
        {
            if ([title isEqualToString:@"Connection Error"])
            {
                self.isInternetConnectionAlertShowed = YES;
            }
        
    NSLog(@"%@",message);
    
            if ([message isEqualToString:@"Unauthorized"]||[title isEqualToString:@"Account Is Suspended"])
        
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //LoginViewController* vc = [[LoginViewController alloc]init];
            [AppEngine shared].logginedWithPhone = NO;
            [AppEngine shared].logginedWithFB = NO;
            [self.navigationController popToRootViewControllerAnimated:NO];

            
        });

        
    }
            
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc]initWithTitle:title
                                   message:message
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil] show];
        
        
        

        
    });
        
        
            
            
        };
}


//- (void) showAlertWithTitle:(NSString*)title Message:(NSString*) message withDelegate:(id)delegate
//{
//    if ([title isEqualToString:@"Connection Error"]&& self.isInternetConnectionAlertShowed)
//    {
//        return;
//    }
//    else
//    {
//        if ([title isEqualToString:@"Connection Error"])
//        {
//            self.isInternetConnectionAlertShowed = YES;
//        }
//        
//        NSLog(@"%@",message);
//        
//        
//            [[[UIAlertView alloc]initWithTitle:title
//                                       message:message
//                                      delegate:delegate
//                             cancelButtonTitle:@"OK"
//                             otherButtonTitles:nil] show];
//        
//        
//        
//    };
//}


@end
