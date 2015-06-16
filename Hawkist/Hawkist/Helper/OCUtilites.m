//
//  OCUtilites.m
//  FaceToFace
//
//  Created by Svyatoslav on 12/8/14.
//  Copyright (c) 2014 Franklin Ross. All rights reserved.
//

#import "OCUtilites.h"

#define STATUS_BAR_HEIGHT           20.0f
#define KEYBOARD_HEIGHT             216.0f
#define NAVIGATION_BAR_HEIGHT       44.0f
#define TAB_BAR_HEIGHT              49.0f



@implementation OCUtilites

#pragma mark - System
+ (BOOL)isIos7{
    NSString *iosVersion = [[[UIDevice currentDevice] systemVersion] substringToIndex:1];
    if ([iosVersion integerValue] == 7) {
        return YES;
    }
    return NO;
}

+ (BOOL)isLessThanIOS8 {
    return (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0));
}

+ (int) deviceModel
{
    CGFloat height = [UIApplication sharedApplication].keyWindow.bounds.size.height;
    
    if (height < 568)
    {
        return 4;
    }
    else if (height == 568)
    {
        return 5;
    }
    else
    {
        return 6;
    }
}

#ifdef __IPHONE_8_0

+ (BOOL)checkNotificationType:(UIUserNotificationType)type
{
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    return (currentSettings.types & type);
}

#endif

+ (void)setApplicationBadgeNumber:(NSInteger)badgeNumber
{
    UIApplication *application = [UIApplication sharedApplication];
    
#ifdef __IPHONE_8_0
    // compile with Xcode 6 or higher (iOS SDK >= 8.0)
    
    if([OCUtilites isLessThanIOS8])
    {
        application.applicationIconBadgeNumber = badgeNumber;
    }
    else
    {
        if ([OCUtilites checkNotificationType:UIUserNotificationTypeBadge])
        {
            NSLog(@"badge number changed to %d", badgeNumber);
            application.applicationIconBadgeNumber = badgeNumber;
        }
        else
            NSLog(@"access denied for UIUserNotificationTypeBadge");
    }
    
#else
    // compile with Xcode 5 (iOS SDK < 8.0)
    application.applicationIconBadgeNumber = badgeNumber;
    
#endif
}

#pragma mark - Dimension
+ (CGRect)frameForStandardPlateButton{
    return CGRectMake(0.0f, 0.0f, 96.0f, 48.f);
}
+ (CGRect)frameForSimpleLinearButton{
    return CGRectMake(0.0f, 0.0f, 96.0f, 24.f);
}

+ (CGFloat)heightStatusBar{
    return STATUS_BAR_HEIGHT;
}
+ (CGFloat)heightKeyboard{
    return KEYBOARD_HEIGHT;
}
+ (CGFloat)heightNavigationBar{
    return NAVIGATION_BAR_HEIGHT;
}
+ (CGFloat)heightNavigationBarForViewController:(UIViewController*)viewController{
    return viewController.navigationController.toolbar.frame.size.height;
}

+ (CGFloat)heightTabBar{
    return TAB_BAR_HEIGHT;
}
+ (CGFloat)heightTabBarForViewController:(UIViewController*)viewController{
    return viewController.tabBarController.tabBar.frame.size.height;
}

#pragma mark - Images
+ (UIImage*)imageForNavigationControllerWithStatusBarColor:(UIColor*)statusBarColor navigationBarColor:(UIColor*)navBarColor{
    CGRect topRect = CGRectMake(0.0f, 0.0f, 320.0f, 20.0f);
    CGRect underRect = CGRectMake(0.0f, 20.0f, 320.0f, 44.0f);
    
    UIGraphicsBeginImageContext(CGSizeMake(topRect.size.width, topRect.size.height + underRect.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [statusBarColor CGColor]);
    CGContextFillRect(context, topRect);
    
    CGContextSetFillColorWithColor(context, [navBarColor CGColor]);
    CGContextFillRect(context, underRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Colors
+ (UIColor*)randomColor{
    return [UIColor colorWithRed:(rand()%255)/255.0
                           green:(rand()%255)/255.0
                            blue:(rand()%255)/255.0
                           alpha:1.0];
}
+ (UIColor*)colorTextLightGrey{
    float rgbNum = 151.0f / 255.0f;
    return [UIColor colorWithRed:rgbNum green:rgbNum blue:rgbNum alpha:1];
}
+ (UIColor*)colorBgBlue{
    return [UIColor colorWithRed:1.0f / 255.f green:177.0f / 255.f blue:234.0f / 255.f alpha:1];
}
+ (UIColor*)colorBgGrey{
    float rgbNum = 216.0f / 255.0f;
    return [UIColor colorWithRed:rgbNum green:rgbNum blue:rgbNum alpha:1];
}
+ (UIColor*)colorBgLightGrey{
    float rgbNum = 239.0f / 255.0f;
    return [UIColor colorWithRed:rgbNum green:rgbNum blue:rgbNum alpha:1];
}
+ (UIColor*)colorDarkBlue{
    return [UIColor colorWithRed:14.0f / 255.f green:128.0f / 255.f blue:188.0f / 255.f alpha:1.0f];
}
+ (UIColor*)colorStatusBar{
    float rgbNum = 244.0f / 255.0f;
    return [UIColor colorWithRed:rgbNum green:rgbNum blue:rgbNum alpha:1];
}
+ (UIColor*)colorTurquoise{
    return [UIColor colorWithRed:79.0f / 255.0f green:192.0f / 255.0f blue:214.0f / 255.0f alpha:1];
}
+ (UIColor*)colorHome
{
    return [UIColor colorWithRed: 1.0 green: 144.0 / 255.0 blue: 0 alpha: 1.0];
}
+ (UIColor*)colorFavorites
{
    return [UIColor colorWithRed: 138.0/255.0 green: 60.0/255.0 blue: 145.0/255.0 alpha: 1.0];
}
+ (UIColor*)colorCategories
{
    return [UIColor colorWithRed: 65.0/255.0 green: 124.0/255.0 blue: 170.0/255.0 alpha: 1.0];
}
+ (UIColor*)colorChats
{
    return [UIColor colorWithRed: 0.0/255.0 green: 202.0/255.0 blue: 216.0/255.0 alpha: 1.0];
}
+ (UIColor*)colorProfiles
{
    return [UIColor colorWithRed: 244.0/255.0 green: 103.0/255.0 blue: 75.0/255.0 alpha: 1.0];
}
+ (UIColor*)colorMyProfileHeader
{
    return [UIColor colorWithRed: 192.0/255.0 green: 68.0/255.0 blue: 29.0/255.0 alpha: 1.0];
}
+ (UIColor*)colorSettigns
{
    return [UIColor colorWithRed: 115.0/255.0 green: 115.0/255.0 blue: 115.0/255.0 alpha: 1.0];
}

+ (UIColor *)colorGreen
{
    return [UIColor colorWithRed: 49.0/255.0 green: 213.0/255.0 blue: 87.0/255.0 alpha: 1.0];
}

#pragma mark - Date / Date Formatters
+ (NSDateFormatter*)uiDateFormatter{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"]; // 12/27/1937
    return dateFormatter;
}

+ (NSDate *)dateFromDateTimeString:(NSString *)dateTimeString{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [dateFormat setTimeZone:timeZone];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSArray *arraySplit = [dateTimeString componentsSeparatedByString:@"."];
    NSString *formattedDate = [arraySplit objectAtIndex:0];
    NSDate *date = [dateFormat dateFromString:formattedDate];
    
    return date;
}

+ (NSDate *)dateFromDateString:(NSString *)dateString{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *arraySplit = [dateString componentsSeparatedByString:@"."];
    NSString *formattedDate = [arraySplit objectAtIndex:0];
    NSDate *date = [dateFormat dateFromString:formattedDate];
    
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

+ (NSString*) literalStringFromDate: (NSDate*) date
{
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"MMM dd, yyyy h:mm a"];
    
    NSString *dateString = [dateFormat stringFromDate: date];
    
    return dateString;
}

+ (NSString *)serverStringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

+ (NSString*) chatDateStringFromDate: (NSDate*) date
{
    NSString* resultString = nil;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone         = [NSTimeZone localTimeZone];
    dateFormatter.locale           = [NSLocale currentLocale];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970];
    
    if (interval < (60 * 60 * 24))
    {
        //dateFormatter.dateFormat       = @"hh:mm a";
        [dateFormatter setDateStyle: NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle: NSDateFormatterShortStyle];
        
        resultString = [dateFormatter stringFromDate: date];
    }
    else if (interval < (60 * 60 * 24 * 2))
    {
        resultString = @"Yesterday";
    }
    else
    {
        if (interval < (60 * 60 * 24 * 7))
            dateFormatter.dateFormat = @"EEEE";
        else
        {
            //dateFormatter.dateFormat = @"dd/MM/yy";
            [dateFormatter setDateStyle: NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle: NSDateFormatterNoStyle];
        }
        
        resultString = [dateFormatter stringFromDate: date];
    }
    
    return resultString;
}

#pragma mark - Time

+ (NSString*) timeStringFromDate: (NSDate*) date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone         = [NSTimeZone localTimeZone];
    dateFormatter.locale           = [NSLocale currentLocale];
    
    [dateFormatter setDateStyle: NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle: NSDateFormatterShortStyle];
    
    return [dateFormatter stringFromDate: date];
}

+ (NSString*)timeStringFromTimeIntervalInSecs:(NSTimeInterval)time{
    return [NSString stringWithFormat:@"%.2d:%.2d:%.2d", (int)((time/60)/60), ((int)(time/60))%60, ((int)time)%60];
}

+ (NSString*)callTimeStringFromTimeIntervalInSecs:(NSTimeInterval)time{
    
    NSString *timeString;
    
    if (time < 60 * 60)
    {
        timeString = [NSString stringWithFormat:@"%.2d:%.2d", ((int)(time/60))%60, ((int)time)%60];
    }else
    {
        timeString = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", (int)((time/60)/60), ((int)(time/60))%60, ((int)time)%60];
    }
    
    return timeString;
}

#pragma mark - Actions
+ (void)showPopup:(NSString*)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    });
}

#pragma mark - Verification

+ (BOOL) NSStringIsValidEmail:(NSString *)checkString{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - UIImage

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    float maxWidth = newSize.width;
    float maxHeight = newSize.height;
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth / maxHeight;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else{
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage*)smallImage:(UIImage *)image{
    return [self imageWithImage:image scaledToSize:CGSizeMake(640., 1136.)];
}

+ (UIImage *)thumbnail:(UIImage *)image{
    return [self imageWithImage:image scaledToSize:CGSizeMake(146., 146.)];
}

+ (UIImage*)roundedImage:(UIImage*)image forViewRect: (CGRect) rect;
{
    CGSize imageSize = image.size;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    
    CGFloat radius = imageSize.height > imageSize.width ? imageSize.width : imageSize.height;
    
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:radius] addClip];
    [image drawInRect:rect];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

+ (UIViewController *)topMostController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

//+ (UIViewController*) topMostController{
//    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
//
//    while (topController.presentedViewController) {
//
//        if ([NSStringFromClass([topController.presentedViewController class]) isEqualToString:@"_UIModalItemsPresentingViewController"]){
//            break;
//        }
//
//        topController = topController.presentedViewController;
//    }
//
//    return topController;
//}

@end
