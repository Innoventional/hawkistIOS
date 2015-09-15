//
//  TextViewWithDetectedWord.h
//  Hawkist
//
//  Created by User on 29.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextViewWithDetectedWordDelegate;

@interface TextViewWithDetectedWord : UITextView

@property (nonatomic, weak) id<TextViewWithDetectedWordDelegate> delegateForDetectedWord;

@end

@protocol TextViewWithDetectedWordDelegate <NSObject>

@optional

- (void) stringWithTapWord:(NSString*)text;
- (void) stringWithTapItem:(NSString*)text;

@end
