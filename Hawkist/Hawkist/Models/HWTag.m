//
//  HWTags.m
//  Hawkist
//
//  Created by Anton on 07.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWTag.h"

@implementation HWTag
+(JSONKeyMapper*)keyMapper
{
    [super keyMapper];
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"item_description"
                                                       }];
}
@end

@implementation HWCategory

@end

@implementation HWSubCategories

@end

//@implementation HWColor
//
//@end

@implementation HWCondition

@end
