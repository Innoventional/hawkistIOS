//
//  HWProfileViewController.m
//  Hawkist
//
//  Created by User on 14.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWProfileViewController.h"
#import "NavigationVIew.h"

@interface HWProfileViewController () <NavigationViewDelegate>

@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarSeller;

@end

@implementation HWProfileViewController

#pragma mark-
#pragma mark Lifecycle


- (instancetype) init
{
    self = [super initWithNibName: @"HWProfileViewController" bundle: nil];
    
    if(self)
    {
    
    
    }
    
    
    return self;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark NavigationDelegate


-(void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) rightButtonClick
{
    
}


@end
