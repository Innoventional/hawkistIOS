//
//  HWMention.h
//  Hawkist
//
//  Created by User on 30.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "JSONModel.h"

@interface HWMention : JSONModel

@property (nonatomic, strong) NSString <Optional>* id;
@property (nonatomic, strong) NSString <Optional>* username;
@property (nonatomic, strong) NSString <Optional>* avatar;

@end
