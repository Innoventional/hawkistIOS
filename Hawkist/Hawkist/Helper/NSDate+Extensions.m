//
//  NSDate+Extensions.m
//  FaceToFace
//
//  Created by Svyatoslav on 1/13/15.
//  Copyright (c) 2015 Franklin Ross. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

- (NSString*) stringFromDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [formatter setTimeZone:tz];
    
    return [formatter stringFromDate: self];

}

@end
