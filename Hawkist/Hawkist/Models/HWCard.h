//
//  HWCard.h
//  Hawkist
//
//  Created by Anton on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "JSONModel.h"

@interface HWCard : JSONModel

@property (strong, nonatomic)NSString* id;
@property (strong, nonatomic)NSString* address_line1;
@property (strong, nonatomic)NSString<Optional>* address_line2;
@property (strong, nonatomic)NSString* name;
@property (strong, nonatomic)NSString* city;
@property (strong, nonatomic)NSString* postcode;
@property (strong, nonatomic)NSString* last4;
@property (strong, nonatomic)NSString* exp_month;
@property (strong, nonatomic)NSString* exp_year;


- (NSString*) month;
- (NSString*) year;
@end

