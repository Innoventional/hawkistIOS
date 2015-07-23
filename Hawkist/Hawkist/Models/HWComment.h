//
//  HWComment.h
//  Hawkist
//
//  Created by User on 22.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "JSONModel.h"
#import "HWOffer.h"

@interface HWComment : JSONModel

@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* listing_id;
@property (nonatomic, strong) NSString<Optional>* text;
@property (nonatomic, strong) NSString<Optional>* user_avatar;
@property (nonatomic, strong) NSString<Optional>* user_id;
@property (nonatomic, strong) NSString<Optional>* user_username;

@property (nonatomic, strong) NSDictionary<Optional>* offer;








@end
