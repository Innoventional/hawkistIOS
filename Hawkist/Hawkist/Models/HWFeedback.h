//
//  HWFeedback.h
//  Hawkist
//
//  Created by User on 19.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HWFeedbackType) {
    
    HWFeedbackPositive = 0,
    HWFeedbackNegative = 1,
    HWFeedbackNeutral = 2
};

@interface HWFeedback : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) HWFeedbackType *typeFeedback;
@property (nonatomic, strong) NSString *timeCreate;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *avatar;





@end
