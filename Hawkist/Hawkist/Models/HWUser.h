//
//  HWUser.h
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/16/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface HWUser : JSONModel

@property (nonatomic, strong) NSString<Optional>* username;
@property (nonatomic, strong) NSString<Optional>* email;
@property (nonatomic, strong) NSString<Optional>* about_me;
@property (nonatomic, strong) NSString<Optional>* avatar;
@property (nonatomic, strong) NSString<Optional>* phone;
@property (nonatomic, assign) BOOL email_status;
@property (nonatomic, strong) NSString<Optional>* facebook_id;
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString<Optional>* thumbnail;

@end
