//
//  HWTag+Extensions.m
//  Hawkist
//
//  Created by Anton on 16.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWTag+Extensions.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:.9] 


@implementation HWTag (Extensions)

+ (HWTag*) getPlatformById:(NSInteger)tagId from:(NSMutableArray*)tags
{
    
    for (HWTag* tag in tags)
    {
        if([tag.id isEqual:[NSString stringWithFormat: @"%ld", tagId]])
        {
            return tag;
        }
    }
    
    return nil;
}

+ (HWCategory*) getCategoryById:(NSInteger)tagId from:(NSArray*)categories
{
    
    for (HWCategory* category in categories)
    {
        if([category.id isEqual:[NSString stringWithFormat: @"%ld", tagId]])
        {
            return category;
        }
    }
    
    return nil;
}

+ (HWSubCategories*) getSubCategoryById:(NSInteger)tagId from:(NSArray*)subCategories
{
    
    for (HWSubCategories* subCategory in subCategories)
    {
        if([subCategory.id isEqual:[NSString stringWithFormat: @"%ld", tagId]])
        {
            return subCategory;
        }
    }
    
    return nil;
}

+ (HWCondition*) getConditionById:(NSInteger)tagId from:(NSArray*)conditions
{
    
    for (HWCondition* condition in conditions)
    {
        if([condition.id isEqual:[NSString stringWithFormat: @"%ld", tagId]])
        {
            return condition;
        }
    }
    
    return nil;
}


+ (HWColor*) getColorById:(NSInteger)tagId from:(NSArray*)colors
{
    
    for (HWColor* color in colors)
    {
        if([color.id isEqual:[NSString stringWithFormat: @"%ld", tagId]])
        {
            return color;
        }
    }
    
    return nil;
}

+ (UIColor *)colorWithHexString:(NSString *)str {
   // NSString* resultS = [@"0x" stringByAppendingString: str];
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr, NULL, 16);

    
    return UIColorFromRGB(x);
}

+ (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}


@end
