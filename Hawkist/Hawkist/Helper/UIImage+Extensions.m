//
//  UIImage+Extensions.m
//  FaceToFace
//
//  Created by Svyatoslav on 12/11/14.
//  Copyright (c) 2014 Franklin Ross. All rights reserved.
//

#import "UIImage+Extensions.h"
#import "UIColor+Extensions.h"
#import "CGGeometry+CoreGraphicsHelpers.h"

@implementation UIImage (Extensions)

+ (UIImage*) imageWithColor: (UIColor*) color
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(0.5f, 0.5f), NO, 0.0f);
    
    [color setFill];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextFillRect(ctx, CGRectMake(0.0f, 0.0f, 1.0f, 1.0f));
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    image = [image resizableImageWithCapInsets: UIEdgeInsetsZero];
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*) dividerForSegmentedControl
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1.0f, 20.0f), NO, 0.0f);
    
    [[UIColor color256RGBWithRed: 23.0f green: 30.0f blue: 39.0f] setFill];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextFillRect(ctx, CGRectMake(0.0f, 0.0f, 1.0f, 20.0f));
    
    [[UIColor color256RGBWithRed: 13.0f green: 16.0f blue: 20.0f] setFill];
    
    CGContextFillRect(ctx, CGRectMake(0.0f, 18.0f, 1.0f, 2.0f));
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    image = [image resizableImageWithCapInsets: UIEdgeInsetsMake(0.0f, 0.0f, 5.0f, 0.0f)];
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

+ (UIImage*) imageWithColor: (UIColor*) color
                       size: (CGSize) size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    [color setFill];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextFillRect(ctx, CGRectMake(0.0f, 0.0f, size.width, size.height));
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    image = [image resizableImageWithCapInsets: UIEdgeInsetsZero];
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*) ratingCircleWithColor: (UIColor*) color
{
    return [UIImage circleWithColor: color andDiameter: 11.0f];
}

+ (UIImage*) smallRatingCircleWithColor: (UIColor*) color
{
    return [UIImage circleWithColor: color andDiameter: 7.0f];
}

+ (UIImage*) socialCircleWithColor: (UIColor*) color
{
    return [UIImage circleWithColor: color andDiameter: 60.0f];
}

+ (UIImage*) statusCircleWithColor: (UIColor*) color
{
    return [UIImage circleWithColor: color andDiameter: 20.0f];
}

+ (UIImage*) circleWithColor: (UIColor*) color andDiameter: (CGFloat) diameter
{
    UIImage *circle = nil;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(diameter, diameter), NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);

    CGRect rect = CGRectMake(0, 0, diameter, diameter);
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillEllipseInRect(ctx, rect);

    CGContextRestoreGState(ctx);
    circle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return circle;
}

+ (UIImage*) rectangleWithColor: (UIColor*) color andSize: (CGSize) size
{
    UIImage *rect = nil;

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);

    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, CGRectMake(0.0, 0.0, size.width, size.height));
    CGContextRestoreGState(ctx);

    rect = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return rect;
}

- (UIImage *)imageScaledToSize:(CGSize)newSize applyScreenScale:(BOOL)applyScreenScale
{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMakeWithSize(newSize)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (applyScreenScale)
    {
        NSData *imageData = UIImagePNGRepresentation(newImage);

        newImage = [UIImage imageWithData:imageData scale:[[UIScreen mainScreen] scale]];
    }

    return newImage;
}

- (UIImage *)imageScaledToConstrainSize:(CGSize)constrainSize
{
    return [self imageScaledToConstrainSize:constrainSize applyScreenScale:NO];
}

- (UIImage *)imageScaledToConstrainSize:(CGSize)constrainSize applyScreenScale:(BOOL)applyScreenScale
{
    CGSize scaledSize = CGSizeMakeFillingSizeWithAspectRatio(constrainSize, CGSizeGetAspectRatio(self.size));

    if (applyScreenScale)
    {
        scaledSize = CGSizeMultiply(scaledSize, [[UIScreen mainScreen] scale]);
    }

    UIImage *thImage = [self imageScaledToSize:scaledSize applyScreenScale:applyScreenScale];

    return thImage;
}

- (UIImage *)normalizedImageOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;

    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:CGRectMakeWithSize(self.size)];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}


@end
