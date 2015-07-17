//
//  HWTag+Extensions.h
//  Hawkist
//
//  Created by Anton on 16.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWTag (Extensions)

+ (HWTag*) getPlatformById:(NSInteger)tagId from:(NSMutableArray*)tags;
+ (HWCategory*) getCategoryById:(NSInteger)tagId from:(NSArray*)categories;
+ (HWSubCategories*) getSubCategoryById:(NSInteger)tagId from:(NSArray*)subCategories;
+ (HWCondition*) getConditionById:(NSInteger)tagId from:(NSArray*)conditions;
+ (HWColor*) getColorById:(NSInteger)tagId from:(NSArray*)colors;

+ (UIColor *)colorWithHexString:(NSString *)str;

@end
