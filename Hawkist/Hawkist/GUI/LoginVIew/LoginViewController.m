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
#import "HWTapBarViewController.h"
#import "CustomizationViewController.h"
#import "FeedScreenViewController.h"


@interface LoginViewController ()

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

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _socManager = [SocialManager shared];
    _engine = [AppEngine shared];
    
    if([AppEngine isFirsTimeLaunch])
    {
        [self presentViewController: [[TutorialViewController alloc] init] animated: YES completion:^{
            
        }];
    }
    

    
    NSArray* arr = [[NSBundle mainBundle]loadNibNamed:@"Login" owner:self options:nil];
   
    _loginView = [arr objectAtIndex:0];
    
    _loginView.frame = self.view.frame;
    
    [self.view addSubview:_loginView];
    
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
    

    arr = [[NSBundle mainBundle]loadNibNamed:@"SignIn" owner:self options:nil];
    
    _signIn = [arr objectAtIndex:0];
    
    _signIn.frame = self.view.frame;
    
    [_signIn setHidden:YES];
    
    float imageWidth = (180.f/320.0f)*self.view.width;
    float imageHight = (180.f/568.0f)*self.view.height;
    float imageY = (37.5f/568)*self.view.height;
    
    
    CGRect rect = CGRectMake((self.view.width - imageWidth)/2,imageY,imageWidth,imageHight);

    
    UIImageView* backgroundLogo = [[UIImageView alloc]initWithFrame:rect];
    [backgroundLogo setImage:[UIImage imageNamed:@"NoAvatar"]];
    
    [self.signIn addSubview:backgroundLogo];
    
    [self.view addSubview:_signIn];

    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"ENTER MOBILE NUMBER" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtMobileNum.attributedPlaceholder = str;
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"ENTER PIN" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtPin.attributedPlaceholder = str2;
    
    _txtMobileNum.text = _engine.number;
    _txtPin.text = _engine.pin;

    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(hideKeyboard)];
    
    
    UIButton* customButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    
    [customButton setBackgroundImage:[UIImage imageNamed:@"signBut"] forState:UIControlStateNormal];
    
    [customButton setTitle:@"Done" forState:UIControlStateNormal];
    
    [customButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchDown];
    
    doneButton.customView = customButton;
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          doneButton,
                           nil];
    [numberToolbar sizeToFit];    //[numberToolbar addSubview:customButton];

    _txtMobileNum.inputAccessoryView = numberToolbar;
    _txtPin.inputAccessoryView = numberToolbar;

}


- (void) hideKeyboard
{
    [_txtMobileNum resignFirstResponder];
    [_txtPin resignFirstResponder];
}
    
- (void) nextToPin
{
    
    [_txtMobileNum resignFirstResponder];
    [_txtPin becomeFirstResponder];
}

- (void) nextTo
{
    [_txtPin resignFirstResponder];
    [self btnSignInMobile:self];
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



#pragma mark -
#pragma mark Keyboard


- (void) adjustKeyboardFrame: (NSNotification*) notification
{
    
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 163, 106, 53);
    doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton setImage:[UIImage imageNamed:@"signBut"] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:@"signBut"] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(nextToPin) forControlEvents:UIControlEventTouchUpInside];
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *keyboardView = [[[[[UIApplication sharedApplication] windows] lastObject] subviews] firstObject];
            [doneButton setFrame:CGRectMake(0, keyboardView.frame.size.height - 53, 106, 53)];
            [keyboardView addSubview:doneButton];
            [keyboardView bringSubviewToFront:doneButton];
            
            [UIView animateWithDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]-.02
                                  delay:.0
                                options:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                             animations:^{
                                 self.view.frame = CGRectOffset(self.view.frame, 0, 0);
                             } completion:nil];
        });
    
//    
//    BOOL willHide = [notification.name isEqualToString: UIKeyboardWillHideNotification];
//    
//    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    CGFloat keyboardHeight = (CGRectGetMinY(keyboardFrame) < self.view.frame.size.height) ? CGRectGetHeight(keyboardFrame) : 0.0f;
//    
//    CGFloat bottomOffset = willHide ? 0.0f : keyboardHeight;
//    
//    CGRect newRect = CGRectMake(0, -bottomOffset, self.view.frame.size.width, self.view.frame.size.height);
//    
//    self.view.frame = newRect;
    

}



- (void) hideKeyboardFrame: (NSNotification*) notification
{
//    CGRect newRect = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    self.view.frame = newRect;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (IBAction)btnSignUpMobile:(id)sender {
   
    [_numberDialog setHidden:NO];

}

- (IBAction)btnSignUpFB:(id)sender {
    

        [self showHud];
    
    
    [_socManager loginFacebookSuccess:^(NSDictionary *response) {
        
    
        
        
        [_networkManager registerUserWithPhoneNumber:nil orFacebookToken:[response objectForKey:SocialToken] successBlock:^(HWUser *user) {
//            _engine.user = user;
//                _accountDetailVC= [[AccountDetailViewController alloc]init];
//            _accountDetailVC.isLogeedWithFacebook = YES;
//            [self.navigationController pushViewController:_accountDetailVC animated:(YES)];
//                         [self DownloadData];
            
        [self logged:user isLoggedWithFacebook:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
            });

            
        } failureBlock:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
            });

            [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }];
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
        });

        
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        
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
    
    [self showHud];
    [_txtNumber resignFirstResponder];
    [_networkManager registerUserWithPhoneNumber:_txtNumber.text orFacebookToken:nil successBlock:^(HWUser *user) {
        [self hideHud];
        [_codeDialog setHidden:NO];
        _txtCode.text = @"";
        [_numberDialog setHidden:YES];
    } failureBlock:^(NSError *error) {
        [self hideHud];
    [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        
    }];

}

- (IBAction)btnResend:(id)sender {
    [_codeDialog setHidden:YES];
    [_numberDialog setHidden:YES];
    
    
        [_txtCode resignFirstResponder];
    
    [self showHud];
    [_networkManager loginWithPhoneNumber:_txtNumber.text pin:_txtCode.text successBlock:^(HWUser *user) {
////            _accountDetailVC= [[AccountDetailViewController alloc]init];
////        _accountDetailVC.isLogeedWithFacebook = NO;
////        _engine.user = user;
//        
//           [self.navigationController pushViewController:_accountDetailVC animated:(YES)];
        
        [self logged:user isLoggedWithFacebook:NO];
        _engine.number = user.phone;
                _engine.pin = _txtCode.text;
        [self hideHud];
    } failureBlock:^(NSError *error) {
       [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self hideHud];
    }];

}

- (void) viewDidAppear:(BOOL)animated
{
    self.isInternetConnectionAlertShowed = NO;
    
}


- (void) logged:(HWUser*) user isLoggedWithFacebook: (BOOL) FaceBook
{
    [_networkManager getListOfTags:^(NSMutableArray *tags) {
        
         _engine.user = user;
        _engine.tags = tags;
       
        if (user.first_login)
        {
            
            _accountDetailVC= [[AccountDetailViewController alloc]init];
            _accountDetailVC.isLogeedWithFacebook = FaceBook;
            [self.navigationController pushViewController:_accountDetailVC animated:(YES)];
                   }
        else
        {
            [self.navigationController pushViewController:[[HWTapBarViewController alloc]init] animated:(YES)];
        }
        
        
    } failureBlock:^(NSError *error) {
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
    
    
         //  [self DownloadData];
    

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

- (IBAction)tapScreen:(id)sender {
    [_txtMobileNum resignFirstResponder];
    [_txtPin resignFirstResponder];
    [_txtNumber resignFirstResponder];
    [_txtCode resignFirstResponder];
}

- (IBAction)btnSignInFB:(id)sender {

    [self showHud];
    
    [_socManager loginFacebookSuccess:^(NSDictionary *response) {
        
    
        [_networkManager registerUserWithPhoneNumber:nil orFacebookToken:[response objectForKey:SocialToken] successBlock:^(HWUser *user) {
//            _engine.user = user;
//                _accountDetailVC= [[AccountDetailViewController alloc]init];
//            self.accountDetailVC.isLogeedWithFacebook = YES;
//            [self.navigationController pushViewController:_accountDetailVC animated:(YES)];
//            
        [self logged:user isLoggedWithFacebook:YES];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
            });
            
        } failureBlock:^(NSError *error) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
            });
            
            [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }];
        
    } failure:^(NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
        });
        
       [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
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
    [self showHud];
    [_networkManager loginWithPhoneNumber:_txtMobileNum.text pin:_txtPin.text successBlock:^(HWUser *user) {
//        _engine.user = user;
//            _accountDetailVC= [[AccountDetailViewController alloc]init];
//        _accountDetailVC.isLogeedWithFacebook = NO;
                [self logged:user isLoggedWithFacebook:NO];

        
        _engine.number = user.phone;
        _engine.pin = _txtPin.text;
        
        [self hideHud];
//        [self.navigationController pushViewController:_accountDetailVC animated:(YES)];
     //    [self.navigationController pushViewController:[[WantToSellViewController alloc]init] animated:(YES)];
        //[self.navigationController pushViewController:[[FeedScreenViewController alloc]init] animated:(YES)];
    } failureBlock:^(NSError *error) {
  
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self hideHud];
    }];

}



@end
