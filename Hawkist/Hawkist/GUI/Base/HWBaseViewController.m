//
//  HWBaseViewController.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/16/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWBaseViewController.h"

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

@end
