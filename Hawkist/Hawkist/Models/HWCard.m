//
//  HWCard.m
//  Hawkist
//
//  Created by Anton on 04.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWCard.h"

@implementation HWCard



- (NSString*) month
{
   return [NSString stringWithFormat:@"%02ld",[self.exp_month integerValue]];

}

- (NSString*) year
{
    return [self.exp_year substringFromIndex:self.exp_year.length -2];
}

@end
