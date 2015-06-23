//
//  LoginViewController.m
//  
//
//  Created by Anton on 6/15/15.
//
//

#import "LoginViewController.h"
#import "NetworkManager.h"
#import "AppEngine.h"
#import "AccountDetailViewController.h"
#import "TutorialViewController.h"
#import "SocialManager.h"

@interface LoginViewController ()
//@property (nonatomic,strong) UIAlertView* getNumber;
//@property (nonatomic,strong) UIAlertView* getCode;

@property (nonatomic,strong) UIView* loginView;

@property (nonatomic,strong) UIView* numberDialog;

@property (nonatomic,strong) UIView* codeDialog;

@property (nonatomic,strong) NetworkManager* networkManager;
@property (nonatomic,strong) UIView* signIn;
@property (nonatomic,strong) AppEngine* engine;

@property (nonatomic,strong) AccountDetailViewController* accountDetailVC;

@property (nonatomic,strong) SocialManager* socManager;


@end




@implementation LoginViewController


- (void) showAlert: (NSError*)error
{
     NSLog(@"%@",error);
    dispatch_async(dispatch_get_main_queue(), ^{
    [[[UIAlertView alloc]initWithTitle:@"Error"
                               message:error.domain
                              delegate:nil
                     cancelButtonTitle:@"Ok"
                     otherButtonTitles:nil] show];
         });
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
   
    _socManager = [SocialManager shared];
    _engine = [AppEngine shared];
    
    if([AppEngine isFirsTimeLaunch])
    {
        [self presentViewController: [[TutorialViewController alloc] init] animated: YES completion:^{
            
        }];
    }
    
    _accountDetailVC= [[AccountDetailViewController alloc]init];
    
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
    
    _codeDialog.frame = CGRectMake(20, rectSize.height/2 - (rectSize.width-40)/2, rectSize.width-40, (rectSize.width-40)/2);
    
    
    [self.view addSubview:_codeDialog];
    
    [_codeDialog setHidden:YES];
    
    arr = [[NSBundle mainBundle]loadNibNamed:@"CustomAlertView" owner:self options:nil];
    
    _numberDialog= [arr objectAtIndex:0];
    
    
    _numberDialog.frame = CGRectMake(20, 60, rectSize.width-40, rectSize.width-80);
    
    
    [self.view addSubview:_numberDialog];
    
    [_numberDialog setHidden:YES];
    
    _networkManager = [NetworkManager shared];
    
    
    
    ///////signIn
    
   

    arr = [[NSBundle mainBundle]loadNibNamed:@"SignIn" owner:self options:nil];
    
    _signIn = [arr objectAtIndex:0];
    
    _signIn.frame = self.view.frame;
    
    [_signIn setHidden:YES];
    
    [self.view addSubview:_signIn];

    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"ENTER MOBILE NUMBER" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtMobileNum.attributedPlaceholder = str;
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"ENTER PIN" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtPin.attributedPlaceholder = str2;
    
    
    // [self registerForKeyboardNotifications];
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adjustKeyboardFrame:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideKeyboardFrame:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}

//- (void) deregisterForKeyBoardNotifications
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -
#pragma mark Keyboard


- (void) adjustKeyboardFrame: (NSNotification*) notification
{
    BOOL willHide = [notification.name isEqualToString: UIKeyboardWillHideNotification];
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeight = (CGRectGetMinY(keyboardFrame) < self.view.frame.size.height) ? CGRectGetHeight(keyboardFrame) : 0.0f;
    
    CGFloat bottomOffset = willHide ? 0.0f : keyboardHeight;
    //
    //    [self.scrollView setContentInset: UIEdgeInsetsMake(0, 0, bottomOffset, 0)];
    //    NSLog(@"%f-key",bottomOffset);
    
    CGRect newRect = CGRectMake(0, -bottomOffset, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.frame = newRect;
}

- (void) hideKeyboardFrame: (NSNotification*) notification
{
    CGRect newRect = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.frame = newRect;
    //
    //    [self.scrollView setContentInset: UIEdgeInsetsMake(0, 0, 0, 0)];
    
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




- (IBAction)btnSignUpMobile:(id)sender {
   
    [_numberDialog setHidden:NO];
    //[self deregisterForKeyBoardNotifications];


}

- (IBAction)btnSignUpFB:(id)sender {
    [_socManager loginFacebookSuccess:^(NSDictionary *response) {
        [_networkManager registerUserWithPhoneNumber:nil orFacebookToken:[response objectForKey:SocialToken] successBlock:^(HWUser *user) {
            _engine.user = user;
            [self.navigationController pushViewController:_accountDetailVC animated:(YES)];
            
        } failureBlock:^(NSError *error) {
            [self showAlert:error];
        }];
        
    } failure:^(NSError *error) {
       [self showAlert:error];
        
    }];

}

- (IBAction)btnCancel:(id)sender {
    if (!_numberDialog.hidden)
    {
        [_numberDialog setHidden:YES];
        [_txtNumber resignFirstResponder];
    }
    if (!_codeDialog.hidden){
        
        [_codeDialog setHidden:YES];
        [_txtCode resignFirstResponder];
    
    }
    _txtNumber.text = @"";
    _txtCode.text = @"";
    
    
    
}

- (IBAction)btnSend:(id)sender {
    [_codeDialog setHidden:NO];
    [_numberDialog setHidden:YES];
    [_txtNumber resignFirstResponder];
    [_networkManager registerUserWithPhoneNumber:_txtNumber.text orFacebookToken:nil successBlock:^(HWUser *user) {
        
        
    } failureBlock:^(NSError *error) {
        [self showAlert:error];
        
    }];

}

- (IBAction)btnResend:(id)sender {
    [_codeDialog setHidden:YES];
    [_numberDialog setHidden:YES];
    
    
        [_txtCode resignFirstResponder];
    [_networkManager loginWithPhoneNumber:_txtNumber.text pin:_txtCode.text successBlock:^(HWUser *user) {
        
        _engine.user = user;
           [self.navigationController pushViewController:_accountDetailVC animated:(YES)];
    } failureBlock:^(NSError *error) {
       [self showAlert:error];
    }];

}



- (IBAction)btnCancelCode:(id)sender {
    [_codeDialog setHidden:YES];
    [_numberDialog setHidden:NO];
    [_txtCode resignFirstResponder];
}

- (IBAction)btnSignIn:(id)sender {
    [_loginView setHidden:YES];
    [_signIn setHidden:NO];
}

- (IBAction)btnSignInFB:(id)sender {
    [_socManager loginFacebookSuccess:^(NSDictionary *response) {
        [_networkManager registerUserWithPhoneNumber:nil orFacebookToken:[response objectForKey:SocialToken] successBlock:^(HWUser *user) {
            _engine.user = user;
            [self.navigationController pushViewController:_accountDetailVC animated:(YES)];
            
        } failureBlock:^(NSError *error) {
           [self showAlert:error];        }];
        
    } failure:^(NSError *error) {
        [self showAlert:error];
    }];
}


- (IBAction)btnRequestNewPin:(id)sender {
    [_numberDialog setHidden:NO];
        [self.view bringSubviewToFront:_codeDialog];
    [self.view bringSubviewToFront:_numberDialog];
}

- (IBAction)btnSignUp:(id)sender {
    [_loginView setHidden:NO];
    [_signIn setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (IBAction)btnSignInMobile:(id)sender {
    [_networkManager loginWithPhoneNumber:_txtMobileNum.text pin:_txtPin.text successBlock:^(HWUser *user) {
        _engine.user = user;
        [self.navigationController pushViewController:_accountDetailVC animated:(YES)];
        
    } failureBlock:^(NSError *error) {
    [self showAlert:error];
    }];

}



@end