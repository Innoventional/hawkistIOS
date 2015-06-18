//
//  AccountDetailViewController.m
//  Hawkist
//
//  Created by Anton on 6/17/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "AccountDetailViewController.h"

@interface AccountDetailViewController ()
@property (nonatomic,strong) UIView* accountDetailView;
@property (nonatomic, assign) BOOL* isContinueEnable;
@end

@implementation AccountDetailViewController

- (instancetype) init
{
    self = [super initWithNibName: @"AccountDetailView" bundle: [NSBundle mainBundle]];
    if(self)
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"USERNAME" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtUserName.attributedPlaceholder = str;
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"EMAIL ADDRESS" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtEmail.attributedPlaceholder = str2;
    
    self.isContinueEnable = false;
    
    
    

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

- (IBAction)checkBox:(id)sender {
    
    if ([sender tag] == 2)
    {
        self.checkBox2.selected =!self.checkBox2.selected;
    }
    if ([sender tag] == 1)
    {
        self.checkbox1.selected =!self.checkbox1.selected;
    }
    
    if (self.checkbox1.selected && self.checkBox2.selected)
    {
        self.btnContinue.hidden = false;
    }
    else
    {
    self.btnContinue.hidden = true;
    }
}


@end
