//
//  LoginViewController.m
//  
//
//  Created by Anton on 6/15/15.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()
//@property (nonatomic,strong) UIAlertView* getNumber;
//@property (nonatomic,strong) UIAlertView* getCode;

@property (nonatomic,strong) UIView* loginView;

@property (nonatomic,strong) UIView* numberDialog;

@property (nonatomic,strong) UIView* codeDialog;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray* arr = [[NSBundle mainBundle]loadNibNamed:@"Login" owner:self options:nil];
   
    _loginView = [arr objectAtIndex:0];
    
    _loginView.frame = self.view.frame;
    
    [self.view addSubview:_loginView];
    
//    _getNumber = [[UIAlertView alloc]initWithTitle:@"Enter mobile Number"
//                                           message:@"An SMS with your access code will sent to this number." delegate:self cancelButtonTitle:@"Send" otherButtonTitles:@"Cancel", nil];
//    _getNumber.tag = 1;
//    [_getNumber setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    _getCode = [[UIAlertView alloc]initWithTitle:nil message:@"Get your code" delegate:self cancelButtonTitle:@"Resend" otherButtonTitles:@"Ok", nil];
//    _getCode.tag = 2;
//    [_getCode setAlertViewStyle:UIAlertViewStylePlainTextInput];

    // Do any additional setup after loading the view.
    
    arr = [[NSBundle mainBundle]loadNibNamed:@"CodeAlertView" owner:self options:nil];
    
    _codeDialog = [arr objectAtIndex:0];
    
    CGSize rectSize= self.view.frame.size;
    
    _codeDialog.frame = CGRectMake(20, 40, rectSize.width-40, (rectSize.width-40)/2);
    
    
    [self.view addSubview:_codeDialog];
    
    [_codeDialog setHidden:YES];
    
    arr = [[NSBundle mainBundle]loadNibNamed:@"CustomAlertView" owner:self options:nil];
    
    _numberDialog= [arr objectAtIndex:0];
    
    
    _numberDialog.frame = CGRectMake(20, 20, rectSize.width-40, rectSize.width-40);
    
    
    [self.view addSubview:_numberDialog];
    
    [_numberDialog setHidden:YES];
    
    
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


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1)
//    {
//        if (alertView.tag == 2)
//            [self verify:[_getCode textFieldAtIndex:0].text];
//        if (alertView.tag == 1)
//            [self cancel];
//        return;
//    }
//    
//    if (alertView.tag ==1)
//    {
//        [self sendSMS:[_getNumber textFieldAtIndex:0].text];
//        [_getCode show];
//    }
//    if (alertView.tag == 2) {
//        
//        [_getNumber show];
//        
//        
//    }
//}

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
   // [_getNumber show];
    [_numberDialog setHidden:NO];


}

- (IBAction)btnSignUpFB:(id)sender {
}

- (IBAction)btnCancel:(id)sender {
    if (!_numberDialog.hidden)
    {
        [_numberDialog setHidden:YES];
    }
    if (!_codeDialog.hidden)
        [_codeDialog setHidden:YES];
    _txtNumber.text = @"";
    _txtCode.text = @"";
}

- (IBAction)btnSend:(id)sender {
    [_codeDialog setHidden:NO];
    [_numberDialog setHidden:YES];

}

- (IBAction)btnResend:(id)sender {
    [_codeDialog setHidden:YES];
    [_numberDialog setHidden:YES];
}



- (IBAction)btnCancelCode:(id)sender {
    [_codeDialog setHidden:YES];
    [_numberDialog setHidden:NO];
}

- (IBAction)btnSignIn:(id)sender {
}
@end
