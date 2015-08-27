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


@implementation NotificationCell


- (void) setCellWithNotification:(HWNotification*)notification andText:(NSMutableAttributedString*)text
{
    
    self.avatar.image = nil;
    self.itemImage.image = nil;
    self.time.text = @"";
    self.textView.text = @"";
    self.textHeight.constant = [NotificationCell heightWithAttributedString:text];
    
    [self initDefault:notification];
    
    self.textView.attributedText = text;
    self.textHeight.constant = [NotificationCell heightWithAttributedString:text];
    
}


- (void) initDefault:(HWNotification*)notification
{
    if (notification.user.avatar)
    [self.avatar setImageWithURL:[[NSURL alloc]initWithString:notification.user.avatar]
                placeholderImage:[UIImage imageNamed:@"NoAvatar"]];
    if (notification.listing.photo){
        [self.itemImage setImageWithURL:[[NSURL alloc]initWithString:notification.listing.photo]
                       placeholderImage:nil];
        self.itemImage.hidden = NO;
    }
    else
    {
        self.itemImage.hidden = YES;
        self.rightButton.enabled = NO;
    }
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width /2;
    self.avatar.layer.masksToBounds = YES;
    
    NSDate *time = [NSDate dateFromServerFormatString:notification.created_at];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd hh':'mm a"];
    self.time.text =  [dateFormatter stringFromDate:time];
    
    
    self.itemImage.layer.cornerRadius = 5;
    self.itemImage.layer.masksToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (IBAction)avatarSelect:(id)sender {
    
    NSLog(@"ava");
}
- (IBAction)itemIconSelect:(id)sender {
    NSLog(@"item");
}

//+ (CGFloat) heightWith:(NSString*)text
//{
//    
//    UITextView *textView = [[UITextView alloc]init];
//    
//    
//    textView.text = text;
//    
//    textView.font =  [UIFont fontWithName:@"OpenSans" size:15.f];
//    CGFloat width = [UIScreen mainScreen].bounds.size.width - 119;
//    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
//    return size.height;
//    ;
//    
//    
//}

+ (CGFloat) heightWithAttributedString:(NSMutableAttributedString *)text
{
    
    UITextView *textView = [[UITextView alloc]init];
    
    
    textView.attributedText = text;
    
    //textView.font =  [UIFont fontWithName:@"OpenSans" size:15.f];
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 120;
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
    ;
    
    
}

@end
