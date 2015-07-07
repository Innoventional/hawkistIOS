//
//  HWItem.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 7/7/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWItem.h"

@implementation HWItem

+(JSONKeyMapper*)keyMapper
{
    [super keyMapper];
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"item_description"
                                                       }];
}
@end
