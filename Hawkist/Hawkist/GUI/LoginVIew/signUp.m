//
//  signUp.m
//  Hawkist
//
//  Created by Anton on 6/16/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "signUp.h"
@interface signUp()

@end

@implementation signUp




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
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
    
    _getNumber = [[UIAlertView alloc]initWithTitle:@"Enter mobile Number"
                                           message:@"An SMS with your access code will sent to this number." delegate:self cancelButtonTitle:@"Send" otherButtonTitles:@"Cancel", nil];
    _getNumber.tag = 1;
    [_getNumber setAlertViewStyle:UIAlertViewStylePlainTextInput];
    _getCode = [[UIAlertView alloc]initWithTitle:nil message:@"Get your code" delegate:self cancelButtonTitle:@"Resend" otherButtonTitles:@"Ok", nil];
    _getCode.tag = 2;
    [_getCode setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [_getNumber show];
}

- (IBAction)btnSignUpFB:(id)sender {
}

- (IBAction)btnSignIn:(id)sender {
}
@end
