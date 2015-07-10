//
//  HWItem+Extensions.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 7/10/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWItem+Extensions.h"
#import "NSString+Extensions.h"

@implementation HWItem (Extensions)

- (NSString*) stringItemCreationDate
{
    NSDate* date = [self.created_at dateFromString];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"MMMM dd, yyyy"];
    return [formatter stringFromDate: date];
}

@end
