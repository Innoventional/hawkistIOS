//
//  HWFollowUser.h
//  Hawkist
//
//  Created by User on 18.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "JSONModel.h"

@interface HWFollowUser : JSONModel

@property (nonatomic, strong) NSString<Optional>* avatar;
@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* rating;
@property (nonatomic, strong) NSString<Optional>* username;
@property (nonatomic, strong) NSString<Optional>* review;
@property (nonatomic, strong) NSString<Optional>* follow;

@end
