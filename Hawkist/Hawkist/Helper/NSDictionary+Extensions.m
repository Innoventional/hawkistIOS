//
//  NSDictionary+Extensions.m
//  FaceToFace
//
//  Created by Svyatoslav Shaforenko on 1/6/15.
//  Copyright (c) 2015 Franklin Ross. All rights reserved.
//

#import "NSDictionary+Extensions.h"

@implementation NSDictionary (Extensions)

- (NSString*) toJSONString
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject: self
                                                       options: NSJSONWritingPrettyPrinted
                                                         error: nil];
    
    return [[NSString alloc] initWithData: jsonData encoding: NSUTF8StringEncoding];
}

@end
