//
//  LoginViewController.m
//  
//
//  Created by Anton on 6/15/15.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray* arr = [[NSBundle mainBundle]loadNibNamed:@"Login" owner:self options:nil];
   
    UIView* v = [arr objectAtIndex:0];
    
    v.frame = self.view.frame;
    
    [self.view addSubview:v];
    // Do any additional setup after loading the view.
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

@end
