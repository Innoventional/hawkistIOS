//
//  HWMyBalanceYourDetailsView.m
//  Hawkist
//
//  Created by User on 24.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWMyBalanceYourDetailsView.h"
#import "UIColor+Extensions.h"

@interface HWMyBalanceYourDetailsView ()

@property (nonatomic, assign) BOOL isEditMode;

@end

@implementation HWMyBalanceYourDetailsView

#pragma mark - set/get

-(void)setIsEdit:(BOOL)isEdit {
    
    _isEdit = isEdit;
    self.isEditMode = isEdit;
    
    if(isEdit) {
        
        [self.saveEditButton setTitle:@"SAVE BANK ACCOUNT" forState:UIControlStateNormal];
        [self.saveEditButton setBackgroundColor:[UIColor color256RGBWithRed:48 green:173 blue:148]];
    } else {
        
        [self.saveEditButton setTitle:@"EDIT BANK ACCOUNT" forState:UIControlStateNormal];
        [self.saveEditButton setBackgroundColor:[UIColor color256RGBWithRed:78 green:78 blue:78]];
    }
    
}

- (void) setUserDetailsWith:(HWBankUserInfo*)userInfo {
    
    [self.firstName setText:userInfo.first_name];
    [self.lastName setText:userInfo.last_name];
   
    if(userInfo.birth_date) {
        [self.birthday setText:[NSString stringWithFormat:@"%@/%@/%@",userInfo.birth_date, userInfo.birth_month, userInfo.birth_year]];
    }
    
}


- (HWBankUserInfo*)getUserDetails {
    
    HWBankUserInfo *userDet = [[HWBankUserInfo alloc] init];
    
    userDet.first_name = self.firstName.text;
    userDet.last_name = self.lastName.text;
    
    if (self.date) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    [formatter setDateFormat:@"MM"];
    
    userDet.birth_month = [formatter stringFromDate:self.date];
    [formatter setDateFormat:@"dd"];
    userDet.birth_date = [formatter stringFromDate:self.date];
    [formatter setDateFormat:@"yyyy"];
    userDet.birth_year = [formatter stringFromDate:self.date];
    }
    
    return userDet;
}


-(BOOL)isFullAllTextFieldWithYourDetails:(HWBankUserInfo*) userInfo{
    
    BOOL isNill = (userInfo.first_name && userInfo.last_name && userInfo.birth_date);
    BOOL isEmpty = (!([userInfo.first_name isEqualToString:@""] &&
                    [userInfo.last_name isEqualToString:@""] &&
                    [userInfo.birth_date isEqualToString:@""]
                    ));
    
    
    return (isNill && isEmpty);
}

-(void) setIsEditMode:(BOOL)isEditMode {
         
    _isEditMode = isEditMode;
    self.firstName.enabled = isEditMode;
    self.lastName.enabled = isEditMode;
    self.birthday.enabled = isEditMode;
    
}

#pragma mark - Action

- (IBAction)saveEditAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveEditDetailsWithButton:)]) {
        
        [self.delegate saveEditDetailsWithButton:sender];
    }
}
@end
