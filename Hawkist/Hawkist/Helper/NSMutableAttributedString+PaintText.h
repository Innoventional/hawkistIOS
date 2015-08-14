//
//  NSAttributedString+PaintText.h
//  Hawkist
//
//  Created by User on 13.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (PaintText)

-(void) paintOverWordWithString:(NSString*)str withText:(NSString*)text withColor:(UIColor*)color;

@end
