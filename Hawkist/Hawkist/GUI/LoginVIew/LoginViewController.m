//
//  LoginViewController.m
//  
//
//  Created by Anton on 6/15/15.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (nonatomic,strong) UIAlertView* getNumber;
@property (nonatomic,strong) UIAlertView* getCode;
@property (nonatomic,strong) UIView* loginView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray* arr = [[NSBundle mainBundle]loadNibNamed:@"Login" owner:self options:nil];
   
    _loginView = [arr objectAtIndex:0];
    
    _loginView.frame = self.view.frame;
    
    [self.view addSubview:_loginView];
    
    _getNumber = [[UIAlertView alloc]initWithTitle:@"Enter mobile Number"
                                           message:@"An SMS with your access code will sent to this number." delegate:self cancelButtonTitle:@"Send" otherButtonTitles:@"Cancel", nil];
    _getNumber.tag = 1;
    [_getNumber setAlertViewStyle:UIAlertViewStylePlainTextInput];
    _getCode = [[UIAlertView alloc]initWithTitle:nil message:@"Get your code" delegate:self cancelButtonTitle:@"Resend" otherButtonTitles:@"Ok", nil];
    _getCode.tag = 2;
    [_getCode setAlertViewStyle:UIAlertViewStylePlainTextInput];

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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 2)
            [self verify:[_getCode textFieldAtIndex:0].text];
        if (alertView.tag == 1)
            [self cancel];
        return;
    }
    
    if (alertView.tag ==1)
    {
        [self sendSMS:[_getNumber textFieldAtIndex:0].text];
        [_getCode show];
    }
    if (alertView.tag == 2) {
        
        [_getNumber show];
        
        
    }
}

- (void) cancel
{
    NSLog(@"%@",@"cancel");
}

- (void) sendSMS:(NSString*)number
{
    NSLog(@"%@",number);
}

- (void) verify:(NSString*) code
{
    NSLog(@"%@",code);
}




- (IBAction)btnSignUpMobile:(id)sender {
    [_getNumber show];
}

- (IBAction)btnSignUpFB:(id)sender {
}

- (IBAction)btnSignIn:(id)sender {
}
@end
