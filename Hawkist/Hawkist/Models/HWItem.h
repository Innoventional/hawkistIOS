//
//  HWItem.h
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 7/7/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "JSONModel.h"
#import "HWUser.h"

@protocol HWItem <NSObject>

@end

@interface HWItem : JSONModel

@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* updated_at;

@property (nonatomic, strong) NSString<Optional>* user_id;
@property (nonatomic, strong) HWUser<Optional>* user;

@property (nonatomic, strong) NSString<Optional>* title;
@property (nonatomic, strong) NSString<Optional>* item_description;

@property (nonatomic, assign) NSInteger platform;
@property (nonatomic, assign) NSInteger category;
@property (nonatomic, assign) NSInteger subcategory;
@property (nonatomic, assign) NSInteger condition;
@property (nonatomic, assign) NSInteger color;

@property (nonatomic, strong) NSString<Optional>* retail_price;
@property (nonatomic, strong) NSString<Optional>* selling_price;
@property (nonatomic, strong) NSString<Optional>* discount;

@property (nonatomic, strong) NSString<Optional>* shipping_price;
@property (nonatomic, assign) BOOL collection_only;

@property (nonatomic, strong) NSString<Optional>* post_code;
@property (nonatomic, strong) NSString<Optional>* city;
@property (nonatomic, strong) NSString<Optional>* location_lat;
@property (nonatomic, strong) NSString<Optional>* location_lon;

@property (nonatomic, strong) NSString<Optional>* barcode;
@property (nonatomic, strong) NSArray<Optional>* photos;

@property (nonatomic, strong) NSArray<HWItem, Optional>* similar_items;
@property (nonatomic, strong) NSArray<HWItem, Optional>* user_items;

@property (nonatomic, strong) NSString<Optional>* user_avatar;
@property (nonatomic, strong) NSString<Optional>* user_username;
@property (nonatomic, assign) BOOL sold;

@property (nonatomic, strong) NSString<Optional>* liked;
@property (nonatomic, strong) NSString<Optional>* likes;

@property (nonatomic, strong) NSString<Optional>* comments;
@property (nonatomic, strong) NSString<Optional>* views;
@property (nonatomic, strong) NSString<Optional>* status;



@end
