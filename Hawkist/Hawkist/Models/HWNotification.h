//
//  HWNotification.h
//  Hawkist
//
//  Created by Anton on 25.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "HWComment.h"

@protocol Order
@end

@interface Order : JSONModel
@property (nonatomic, strong) NSString* id;
@end

@protocol User
@end


@interface User : JSONModel
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* avatar;
@property (nonatomic, strong) NSString* username;
@end

@protocol Item
@end

@interface Item : JSONModel
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* selling_price;
@property (nonatomic, strong) NSString* shipping_price;
@property (nonatomic, strong) NSString* title;
@end

@protocol Comment
@end

@interface Comment : JSONModel
@property (nonatomic, strong) NSString* offered_price;
@property (nonatomic, strong) NSString* text;
@end

@interface HWNotification : JSONModel

@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* type;
@property (nonatomic, strong) User<Optional>* user;
@property (nonatomic, strong) Item<Optional>* listing;
@property (nonatomic, strong) Comment<Optional>* comment;
@property (nonatomic, strong) Order<Optional>* order;

@end

