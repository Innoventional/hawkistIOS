//
//  AccountDetailViewController.m
//  Hawkist
//
//  Created by Anton on 6/17/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "AccountDetailViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIView+Extensions.h"
#import "Masonry.h"
#import "LoginViewController.h"
#import "CustomizationViewController.h"
#import "NetworkManager.h"
#import "UIColor+Extensions.h"


@interface AccountDetailViewController ()
@property (nonatomic,strong) UIView* accountDetailView;
@property (nonatomic, assign) BOOL* isContinueEnable;

@property (nonatomic, strong) UIImage* avatar;
@property (nonatomic,strong) NetworkManager* netManager;
@property (nonatomic,assign) BOOL isPhotoSet;
@property (nonatomic, assign) BOOL isPlaceholderHidden;

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
    
    _isPhotoSet = NO;
    _netManager = [NetworkManager shared];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"USERNAME" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtUserName.attributedPlaceholder = str;
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"EMAIL ADDRESS" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtEmail.attributedPlaceholder = str2;
    
    self.isContinueEnable = false;
    
    [self registerForKeyboardNotifications];
    
//    NSString *htmlString = @"<p style='color:white;font-size:14'>I accept <a href='http://google.com' style='color: white;text-decoration:none'>Term of Use</a> and <a href='http://google.com' style='color: white;text-decoration:none'>Privacy Policy</a></p>";
    
    NSString* textString = @"I accept Term of Use and Privacy Policy";
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString: textString];
    
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:14.0];
    
    [attributedString addAttribute: NSFontAttributeName value: font range: NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value: [UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
    NSRange range = NSMakeRange(9, 11);
    
    
    [attributedString addAttribute:NSForegroundColorAttributeName value: [UIColor redColor] range:range];
    [attributedString addAttribute: NSLinkAttributeName value: @"http://www.google.com" range: range];
    
    range = NSMakeRange(25, 14);
    [attributedString addAttribute:NSForegroundColorAttributeName value: [UIColor color256RGBWithRed: 63 green: 147 blue: 126] range:range];
    [attributedString addAttribute: NSLinkAttributeName value: @"http://www.google.com" range: range];
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    
    _txtURLS.attributedText = attributedString;
    NSDictionary* linkAttributes = @{
                                     NSForegroundColorAttributeName: [UIColor color256RGBWithRed: 63 green: 147 blue: 126],
                                     NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)
                                     };
    [_txtURLS setLinkTextAttributes: linkAttributes];
    
    
    _btnContinue.enabled = false;
  
    
    _imgAvatar.layer.cornerRadius = 120;
        _imgAvatar2.layer.cornerRadius = 100;
    
    _imgAvatar.clipsToBounds = YES;
        _imgAvatar2.clipsToBounds = YES;
    
    if(self.isLogeedWithFacebook)
        self.txtUserName.enabled = NO;
    
    [_netManager getUserProfileWithSuccessBlock:^(HWUser *user) {
        if ([user.avatar isEqualToString:@""])
        {
            _imgAvatar2.hidden = YES;
            _imgAvatar.hidden = NO;
            [_imgAvatar setImageWithURL: [NSURL URLWithString: user.avatar] placeholderImage:[UIImage imageNamed: @"acdet_circle"]];
        }
        else
        {
          //  _imgAvatar2.hidden = NO;
            _imgAvatar.hidden = YES;
            [_imgAvatar2 setImageWithURL: [NSURL URLWithString: user.avatar] placeholderImage:[UIImage imageNamed: @"acdet_circle"]];
        
        
        }
        
        _txtUserName.text = user.username;
        _txtEmail.text = user.email;
        _txtAboutMe.text = @"Tell other users about yourself. What kinds of games do you enjoy? What is your top gaming achievement? What new games or consoles are you excited for?";
        
        if(user.about_me && user.about_me.length > 0)
        {
            _txtAboutMe.text = user.about_me;
            self.isPlaceholderHidden = YES;
        }
        
    } failureBlock:^(NSError *error) {
        [self showAlert:error];
    }];
}




- (void) viewDidAppear:(BOOL)animated
{
    
    [_txtURLS scrollRectToVisible:CGRectMake(0,0,1,1) animated:YES];
    
}




 - (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!self.isPlaceholderHidden)
    {
        _txtAboutMe.text =@"";
        self.isPlaceholderHidden = YES;
    }
    [self scrollToTextView];
    return YES;
}

- (void) scrollToTextView
{
    CGRect textViewRect = [self.txtAboutMe.superview convertRect: self.txtAboutMe.frame toView: self.view];
    CGFloat offset = 225 - (self.view.height - (textViewRect.origin.y + textViewRect.size.height));
    if(offset > 0)
    {
        [self.scrollView setContentOffset: CGPointMake(0, self.scrollView.contentOffset.y + offset)];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[textField resignFirstResponder];
    
   if  (textField.tag == 1)
   {
       [_txtEmail becomeFirstResponder];
   }
    if (textField.tag ==2)
    {
        [_txtAboutMe becomeFirstResponder];
    }
    
    
    return YES;
}

- (void) textViewDidEndEditing: (UITextView*) textView
{
    if([textView.text isEqualToString: @""])
    {
        textView.text = @"Tell other users about yourself. What kinds of games do you enjoy? What is your top gaming achievement? What new games or consoles are you excited for?";
        self.isPlaceholderHidden = NO;
    }
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
    BOOL willHide = [notification.name isEqualToString: UIKeyboardWillHideNotification];
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGFloat keyboardHeight = (CGRectGetMinY(keyboardFrame) < self.view.height) ? CGRectGetHeight(keyboardFrame) : 0.0f;
    
    CGFloat bottomOffset = willHide ? 0.0f : keyboardHeight;

    [self.scrollView setContentInset: UIEdgeInsetsMake(0, 0, bottomOffset, 0)];

}

- (void) hideKeyboardFrame: (NSNotification*) notification
{

    [self.scrollView setContentInset: UIEdgeInsetsMake(0, 0, 0, 0)];
 
}




- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

- (IBAction)btnNext:(id)sender {
    
    
    [self showHud];
    
    NSString* aboutString;
    if(self.isPlaceholderHidden)
    {
        aboutString = _txtAboutMe.text;
    }
    else
    {
        aboutString = nil;
    }
    
    if (_isPhotoSet)
    
    [_netManager updateUserEntityWithUsername:_txtUserName.text email:_txtEmail.text aboutMe:aboutString photo:_imgAvatar2.image successBlock:^(HWUser *user) {
        
        [self hideHud];
        [self.navigationController pushViewController:[[CustomizationViewController alloc]init] animated:(YES)];
    } failureBlock:^(NSError *error) {
        [self hideHud];
        [self showAlert:error];
    }
     ];
    else
    {
        [_netManager updateUserEntityWithUsername:_txtUserName.text email:_txtEmail.text aboutMe:aboutString photo:nil successBlock:^(HWUser *user) {
            [self hideHud];
            [self.navigationController pushViewController:[[CustomizationViewController alloc]init] animated:(YES)];
        } failureBlock:^(NSError *error) {
            [self hideHud];
            [self showAlert:error];
            
        }
         ];
}
}

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
        
        self.btnContinue.enabled = true;
    }
    else
    {
    self.btnContinue.enabled = false;
    }
}



- (IBAction)tapImage:(id)sender {
    UIActionSheet* popup = [[UIActionSheet alloc] initWithTitle: @""
                                                       delegate: self
                                              cancelButtonTitle: @"Cancel"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: @"Take Photo", @"Choose Photo", nil];
    popup.tag = 1;
    [popup showInView: [UIApplication sharedApplication].keyWindow];
    [self.txtEmail resignFirstResponder];
}

- (void)    actionSheet: (UIActionSheet*) popup
   clickedButtonAtIndex: (NSInteger) buttonIndex
{
    switch (popup.tag)
    {
        case 1:
        {
            switch (buttonIndex)
            {
                case 0:
                    [self takePhoto: YES
                        fromGallery: NO];
                    break;
                    
                case 1:
                    [self takePhoto: YES
                        fromGallery: YES];
                    break;
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;

}
}

- (void) takePhoto: (BOOL)photo
       fromGallery:(BOOL)gallery
{
    UIImagePickerControllerSourceType source = gallery ? UIImagePickerControllerSourceTypePhotoLibrary :
    UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: source])
    {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        
        picker.delegate      = self;
        picker.allowsEditing = YES;
        if(photo)
            picker.mediaTypes    = @[(NSString*) kUTTypeImage];
        picker.sourceType    = source;
        
        [self presentViewController: picker animated: YES completion: NULL];
    }
}

- (IBAction)tapView:(id)sender {
    [self.txtEmail resignFirstResponder];
    [self.txtUserName resignFirstResponder];
    [self.txtAboutMe resignFirstResponder];
    
}
- (IBAction)btnBack:(id)sender {
    //LoginViewController* login = [[LoginViewController alloc]init];
    [self.navigationController popViewControllerAnimated:YES];

}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _avatar = info[UIImagePickerControllerEditedImage];
    
    _imgAvatar2.image = _avatar;
    _imgAvatar2.hidden = NO;
    _imgAvatar.hidden = YES;
    
    _isPhotoSet = true;
    [picker dismissViewControllerAnimated: YES completion:^{
        
    }];
}
@end
