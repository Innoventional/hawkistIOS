//
//  LoginViewController.h
//  
//
//  Created by Anton on 6/15/15.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UIAlertViewDelegate>
- (IBAction)btnSignUpMobile:(id)sender;
- (IBAction)btnSignUpFB:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UITextField *txtNumber;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSend:(id)sender;
- (IBAction)btnResend:(id)sender;

- (IBAction)btnCancelCode:(id)sender;

- (IBAction)btnSignIn:(id)sender;




//////////SIGN IN
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNum;
@property (weak, nonatomic) IBOutlet UITextField *txtPin;

- (IBAction)btnRequestNewPin:(id)sender;
- (IBAction)btnSignUp:(id)sender;
- (IBAction)btnSignInMobile:(id)sender;
- (IBAction)btnSignInFB:(id)sender;

@end
