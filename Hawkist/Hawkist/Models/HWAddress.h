//
//  HWAddress.h
//  Hawkist
//
//  Created by Anton on 19.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface HWAddress : JSONModel

@property (strong, nonatomic)NSString<Optional>* id;
@property (strong, nonatomic)NSString* address_line1;
@property (strong, nonatomic)NSString<Optional>* address_line2;
@property (strong, nonatomic)NSString* city;
@property (strong, nonatomic)NSString* postcode;

@end

