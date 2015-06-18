//
//  AccountDetailViewController.h
//  Hawkist
//
//  Created by Anton on 6/17/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWBaseViewController.h"

@interface AccountDetailViewController : HWBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *checkbox1;

@property (weak, nonatomic) IBOutlet UIButton *checkBox2;

- (IBAction)checkBox:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@end
