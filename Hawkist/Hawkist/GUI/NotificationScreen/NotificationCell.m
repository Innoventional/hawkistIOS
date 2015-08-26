//
//  NotificationCell.m
//  Hawkist
//
//  Created by Anton on 25.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "NotificationCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+NVTimeAgo.h"

@interface NotificationCell() <TextViewWithDetectedWordDelegate>

@end

@implementation NotificationCell

- (void) setCellWithNotification:(HWNotification*)notification
{
    
    self.avatar.image = nil;
    self.itemImage.image = nil;
    self.time.text = @"Just Now";
    
    self.textView.text = @"NotFound";
    
    switch ([notification.type integerValue]) {
        case 0:
            
        {
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                            placeholderImage:nil];
            }
            
                NSString* text = [NSString stringWithFormat:@"%@ commented on %@ - '%@'",notification.user.username,notification.listing.title,notification.comment.text];
                
                self.itemImage.hidden = NO;
                self.textView.text = text;
            
            self.avatar.layer.cornerRadius = self.avatar.frame.size.width /2;
            self.avatar.layer.masksToBounds = YES;
            
                NSDate *time = [NSDate dateFromServerFormatString:notification.created_at];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMMM dd hh':'mm a"];
                self.time.text =  [dateFormatter stringFromDate:time];
           
            
            self.itemImage.layer.cornerRadius = 5;
            self.itemImage.layer.masksToBounds = YES;
            
            self.textHeight.constant = [NotificationCell heightWith:text];
            
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            break;
        }
            
            case 1:
        {
            
           // Your item (listing Title) has been sold to (username).
            
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                               placeholderImage:nil];
            }
            
            NSString* text = [NSString stringWithFormat:@"Your item %@ has been sold to %@",notification.listing.title,notification.user.username];
            
            self.itemImage.hidden = NO;
            self.textView.text = text;
            
            self.avatar.layer.cornerRadius = self.avatar.frame.size.width /2;
            self.avatar.layer.masksToBounds = YES;
            
            NSDate *time = [NSDate dateFromServerFormatString:notification.created_at];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMMM dd hh':'mm a"];
            self.time.text =  [dateFormatter stringFromDate:time];
            
            
            self.itemImage.layer.cornerRadius = 5;
            self.itemImage.layer.masksToBounds = YES;
            
            self.textHeight.constant = [NotificationCell heightWith:text];
            
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            break;
        }
            
            case 8:
        {
            //(username) is now following you.
            
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            NSString* text = [NSString stringWithFormat:@"%@ is now following you.",notification.user.username];
            
            self.itemImage.hidden = YES;
            
            self.textView.text = text;
            
            self.avatar.layer.cornerRadius = self.avatar.frame.size.width /2;
            self.avatar.layer.masksToBounds = YES;
            
            NSDate *time = [NSDate dateFromServerFormatString:notification.created_at];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMMM dd hh':'mm a"];
            self.time.text =  [dateFormatter stringFromDate:time];
            
            self.textHeight.constant = [NotificationCell heightWith:text];
            
            self.selectionStyle = UITableViewCellSelectionStyleNone;

            
            break;
        }
            
            
        default:
        {
            self.avatar.image = nil;
            self.itemImage.image = nil;
            self.time.text = @"Just Now";
            
            self.textView.text = @"NotFound";
            break;
        }
    }
    
    
}


+ (CGFloat) heightWith:(NSString*)text
{
    
    UITextView *textView = [[UITextView alloc]init];
    
    
    textView.text = text;
    
    textView.font =  [UIFont fontWithName:@"OpenSans" size:15.f];
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 119;
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
    ;
    
    
}
@end
