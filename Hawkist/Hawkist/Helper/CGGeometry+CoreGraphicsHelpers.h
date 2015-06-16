
#import <QuartzCore/QuartzCore.h>

CGPoint CGPointMakeMiddle(NSUInteger count, CGPoint firstPoint, ...);
CGPoint CGPointMakeMiddleWithPoints(NSUInteger count, CGPoint *points);
CGPoint CGPointMakeMiddleWithPointsArray(NSArray *points); // points are NSValue objects

CGPoint CGPointCeil(CGPoint point);

CGPoint CGPointMultiply(CGPoint point, CGFloat multiplier);
CGPoint CGPointDevide(CGPoint point, CGFloat devider);


CGSize  CGSizeMakeSquare(CGFloat size); // CGSizeMake(size, size)

CGSize  CGSizeCeil(CGSize size);

CGFloat CGSizeGetAspectRatio(CGSize size);
CGFloat CGSizeGetSquare(CGSize size);

CGSize  CGSizeMultiply(CGSize size, CGFloat multiplier);
CGSize  CGSizeDevide(CGSize size, CGFloat devider);

CGSize  CGSizeMakeFillingSizeWithAspectRatio(CGSize circumscribingSize, CGFloat aspectRatio);
CGSize  CGSizeMakeCircumscribingSizeWithAspectRatio(CGSize fillingSize, CGFloat aspectRatio);


CGRect  CGRectMakeWithOriginSize(CGPoint origin, CGSize size);
CGRect  CGRectMakeWithSize(CGSize size);
CGRect  CGRectMakeBounds(CGRect rect);
CGRect  CGRectMakeSquare(CGFloat size);

CGRect  CGRectInsets(CGRect rect, CGFloat leftInset, CGFloat rightInset, CGFloat topInset, CGFloat bottomInset);

CGRect  CGRectCeil(CGRect rect);

CGRect  CGRectSetOrigin(CGRect rect, CGPoint origin);
CGRect  CGRectSetLeft(CGRect rect, CGFloat left); // only origin will be changed
CGRect  CGRectSetRight(CGRect rect, CGFloat right); // only origin will be changed
CGRect  CGRectSetTop(CGRect rect, CGFloat top); // only origin will be changed
CGRect  CGRectSetBottom(CGRect rect, CGFloat bottom); // only origin will be changed
CGPoint CGRectCenter(CGRect rect);
CGRect  CGRectSetCenter(CGRect rect, CGPoint center); // only origin will be changed
CGRect  CGRectMakeWithCenterSize(CGPoint center, CGSize size);

CGFloat CGRectGetAspectRatio(CGRect rect);
CGFloat CGRectGetSquare(CGRect rect);

CGRect  CGRectMakeFillingRectWithAspectRatioContentGravity(CGRect circumscribingRect, CGFloat aspectRatio, NSString * const contentGravity);
CGRect  CGRectMakeCircumscribingRectWithAspectRatioContentGravity(CGRect fillingRect, CGFloat aspectRatio, NSString * const contentGravity);

CGRect  CGRectMakeFillingRectWithAspectRatio(CGRect circumscribingRect, CGFloat aspectRatio); // center
CGRect  CGRectMakeCircumscribingRectWithAspectRatio(CGRect fillingRect, CGFloat aspectRatio); // center


CGImageRef CGImageCreateFliped(CGImageRef image);
