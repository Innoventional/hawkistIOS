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
            
            case 2:
        {// Has (listing Title) arrived yet? Let us know so we can pay the seller (username).
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                               placeholderImage:nil];
            }
            
            NSString* text = [NSString stringWithFormat:@"Has %@ arrived yet? Let us know so we can pay the seller %@",notification.listing.title,notification.user.username];
            
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
            
            case 3:
        {//(username) has left feedback about (listing Title).
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                               placeholderImage:nil];
            }
            
            NSString* text = [NSString stringWithFormat:@"%@ has left feedback about %@",notification.user.username,notification.listing.title];
            
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
        case 4:
        {// (username) has declined the price you offered for (listing Title). Click this notification to offer a new price.
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                               placeholderImage:nil];
            }
            
            NSString* text = [NSString stringWithFormat:@"%@ has declined the price you offered for %@. Click this notification to offer a new price.",notification.user.username,notification.listing.title];
            
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
            case 5:
            
        {
            
            //(username) has requested feedback on your purchase (listing Title).
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                               placeholderImage:nil];
            }
            
            NSString* text = [NSString stringWithFormat:@"%@ has requested feedback on your purchase %@",notification.user.username,notification.listing.title];
            
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
            
          
            
        case 6:
        {//(username) has favourited your item (listing Title).
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                               placeholderImage:nil];
            }
            
            NSString* text = [NSString stringWithFormat:@"%@ has favourited your item %@",notification.user.username,notification.listing.title];
            
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
        
        case 7:
        {//The item (listing Title) on your favourites list has been sold.
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                               placeholderImage:nil];
            }
            
            NSString* text = [NSString stringWithFormat:@"%@ on your favourites list has been sold.",notification.listing.title];
            
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
            
            case 9:
        {// (username) has created a new listing (listing Title)
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                               placeholderImage:nil];
            }
            
            NSString* text = [NSString stringWithFormat:@"%@ has created a new listing %@",notification.user.username,notification.listing.title];
            
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
            
        case 10:
        {//(username) has mentioned you in a comment.
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                               placeholderImage:nil];
            }
            
            NSString* text = [NSString stringWithFormat:@"%@ has mentioned your in a comment.",notification.user.username];
            
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
            case 11:
        {//(username) has offered £(offered price) for (listing Title).
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                               placeholderImage:nil];
            }
            
            NSString* text = [NSString stringWithFormat:@"%@ has offered £%@ for %@",notification.user.username,            notification.comment.offered_price,notification.listing.title];
            
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
            
        case 12:
        {
            //(username) has accepted the price you offered for (listing Title). Click this notification to buy the item.
            {}[self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                          placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                               placeholderImage:nil];
            }
            
            NSString* text = [NSString stringWithFormat:@"%@ has accepted the price you offered for %@. Click this notification to buy the item.",notification.user.username,notification.listing.title];
            
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
        case 13:
        {//(username) has declined the price you offered for (listing Title). Click this notification to offer a new price.
            [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                        placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
            
            if (notification.listing.photo){
                [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                               placeholderImage:nil];
            }
            
            NSString* text = [NSString stringWithFormat:@"%@ has declined the price you offered for %@. Click this notification to offer a new price.",notification.user.username,notification.listing.title];
            
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
