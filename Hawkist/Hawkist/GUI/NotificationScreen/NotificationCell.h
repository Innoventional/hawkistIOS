//
//  NotificationCell.h
//  Hawkist
//
//  Created by Anton on 25.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWTableViewCell.h"
#import "TextViewWithDetectedWord.h"
#import "HWNotification.h"

@interface NotificationCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textHeight;
//+ (CGFloat) heightWith:(NSString*)text;
- (void) setCellWithNotification:(HWNotification*)notification andText:(NSMutableAttributedString*)text;
+ (CGFloat) heightWithAttributedString:(NSMutableAttributedString*)text;
@end
