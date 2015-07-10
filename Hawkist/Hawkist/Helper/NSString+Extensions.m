//
//  NSString+Extensions.m
//  FaceToFace
//
//  Created by Svyatoslav on 1/13/15.
//  Copyright (c) 2015 Franklin Ross. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

- (NSDate*) dateFromString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [formatter setTimeZone:tz];
    
    return [formatter dateFromString:[self substringToIndex:19]];
}

@end
