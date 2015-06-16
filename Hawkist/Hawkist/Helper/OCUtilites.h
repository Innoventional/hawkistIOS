//
//  OCUtilites.h
//  FaceToFace
//
//  Created by Svyatoslav on 12/8/14.
//  Copyright (c) 2014 Franklin Ross. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface OCUtilites : NSObject

#pragma mark - System
+ (BOOL)isIos7;
+ (int) deviceModel;
+ (void)setApplicationBadgeNumber:(NSInteger)badgeNumber;

#pragma mark - Dimension
+ (CGRect)frameForStandardPlateButton;
+ (CGRect)frameForSimpleLinearButton;

+ (CGFloat)heightStatusBar;
+ (CGFloat)heightKeyboard;
+ (CGFloat)heightNavigationBar;
+ (CGFloat)heightTabBar;

+ (CGFloat)heightNavigationBarForViewController:(UIViewController*)viewController;
+ (CGFloat)heightTabBarForViewController:(UIViewController*)viewController;

#pragma mark - Images
+ (UIImage*)imageForNavigationControllerWithStatusBarColor:(UIColor*)statusBarColor navigationBarColor:(UIColor*)navBarColor;

#pragma mark - Colors
+ (UIColor*)randomColor;
+ (UIColor*)colorTextLightGrey;
+ (UIColor*)colorBgBlue;
+ (UIColor*)colorBgGrey;
+ (UIColor*)colorBgLightGrey;
+ (UIColor*)colorDarkBlue;
+ (UIColor*)colorStatusBar;
+ (UIColor*)colorTurquoise;
+ (UIColor*)colorGreen;

+ (UIColor*)colorHome;
+ (UIColor*)colorFavorites;
+ (UIColor*)colorCategories;
+ (UIColor*)colorChats;
+ (UIColor*)colorProfiles;
+ (UIColor*)colorMyProfileHeader;
+ (UIColor*)colorSettigns;

#pragma mark - Date / Date Formatters
+ (NSDateFormatter*)uiDateFormatter;

+ (NSDate*)dateFromDateTimeString:(NSString*)dateTimeString;
+ (NSDate*)dateFromDateString:(NSString*)dateString;

+ (NSString*)stringFromDate:(NSDate*)date;
+ (NSString*) literalStringFromDate: (NSDate*) date;
+ (NSString*)serverStringFromDate:(NSDate*)date;
+ (NSString*) chatDateStringFromDate: (NSDate*) date;
+ (NSString*) timeStringFromDate: (NSDate*) date;

#pragma mark - Time
+ (NSString*)timeStringFromTimeIntervalInSecs:(NSTimeInterval)time;
+ (NSString*)callTimeStringFromTimeIntervalInSecs:(NSTimeInterval)time;

#pragma mark - Actions
+ (void)showPopup:(NSString*)message;

#pragma mark - Verification
+ (BOOL) NSStringIsValidEmail:(NSString *)checkString;

#pragma mark - UIImage
//+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage*)thumbnail:(UIImage*)image;
+ (UIImage*)smallImage:(UIImage*)image;
+ (UIImage*)roundedImage:(UIImage*)image forViewRect: (CGRect) rect;

#pragma mark - UIViewController
+ (UIViewController*) topMostController;

@end
