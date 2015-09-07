//
//  AboutViewController.m
//  Hawkist
//
//  Created by Anton on 08.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "AboutViewController.h"
#import "NavigationVIew.h"

@interface AboutViewController () <NavigationViewDelegate>
@property (strong, nonatomic) IBOutlet NavigationVIew *navigation;

@end

@implementation AboutViewController

-(instancetype) init{
    
    self = [super initWithNibName: @"AboutView" bundle: nil];
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigation.delegate = self;
    self.navigation.title.text = @"About Hawkist";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
