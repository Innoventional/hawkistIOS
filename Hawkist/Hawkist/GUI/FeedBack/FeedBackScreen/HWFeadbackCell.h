//
//  HWFeadbackCell.h
//  Hawkist
//
//  Created by User on 18.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWFeadbackCellDelegate;

@interface HWFeadbackCell : UITableViewCell

@property (weak, nonatomic) id <HWFeadbackCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *messageText;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


- (void) setCellWithFeedback:(HWFeedback*) feedback;
+ (CGFloat) heightWith:(NSString*)text;

@end


@protocol HWFeadbackCellDelegate <NSObject>

- (void) transitionToProfileWithUserId:(NSString*)userId;


@end