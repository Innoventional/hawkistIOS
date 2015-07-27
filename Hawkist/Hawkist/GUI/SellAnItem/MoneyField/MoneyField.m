//
//  MoneyField.m
//  Hawkist
//
//  Created by Anton on 02.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "MoneyField.h"

@implementation MoneyField

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView* sub = [[[NSBundle mainBundle]loadNibNamed:@"money" owner:self options:nil]firstObject];
        
        sub.frame = self.bounds;
        
        [self addSubview:sub];
        
        _textField.delegate = self;
    }
    return self;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@","])
    {
        
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@"."];
        return NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(moneyField:shouldChangeCharactersInRange:replacementString:)])
        [self.delegate moneyField:textField shouldChangeCharactersInRange:range replacementString:string];
    

    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
    
    if ([arrayOfString count] > 2 )
        return NO;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(moneyFieldDidBeginEditing:)])
        [self.delegate moneyFieldDidBeginEditing:self];
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{

    if ([textField.text isEqualToString:@""])
    {
        textField.text=@"0.00";
    }
    
    
    NSString *newString = textField.text;
    NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
    
    if ([arrayOfString count] == 1 )
        textField.text=[textField.text stringByAppendingString:@".00"];
    
    if ([textField.text doubleValue] > 5000)
    {
        if (self.delegate && [self.delegate respondsToSelector: @selector(moneyFieldPriceToHight:)])
            [self.delegate moneyFieldPriceToHight:self];
        
        textField.text = @"0.00";
    }
    else
    
    {
       NSString* result = [NSString stringWithFormat:@"%0.2f", [textField.text doubleValue]];
        
        
        textField.text = result;
        if (self.delegate && [self.delegate respondsToSelector: @selector(moneyField:modifyTo:)])
        [self.delegate moneyField:self modifyTo:result];
    
    
    }
    return YES;
}

@end
