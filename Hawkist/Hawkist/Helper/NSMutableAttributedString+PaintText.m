//
//  NSAttributedString+PaintText.m
//  Hawkist
//
//  Created by User on 13.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "NSMutableAttributedString+PaintText.h"

@implementation NSMutableAttributedString (PaintText)



-(void) paintOverWordWithString:(NSString*)str withText:(NSString*)text withColor:(UIColor*)color
{
    
    if(!color){
        color  = [UIColor colorWithRed:57./255. green:178./255. blue:154./255. alpha:1];
    }
    
    
    NSRange range = [text rangeOfString:str];
    
    [self beginEditing];
    [self addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:range];
    [self endEditing];
    
    
    
}



@end
