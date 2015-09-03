//
//  HWFeedBackViewController.h
//  Hawkist
//
//  Created by User on 17.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWBaseViewController.h"

//typedef NS_ENUM(NSInteger, HWFeedbackStatus)
//{
//    HWFeedbackStatusPositive,
//    HWFeedbackStatusNeutral,
//    HWFeedbackStatusNegative
//    
//};


//typedef NS_ENUM(NSInteger, HWFeedbackType) {
//    
//    HWFeedbackPositive = 0,
//    HWFeedbackNegative = 1,
//    HWFeedbackNeutral = 2
//};


@interface HWFeedBackViewController : HWBaseViewController

- (instancetype) initWithUserID:(NSString *)userID withStatus:(HWFeedbackType)status;

- (instancetype) initWithUserID:(NSString *)userID;

@end
