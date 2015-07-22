//
//  HWCommentInputView.m
//  Hawkist
//
//  Created by User on 22.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWCommentInputView.h"
#import "SZTextView.h"

@interface HWCommentInputView ()




@end
@implementation HWCommentInputView



#pragma mark - 
#pragma mark Action

- (IBAction)postAction:(id)sender
{
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressPostButton:withCommentText:)])
    {
        [self.delegate pressPostButton:sender withCommentText:self.textView.text];
        self.textView.text = @"";
    }
}


 

@end
