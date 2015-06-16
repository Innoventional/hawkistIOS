//
//  UIImage+Extensions.h
//  FaceToFace
//
//  Created by Svyatoslav on 12/11/14.
//  Copyright (c) 2014 Franklin Ross. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/objc.h>

@interface UIImage (Extensions)

+ (UIImage*) imageWithColor: (UIColor*) color;
+ (UIImage*) dividerForSegmentedControl;

+ (UIImage*) imageWithColor: (UIColor*) color
                       size: (CGSize) size;

+ (UIImage*) ratingCircleWithColor: (UIColor*) color;
+ (UIImage*) smallRatingCircleWithColor: (UIColor*) color;
+ (UIImage*) statusCircleWithColor: (UIColor*) color;
+ (UIImage*) socialCircleWithColor: (UIColor*) color;
+ (UIImage*) circleWithColor: (UIColor*) color andDiameter: (CGFloat) diameter;

+ (UIImage*) rectangleWithColor: (UIColor*) color
                        andSize: (CGSize) size;

- (UIImage*) imageScaledToSize: (CGSize) newSize
              applyScreenScale: (BOOL) applyScreenScale;

- (UIImage*) imageScaledToConstrainSize: (CGSize) constrainSize;

- (UIImage*) imageScaledToConstrainSize: (CGSize) constrainSize
                       applyScreenScale: (BOOL) applyScreenScale;

- (UIImage*) normalizedImageOrientation;
@end
