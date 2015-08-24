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

@property (nonatomic, weak) id<HWMyBalanceYourDetailsViewDelegate> delegate;

- (void) setUserDetailsWith:(HWBankUserInfo*)userInfo;

@end


@protocol HWMyBalanceYourDetailsViewDelegate <NSObject>

- (void) saveEditDetailsWithButton:(UIButton*)sender;

@end