//
//  HWCommentCell.h
//  Hawkist
//
//  Created by User on 22.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWComment;

@protocol HWCommentCellDelegate;


@interface HWCommentCell : UITableViewCell

@property (nonatomic, weak) id <HWCommentCellDelegate> delegate;

- (void) setCellWithComment:(HWComment*)comment;

@end


@protocol HWCommentCellDelegate <NSObject>

- (void) transitionToProfileWithUserId:(NSString*)userId;

@end