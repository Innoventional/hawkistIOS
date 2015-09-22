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
#import "UIView+Extensions.h"


@interface LoginViewController () <UIAlertViewDelegate>

@property (nonatomic,strong) UIView* loginView;
@property (nonatomic,strong) UIView* numberDialog;
@property (nonatomic,strong) UIView* codeDialog;
@property (nonatomic,strong) UIView* signIn;
@property (nonatomic,strong) UIView* loading;

@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UITextField *txtNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNum;
@property (weak, nonatomic) IBOutlet UITextField *txtPin;

@end

@implementation LoginViewController

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if([AppEngine isFirsTimeLaunch])
    {
        [self presentViewController: [[TutorialViewController alloc] init] animated: YES completion:nil];
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    [self initDefault];
    self.txtMobileNum.text = [AppEngine shared].number;
    self.txtPin.text = [AppEngine shared].pin;
    [self autoLogin];
}

- (void) viewDidAppear:(BOOL)animated
{
    self.isInternetConnectionAlertShowed = NO;
    
    //[self autoLogin];
}


#pragma mark -
#pragma mark INIT/Setup

- (void) initDefault
{

    [self setupSignUpScreen];
    [self setupSignInScreen];
    [self setupNubmerAlert];
    [self setupPinAlert];
    [self setupLoadingScreen];
}

- (void) setupLoadingScreen
{
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"LoadingView" owner:self options:nil];
    self.loading = [arr objectAtIndex:0];
    self.loading.frame = self.view.frame;
    [self.view addSubview:self.loading];

}


- (void) setupSignUpScreen
{
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"Login" owner:self options:nil];
    self.loginView = [arr objectAtIndex:0];
    self.loginView.frame = self.view.frame;
    [self.view addSubview:self.loginView];
    self.loginView.hidden = YES;
}


- (void) setupSignInScreen
{
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"SignIn" owner:self options:nil];
    self.signIn = [arr objectAtIndex:0];
    self.signIn.frame = self.view.frame;
    
    float imageWidth = (180.f/320.0f)*self.view.width;
    float imageHight = (180.f/568.0f)*self.view.height;
    float imageY = (37.5f/568)*self.view.height;
    
    CGRect rect = CGRectMake((self.view.width - imageWidth)/2,imageY,imageWidth,imageHight);
    
    UIImageView* backgroundLogo = [[UIImageView alloc]initWithFrame:rect];
    [backgroundLogo setImage:[UIImage imageNamed:@"NoAvatar"]];
    
    [self.signIn addSubview:backgroundLogo];
    
    [self.view addSubview:self.signIn];
    [self.signIn setHidden:YES];
    
    [self setupPlaceholders];
    [self setupToolBar];
}

- (void) setupPlaceholders
{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"ENTER MOBILE NUMBER" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtMobileNum.attributedPlaceholder = str;
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"ENTER PIN" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtPin.attributedPlaceholder = str2;
}

- (void) setupToolBar
{
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
    [numberToolbar sizeToFit];
    
    self.txtMobileNum.inputAccessoryView = numberToolbar;
    self.txtPin.inputAccessoryView = numberToolbar;
}

- (void) hideKeyboard
{
    [self.view endEditing:YES];
}

- (void) setupNubmerAlert
{
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"CustomAlertView" owner:self options:nil];
    self.numberDialog= [arr objectAtIndex:0];
    self.numberDialog.frame = CGRectMake(20, 60, self.view.width-40, self.view.width-80);
    [self.view addSubview:self.numberDialog];
    [self.numberDialog setHidden:YES];
}

- (void) setupPinAlert
{
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"CodeAlertView" owner:self options:nil];
    self.codeDialog = [arr objectAtIndex:0];
    self.codeDialog.frame = CGRectMake(20, self.view.height/2 - (self.view.width-40)/2, self.view.width-40, (self.view.width-40)/2);
    [self.view addSubview:self.codeDialog];
    [self.codeDialog setHidden:YES];
}



#pragma mark -
#pragma mark Navigation In Controller

- (IBAction)btnSignUpMobile:(id)sender {
   
    [self.numberDialog setHidden:NO];
}

- (IBAction)btnCancel:(id)sender {
    if (!self.numberDialog.hidden)
    {
        [self.numberDialog setHidden:YES];
        [self.txtNumber resignFirstResponder];
    }
    if (!self.codeDialog.hidden){
        
        [self.codeDialog setHidden:YES];
        [self.txtCode resignFirstResponder];
    }
    self.txtNumber.text = @"";
    self.txtCode.text = @"";
}

- (IBAction)btnCancelCode:(id)sender {
    [self.codeDialog setHidden:YES];
    [self.numberDialog setHidden:NO];
    [self.txtCode resignFirstResponder];
}

- (IBAction)btnSignIn:(id)sender {
    [self.loginView setHidden:YES];
    [self.signIn setHidden:NO];
}

- (IBAction)tapScreen:(id)sender {
    [self hideKeyboard];
}

- (IBAction)btnRequestNewPin:(id)sender {
    [self.numberDialog setHidden:NO];
    [self.view bringSubviewToFront:self.codeDialog];
    [self.view bringSubviewToFront:self.numberDialog];
}

- (IBAction)btnSignUp:(id)sender {
    [self.loginView setHidden:NO];
    [self.signIn setHidden:YES];
}

#pragma mark -
#pragma mark Registration/Login

#pragma mark FaceBook
- (IBAction)btnSignFB:(id)sender {
    [self showHud];
    [[SocialManager shared] loginFacebookSuccess:^(NSDictionary *response) {
        
        
        if ([response objectForKey:SocialToken]){
        [[NetworkManager shared] registerUserWithPhoneNumber:nil orFacebookToken:[response objectForKey:SocialToken] successBlock:^(HWUser *user) {
            
                [self logged:user isLoggedWithFacebook:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideHud];
                });
            
        } failureBlock:^(NSError *error) {
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideHud];
                
                [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            self.signIn.hidden = NO;
            self.loading.hidden = YES;
            self.loginView.hidden = YES;
            [self.view layoutIfNeeded];
                    });
        }];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                
                self.signIn.hidden = NO;
                self.loading.hidden = YES;
                self.loginView.hidden = YES;
                [self.view layoutIfNeeded];
            });

        }
            
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];

        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        self.signIn.hidden = NO;
        self.loading.hidden = YES;
        self.loginView.hidden = YES;
                    });
    }];
}

#pragma mark Phone
- (IBAction)btnSend:(id)sender {
    [self showHud];
    [self.txtNumber resignFirstResponder];
    
    [[NetworkManager shared] registerUserWithPhoneNumber:self.txtNumber.text orFacebookToken:nil successBlock:^(HWUser *user) {
        [self hideHud];
        [self.codeDialog setHidden:NO];
        self.txtCode.text = @"";
        [self.numberDialog setHidden:YES];
    } failureBlock:^(NSError *error) {
        [self hideHud];
    [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
}

- (IBAction)btnResend:(id)sender {
    [self.codeDialog setHidden:YES];
    [self.numberDialog setHidden:YES];
    [self.txtCode resignFirstResponder];
    
    [self showHud];
    [[NetworkManager shared] loginWithPhoneNumber:self.txtNumber.text pin:self.txtCode.text successBlock:^(HWUser *user) {
        [self logged:user isLoggedWithFacebook:NO];
        [AppEngine shared].number = user.phone;
        [AppEngine shared].pin = self.txtCode.text;
        [self hideHud];
    } failureBlock:^(NSError *error) {
       [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self hideHud];
    }];
}

- (IBAction)btnSignInMobile:(id)sender {
    [self showHud];
    [[NetworkManager shared] loginWithPhoneNumber:self.txtMobileNum.text pin:self.txtPin.text successBlock:^(HWUser *user) {
        [self logged:user isLoggedWithFacebook:NO];
        [AppEngine shared].number = user.phone;
        [AppEngine shared].pin = self.txtPin.text;
        [self hideHud];
    }
        failureBlock:^(NSError *error) {
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self hideHud];
        self.signIn.hidden = NO;
        self.loading.hidden = YES;
        self.loginView.hidden = YES;
    }];
}

#pragma mark Helper

- (void) logged:(HWUser*) user isLoggedWithFacebook: (BOOL) FaceBook
{
    [[NetworkManager shared] getListOfTags:^(NSMutableArray *tags) {
        [AppEngine shared].user = user;
        [AppEngine shared].tags = tags;
        
        
//        if ([AppEngine shared].APNStoken){
//        [[NetworkManager shared] sendAPNSToken:[AppEngine shared].APNStoken successBlock:^{
//            
//            
//        } failureBlock:^(NSError *error) {
//            
//            
//        }];
//        }
        if (user.first_login)
        {
            AccountDetailViewController *accountDetailVC= [[AccountDetailViewController alloc]init];
            accountDetailVC.isLogeedWithFacebook = FaceBook;
            [self.navigationController pushViewController:accountDetailVC animated:(YES)];
        }
        else
        {
            [self.navigationController pushViewController:[[HWTapBarViewController alloc]init] animated:(YES)];
        }
    } failureBlock:^(NSError *error) {
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
    [AppEngine shared].logginedWithFB = FaceBook;
    [AppEngine shared].logginedWithPhone = !FaceBook;
}

- (void) setLogout
{
    self.loading.hidden = YES;
    self.loginView.hidden = NO;
}

- (void) autoLogin
{
    [self showHud];
    
    if (![AppEngine shared].logginedWithFB && ![AppEngine shared].logginedWithPhone)
    {
        self.loading.hidden = YES;
        self.loginView.hidden = NO;
        [self hideHud];
        return;
    }
    
    if ([AppEngine shared].logginedWithPhone)
    {
        [self btnSignInMobile:self];
    }
    
    if ([AppEngine shared].logginedWithFB)
    {
        [self btnSignFB:self];
    }
}

@end
