//
//  NotificationCell.h
//  Hawkist
//
//  Created by Anton on 25.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWNotification.h"

@protocol NotificationCellDelegate <NSObject>

- (void) selectedUser:(NSString*)userId;
- (void) selectedItem:(NSString*)itemId;
- (void) selectedComment:(NSString*)itemId;
- (void) selectedText:(HWNotification*)notification;

@end


@interface NotificationCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *time;

@property (nonatomic, strong) id<NotificationCellDelegate> notificationCellDelegate;

@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textHeight;
//+ (CGFloat) heightWith:(NSString*)text;
- (void) setCellWithNotification:(HWNotification*)notification andText:(NSMutableAttributedString*)text;
+ (CGFloat) heightWithAttributedString:(NSMutableAttributedString*)text;
@end


