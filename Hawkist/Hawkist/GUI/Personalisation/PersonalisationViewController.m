//
//  PersonalisationViewController.m
//  Hawkist
//
//  Created by Anton on 06.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "PersonalisationViewController.h"

@interface PersonalisationViewController ()

@end

@implementation PersonalisationViewController

- (instancetype)init
{
    self = [super initWithNibName: @"PersonalisationView" bundle: [NSBundle mainBundle]];
    if(self)
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigation.delegate = self;
    self.navigation.title.text = @"Personalisation Settings";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:NO];
}

@end
