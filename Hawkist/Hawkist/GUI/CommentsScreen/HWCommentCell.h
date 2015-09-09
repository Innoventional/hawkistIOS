//
//  HWCommentCell.h
//  Hawkist
//
//  Created by User on 22.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "TextViewWithDetectedWord.h"

@class HWComment;
@class HWItem;


@protocol HWCommentCellDelegate;


@interface HWCommentCell : SWTableViewCell

@property (nonatomic, strong) NSString *offerId;
@property (nonatomic, weak) id <HWCommentCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet TextViewWithDetectedWord *textView;

@property (nonatomic, weak) IBOutlet UIImageView *swipeImage;


+ (CGFloat) heightWith:(NSString*)text;
- (void) setCellWithComment:(HWComment*)comment;

@end


@protocol HWCommentCellDelegate <NSObject>

- (void) transitionToViewItemWithItem:(HWItem*)item;
- (void) transitionToProfileWithUserId:(NSString*)userId;
- (void) stringWithTapWord:(NSString*)text;


@end