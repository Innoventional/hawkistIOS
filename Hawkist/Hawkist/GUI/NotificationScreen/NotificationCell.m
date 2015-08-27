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

@interface NotificationCell()

@property (nonatomic,strong) UITapGestureRecognizer *recognizer;
@property (nonatomic, strong) HWNotification* notification;

@end
@implementation NotificationCell


- (void) setCellWithNotification:(HWNotification*)notification andText:(NSMutableAttributedString*)text
{
    
    self.notification = notification;
    
    self.avatar.image = nil;
    self.itemImage.image = nil;
    self.time.text = @"";
    self.textView.text = @"";
    self.textHeight.constant = [NotificationCell heightWithAttributedString:text];
    
    [self initDefault:notification];
    
    self.textView.attributedText = text;
    
    self.recognizer = [[UITapGestureRecognizer alloc]
                       initWithTarget:self action:@selector(tap:)];
    
    [self.recognizer setCancelsTouchesInView:NO];
    
    [self.textView addGestureRecognizer:self.recognizer];
    
    self.textHeight.constant = [NotificationCell heightWithAttributedString:text];
    
}


- (void) tap:(UITapGestureRecognizer *)recognizer
{
    UITextView *textView = (UITextView *)recognizer.view;
    
    // Location of the tap in text-container coordinates
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    // Find the character that's been tapped on
    
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    
    if (characterIndex < textView.textStorage.length) {
        
        NSRange range;
        NSString *value = [textView.attributedText attribute:@"Tag" atIndex:characterIndex effectiveRange:&range];
        
        // Handle as required...
        
        NSLog(@"%@, %d, %d", value, range.location, range.length);
        
        
        switch ([value integerValue]) {
            case 1:
            {
                if (self.notificationCellDelegate && [self.notificationCellDelegate respondsToSelector: @selector(selectedUser:)])
                    [self.notificationCellDelegate selectedUser:self.notification.user.id];
                break;
            }
            case 2:
            {
                if (self.notificationCellDelegate && [self.notificationCellDelegate respondsToSelector: @selector(selectedItem:)])
                    [self.notificationCellDelegate selectedItem:self.notification.listing.id];
                break;
            }
            case 3:
            {
                if (self.notificationCellDelegate && [self.notificationCellDelegate respondsToSelector: @selector(selectedComment:)])
                    [self.notificationCellDelegate selectedComment:self.notification.listing.id];
                break;
            }
            default:
            {
                if (self.notificationCellDelegate && [self.notificationCellDelegate respondsToSelector: @selector(selectedText:)])
                    [self.notificationCellDelegate selectedText:self.notification];

            }
                break;
        }
        
    }

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
    if (self.notificationCellDelegate && [self.notificationCellDelegate respondsToSelector: @selector(selectedUser:)])
        [self.notificationCellDelegate selectedUser:self.notification.user.id];
    NSLog(@"ava");
}
- (IBAction)itemIconSelect:(id)sender {
    if (self.notificationCellDelegate && [self.notificationCellDelegate respondsToSelector: @selector(selectedItem:)])
        [self.notificationCellDelegate selectedItem:self.notification.listing.id];
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
