//
//  HWOrderItem.h
//  Hawkist
//
//  Created by User on 07.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "JSONModel.h"

@interface HWOrderItem : JSONModel

@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* title;
@property (nonatomic, strong) NSString<Optional>* image;
@property (nonatomic, strong) NSString<Optional>* retail_price;
@property (nonatomic, strong) NSString<Optional>* selling_price;

@property (nonatomic, strong) NSString<Optional>* user_id;
@property (nonatomic, strong) NSString<Optional>* status;

@end
