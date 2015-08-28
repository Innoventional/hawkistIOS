//
//  HWTapBarView.h
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 7/9/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWTapBarViewDelegate;

@interface HWTapBarView : UIView

@property (nonatomic, weak) id<HWTapBarViewDelegate> delegate;

- (void) updateBadge:(NSString*)text;

- (void) addContentView: (UIView*) view;

- (void) markSelected: (NSInteger) index;

@end

@protocol HWTapBarViewDelegate <NSObject>

- (void) itemAtIndexSelected: (NSInteger) index;

@end