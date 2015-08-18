//
//  HWFeedBackSegmentView.h
//  Hawkist
//
//  Created by User on 17.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWFedbackSegmentButton.h"

@protocol HWFeedBackSegmentViewDelegate;

@interface HWFeedBackSegmentView : UIView

@property (nonatomic, weak) id <HWFeedBackSegmentViewDelegate> delegate;


@property (nonatomic, weak) IBOutlet HWFedbackSegmentButton *positiveButton;
@property (nonatomic, weak) IBOutlet HWFedbackSegmentButton *neutralButton;

@property (nonatomic, weak) IBOutlet HWFedbackSegmentButton *negativeButton;

- (void) pressFirstButton;

@end



@protocol HWFeedBackSegmentViewDelegate <NSObject>

- (void) pressPositiveButton:(HWFedbackSegmentButton*) sender;
- (void) pressNeutralButton:(HWFedbackSegmentButton*) sender;
- (void) pressNegativeButton:(HWFedbackSegmentButton*) sender;


@end