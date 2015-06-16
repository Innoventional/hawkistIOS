//
//  UIColor+Extensions.m
//  FaceToFace
//
//  Created by Svyatoslav on 12/11/14.
//  Copyright (c) 2014 Franklin Ross. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

+ (UIColor*) color256RGBAWithRed: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha
{
    return [UIColor colorWithRed: red / 255.0f green: green / 255.0f blue: blue / 255.0f alpha: alpha];
}

+ (UIColor*) color256RGBWithRed: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue
{
    return [UIColor color256RGBAWithRed: red green: green blue: blue alpha: 1.0f];
}

@end
