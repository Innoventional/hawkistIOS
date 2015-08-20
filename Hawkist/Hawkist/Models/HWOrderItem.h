//
//  HWOrderItem.h
//  Hawkist
//
//  Created by User on 07.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//



@interface HWOrderItem : NSObject

@property (nonatomic, strong) NSString *available_feedback;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, assign) NSInteger  status;

@property (nonatomic, strong) HWItem *item;

@end
