//
//  HolidayModeViewController.m
//  Hawkist
//
//  Created by Anton on 21.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HolidayModeViewController.h"


@interface HolidayModeViewController ()


@property (strong, nonatomic) IBOutlet NavigationVIew *navigation;
@property (strong, nonatomic) IBOutlet UISwitch *switchOutlet;

@end

@implementation HolidayModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigation.delegate = self;
    self.navigation.title.text = @"Holiday Mode";
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NetworkManager shared]getHolidayMode:^(BOOL *enabled) {
        
        self.switchOutlet.on = enabled;
    } failureBlock:^(NSError *error) {
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        
    }];
}

- (instancetype)init
{
    self = [super initWithNibName: @"holidayMode" bundle: [NSBundle mainBundle]];
    if(self)
    {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeSwitch:(id)sender {
    
    [self showHud];
        [[NetworkManager shared] updateHolidayMode:self.switchOutlet.on successBlock:^{
            
                [self hideHud];
        } failureBlock:^(NSError *error) {
            [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];

            [self hideHud];
        }];
}
@end
