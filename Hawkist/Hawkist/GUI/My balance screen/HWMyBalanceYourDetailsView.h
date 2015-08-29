//
//  HWMyBalanceYourDetailsView.h
//  Hawkist
//
//  Created by User on 24.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWBankUserInfo.h"

@protocol HWMyBalanceYourDetailsViewDelegate;

@interface HWMyBalanceYourDetailsView : UIView

@property (nonatomic, weak) IBOutlet UITextField *firstName;
@property (nonatomic, weak) IBOutlet UITextField *lastName;
@property (nonatomic, weak) IBOutlet UITextField *birthday;
@property (nonatomic, weak) IBOutlet UIButton *saveEditButton;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, weak) IBOutlet UIImageView *forward;

@property (nonatomic, weak) id<HWMyBalanceYourDetailsViewDelegate> delegate;

@property (nonatomic, assign) BOOL isEdit;

- (void) setUserDetailsWith:(HWBankUserInfo*)userInfo;
- (HWBankUserInfo*)getUserDetails;


-(BOOL)isFullAllTextFieldWithYourDetails:(HWBankUserInfo*) userInfo;

@end


@protocol HWMyBalanceYourDetailsViewDelegate <NSObject>

- (void) saveEditDetailsWithButton:(UIButton*)sender;

@end