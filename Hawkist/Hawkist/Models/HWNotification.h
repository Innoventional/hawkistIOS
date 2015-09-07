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
@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* available_feedback;
@end

@protocol User
@end


@interface User : JSONModel
@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* avatar;
@property (nonatomic, strong) NSString<Optional>* username;
@end

@protocol Listing
@end

@interface Listing : JSONModel
@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* photo;
@property (nonatomic, strong) NSString<Optional>* selling_price;
@property (nonatomic, strong) NSString<Optional>* shipping_price;
@property (nonatomic, strong) NSString<Optional>* title;
@end

@protocol Comment
@end

@interface Comment : JSONModel
@property (nonatomic, strong) NSString<Optional>* offered_price;
@property (nonatomic, strong) NSString<Optional>* text;
@end

@interface HWNotification : JSONModel

@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* type;
@property (nonatomic, strong) NSString<Optional>* feedback_type;
@property (nonatomic, strong) User<Optional>* user;
@property (nonatomic, strong) Listing<Optional>* listing;
@property (nonatomic, strong) Comment<Optional>* comment;
@property (nonatomic, strong) Order<Optional>* order;

@end

