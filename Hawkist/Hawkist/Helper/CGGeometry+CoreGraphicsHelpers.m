
#import "CGGeometry+CoreGraphicsHelpers.h"
#import <UIKit/UIKit.h>

#pragma mark - CGPoint

CGPoint CGPointMakeMiddle(NSUInteger count, CGPoint firstPoint, ...)
{
    CGPoint resultPoint = firstPoint;
    
    NSUInteger pointIndex = 1;
    CGPoint currPoint;
    va_list args;
    
    va_start(args, firstPoint);
    
    while(pointIndex++ < count) 
    {
        currPoint = va_arg(args, CGPoint);
        
        resultPoint.x += currPoint.x;
        resultPoint.y += currPoint.y;
    }
    
    va_end(args);
    
    resultPoint.x /= count;
    resultPoint.y /= count;
    
    return resultPoint;
}

CGPoint CGPointMakeMiddleWithPoints(NSUInteger count, CGPoint *points)
{
    CGPoint resultPoint = CGPointZero;
    
    for(NSUInteger pointIndex = 0; pointIndex < count; pointIndex++)
    {
        CGPoint currPoint = points[pointIndex];
        
        resultPoint.x += currPoint.x;
        resultPoint.y += currPoint.y;
    }
    
    resultPoint.x /= count;
    resultPoint.y /= count;
    
    return resultPoint;
}

CGPoint CGPointMakeMiddleWithPointsArray(NSArray *points)
{
    CGPoint resultPoint = CGPointZero;
    
    for(NSValue *currValue in points)
    {
        CGPoint currPoint = [currValue CGPointValue];
        
        resultPoint.x += currPoint.x;
        resultPoint.y += currPoint.y;
    }
    
    resultPoint.x /= [points count];
    resultPoint.y /= [points count];
    
    return resultPoint;
}

CGPoint CGPointCeil(CGPoint point)
{
    return CGPointMake(ceilf(point.x), ceil(point.y));
}

CGPoint CGPointMultiply(CGPoint point, CGFloat multiplier)
{
    return CGPointMake(point.x * multiplier, point.y * multiplier);
}

CGPoint CGPointDevide(CGPoint point, CGFloat devider)
{
    return CGPointMake(point.x / devider, point.y / devider);
}

#pragma mark - CGSize

CGSize CGSizeMakeSquare(CGFloat size)
{
    return CGSizeMake(size, size);
}

CGSize  CGSizeCeil(CGSize size)
{
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

CGFloat CGSizeGetAspectRatio(CGSize size)
{
    return (size.height != 0.0f) ? size.width / size.height : 0.0f;
}

CGFloat CGSizeGetSquare(CGSize size)
{
    return ABS(size.width * size.height);
}

CGSize CGSizeMultiply(CGSize size, CGFloat multiplier)
{
    return CGSizeMake(size.width * multiplier, size.height * multiplier);
}

CGSize CGSizeDevide(CGSize size, CGFloat devider)
{
    return CGSizeMake(size.width / devider, size.height / devider);
}

CGSize  CGSizeMakeFillingSizeWithAspectRatio(CGSize circumscribingSize, CGFloat aspectRatio)
{
    return CGSizeMake((aspectRatio > CGSizeGetAspectRatio(circumscribingSize))
                      ? circumscribingSize.width
                      : circumscribingSize.height * aspectRatio,
                      (aspectRatio > CGSizeGetAspectRatio(circumscribingSize))
                      ? circumscribingSize.width / aspectRatio
                      : circumscribingSize.height);
}

CGSize  CGSizeMakeCircumscribingSizeWithAspectRatio(CGSize fillingSize, CGFloat aspectRatio)
{
    return CGSizeMake((aspectRatio > CGSizeGetAspectRatio(fillingSize))
                      ? fillingSize.height * aspectRatio
                      : fillingSize.width,
                      (aspectRatio > CGSizeGetAspectRatio(fillingSize))
                      ? fillingSize.height
                      : fillingSize.width / aspectRatio);
}

#pragma mark - CGRect

CGRect CGRectMakeWithOriginSize(CGPoint origin, CGSize size)
{
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

CGRect CGRectMakeWithSize(CGSize size)
{
    return CGRectMakeWithOriginSize(CGPointZero, size);
}

CGRect CGRectMakeBounds(CGRect rect)
{
    return CGRectMakeWithSize(rect.size);
}

CGRect CGRectMakeSquare(CGFloat size)
{
    return CGRectMakeWithSize(CGSizeMakeSquare(size));
}

CGRect CGRectInsets(CGRect rect, CGFloat leftInset, CGFloat rightInset, CGFloat topInset, CGFloat bottomInset)
{
    return CGRectMake(rect.origin.x + leftInset,
                      rect.origin.y + topInset,
                      rect.size.width - (leftInset + rightInset),
                      rect.size.height - (topInset + bottomInset));
}

CGRect CGRectCeil(CGRect rect)
{
    return CGRectMakeWithOriginSize(CGPointCeil(rect.origin), CGSizeCeil(rect.size));
}

CGRect CGRectSetOrigin(CGRect rect, CGPoint origin)
{
    return CGRectMakeWithOriginSize(origin, rect.size);
}

CGRect  CGRectSetLeft(CGRect rect, CGFloat left)
{
    return CGRectMakeWithOriginSize(CGPointMake(left, rect.origin.y), rect.size);
}

CGRect  CGRectSetRight(CGRect rect, CGFloat right)
{
    return CGRectMakeWithOriginSize(CGPointMake(right - CGRectGetWidth(rect), rect.origin.y), rect.size);
}

CGRect  CGRectSetTop(CGRect rect, CGFloat top)
{
    return CGRectMakeWithOriginSize(CGPointMake(rect.origin.x, top), rect.size);
}

CGRect  CGRectSetBottom(CGRect rect, CGFloat bottom)
{
    return CGRectMakeWithOriginSize(CGPointMake(rect.origin.x, bottom - CGRectGetHeight(rect)), rect.size);
}

CGPoint CGRectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect CGRectSetCenter(CGRect rect, CGPoint center)
{
    return CGRectSetOrigin(rect, CGPointMake(center.x - rect.size.width / 2.0f, center.y - rect.size.height / 2.0f));
}

CGRect CGRectMakeWithCenterSize(CGPoint center, CGSize size)
{
    return CGRectSetCenter(CGRectMakeWithSize(size), center);
}

CGFloat CGRectGetAspectRatio(CGRect rect)
{
    return CGSizeGetAspectRatio(rect.size);
}

CGFloat CGRectGetSquare(CGRect rect)
{
    return CGSizeGetSquare(rect.size);
}

CGRect CGRectMakeFillingRectWithAspectRatioContentGravity(CGRect circumscribingRect, CGFloat aspectRatio, NSString * const contentGravity)
{
    CGRect fillingRect = CGRectMakeWithCenterSize(CGRectCenter(circumscribingRect), CGSizeMakeFillingSizeWithAspectRatio(circumscribingRect.size, aspectRatio));
    
    if((contentGravity == kCAGravityLeft) ||
       (contentGravity == kCAGravityTopLeft) || 
       (contentGravity == kCAGravityBottomLeft))
    {
        fillingRect.origin.x = circumscribingRect.origin.x;
    }
    else if((contentGravity == kCAGravityRight) || 
            (contentGravity == kCAGravityTopRight) || 
            (contentGravity == kCAGravityBottomRight))
    {
        fillingRect.origin.x = circumscribingRect.origin.x + circumscribingRect.size.width - fillingRect.size.width;
    }
    
    if((contentGravity == kCAGravityTop) || 
       (contentGravity == kCAGravityTopLeft) || 
       (contentGravity == kCAGravityTopRight))
    {
        fillingRect.origin.y = circumscribingRect.origin.y;
    }
    else if((contentGravity == kCAGravityBottom) || 
            (contentGravity == kCAGravityBottomLeft) || 
            (contentGravity == kCAGravityBottomRight))
    {
        fillingRect.origin.y = circumscribingRect.origin.y + circumscribingRect.size.height - fillingRect.size.height;
    }
    
    return fillingRect;
}

CGRect CGRectMakeCircumscribingRectWithAspectRatioContentGravity(CGRect fillingRect, CGFloat aspectRatio, NSString * const contentGravity)
{
    CGRect circumscribingRect = CGRectMakeWithCenterSize(CGRectCenter(fillingRect), CGSizeMakeCircumscribingSizeWithAspectRatio(fillingRect.size, aspectRatio));
    
    if((contentGravity == kCAGravityLeft) ||
       (contentGravity == kCAGravityTopLeft) || 
       (contentGravity == kCAGravityBottomLeft))
    {
        circumscribingRect.origin.x = fillingRect.origin.x;
    }
    else if((contentGravity == kCAGravityRight) || 
            (contentGravity == kCAGravityTopRight) || 
            (contentGravity == kCAGravityBottomRight))
    {
        circumscribingRect.origin.x = fillingRect.origin.x + fillingRect.size.width - circumscribingRect.size.width;
    }
    
    if((contentGravity == kCAGravityTop) || 
       (contentGravity == kCAGravityTopLeft) || 
       (contentGravity == kCAGravityTopRight))
    {
        circumscribingRect.origin.y = fillingRect.origin.y;
    }
    else if((contentGravity == kCAGravityBottom) || 
            (contentGravity == kCAGravityBottomLeft) || 
            (contentGravity == kCAGravityBottomRight))
    {
        circumscribingRect.origin.y = fillingRect.origin.y + fillingRect.size.height - circumscribingRect.size.height;
    }
    
    return circumscribingRect;
}

CGRect CGRectMakeFillingRectWithAspectRatio(CGRect circumscribingRect, CGFloat aspectRatio)
{
    return CGRectMakeFillingRectWithAspectRatioContentGravity(circumscribingRect, aspectRatio, kCAGravityCenter);
}

CGRect CGRectMakeCircumscribingRectWithAspectRatio(CGRect fillingRect, CGFloat aspectRatio)
{
    return CGRectMakeCircumscribingRectWithAspectRatioContentGravity(fillingRect, aspectRatio, kCAGravityCenter);
}

CGImageRef CGImageCreateFliped(CGImageRef image)
{
    CGSize imageSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef imageContext = CGBitmapContextCreate(NULL,
                                                      (size_t)imageSize.width,
                                                      (size_t)imageSize.height,
                                                      8,
                                                      imageSize.width * 4,
                                                      colorSpace,
                                                      kCGImageAlphaPremultipliedLast);
    
    CGContextScaleCTM(imageContext, -1.0, -1.0);
    CGContextTranslateCTM(imageContext, -imageSize.width, -imageSize.height);
    
    CGContextDrawImage(imageContext, CGRectMakeWithSize(imageSize), image);
    
    CGImageRef flipedImage = CGBitmapContextCreateImage(imageContext);
    
    CGContextRelease(imageContext);
    CGColorSpaceRelease(colorSpace);
    
    return flipedImage;
}