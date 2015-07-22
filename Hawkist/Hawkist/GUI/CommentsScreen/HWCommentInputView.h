//
//  HWCommentInputView.h
//  Hawkist
//
//  Created by User on 22.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWCommentInputViewDelegate;
@class SZTextView;

@interface HWCommentInputView : UIView
@property (nonatomic, weak) IBOutlet SZTextView *textView;
@property (nonatomic, weak) id<HWCommentInputViewDelegate> delegate;
@end


@protocol HWCommentInputViewDelegate <NSObject>

- (void) pressPostButton:(UIButton*)sender withCommentText:(NSString*)text;

@end