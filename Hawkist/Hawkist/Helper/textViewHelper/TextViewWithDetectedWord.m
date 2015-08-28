//
//  TextViewWithDetectedWord.m
//  Hawkist
//
//  Created by User on 29.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "TextViewWithDetectedWord.h"

@implementation TextViewWithDetectedWord

- (instancetype) awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    
    if(self)
        {
       
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(textTapped:)];
            
            [self addGestureRecognizer:tapGesture];
        }
    
    return self;
}




- (void)textTapped:(UITapGestureRecognizer *)recognizer
{
    UITextView *textView = (UITextView *)recognizer.view;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    NSString *string = [self getWordAtPosition:location inTextView:self withString:@"@"];
    
    if( string && self.delegateForDetectedWord && [self.delegateForDetectedWord respondsToSelector:@selector(stringWithTapWord:)])
    {
        [self.delegateForDetectedWord stringWithTapWord:string];
    }
    
    
     string = [self getWordAtPosition:location inTextView:self withString:@"#"];
    
    if(string && self.delegateForDetectedWord && [self.delegateForDetectedWord respondsToSelector:@selector(stringWithTapItem:)])
    {
        [self.delegateForDetectedWord stringWithTapItem:string];
    }
    
    [self resignFirstResponder];
 
    
}


-(NSString*)getWordAtPosition:(CGPoint)pos inTextView:(UITextView*)_tv withString:(NSString*)character
{
  
    pos.y += _tv.contentOffset.y;
    UITextPosition *tapPos = [_tv closestPositionToPoint:pos];
    UITextRange * wr = [_tv.tokenizer rangeEnclosingPosition:tapPos withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];

    return [self stringForMantionWithTextRange:wr withString:character];

}


- (NSString*)stringForMantionWithTextRange:(UITextRange*)textRange withString:(NSString*)caracter
{
    NSMutableString *finalString = nil;
    
    NSInteger startOffset = [self offsetFromPosition:self.beginningOfDocument toPosition:textRange.start];
    NSInteger endOffset = [self offsetFromPosition:self.beginningOfDocument toPosition:textRange.end];
    NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);

    
    NSString *tempTextViewString = self.text;
    
    if([caracter isEqualToString:@"@"]) {
        if((offsetRange.location-1) > 160)
        {
            return finalString;
        }
    }
    
    NSString *selectedString = [tempTextViewString substringWithRange:NSMakeRange(offsetRange.location, offsetRange.length)];
    
    NSLog(@"%@", selectedString);
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@" \n"];
    NSArray * array = [tempTextViewString componentsSeparatedByCharactersInSet:charSet];
    
        for (NSString *str in array)
        {
            if([str containsString:selectedString] && [[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:caracter])
            {
                
                return str;
            }
        }
    
    
    return finalString;
    
}



/*
 
 -(NSString*)getWordAtPosition:(CGPoint)pos inTextView:(UITextView*)_tv
 {
 
 pos.y += _tv.contentOffset.y;
 UITextPosition *tapPos = [_tv closestPositionToPoint:pos];
 UITextRange * wr = [_tv.tokenizer rangeEnclosingPosition:tapPos withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
 
 return [self stringForMantionWithTextRange:wr];
 
 }
 
 
 - (NSString*)stringForMantionWithTextRange:(UITextRange*)textRange
 {
 NSMutableString *finalString = nil;
 
 NSInteger startOffset = [self offsetFromPosition:self.beginningOfDocument toPosition:textRange.start];
 NSInteger endOffset = [self offsetFromPosition:self.beginningOfDocument toPosition:textRange.end];
 NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
 
 
 NSString *tempTextViewString = self.text;
 if((offsetRange.location-1) > 160)
 {
 return finalString;
 }
 
 NSString *selectedString = [tempTextViewString substringWithRange:NSMakeRange(offsetRange.location, offsetRange.length)];
 
 NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
 NSArray * array = [tempTextViewString componentsSeparatedByCharactersInSet:charSet];
 
 for (NSString *str in array)
 {
 if([str containsString:selectedString] && [[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"@"])
 {
 
 return str;
 }
 }
 
 
 return finalString;
 
 }
 

 
 */



@end
