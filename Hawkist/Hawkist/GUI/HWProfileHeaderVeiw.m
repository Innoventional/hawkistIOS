//
//  HWProfileHeaderVeiw.m
//  Hawkist
//
//  Created by User on 26.09.15.
//  Copyright © 2015 TecSynt Solutions. All rights reserved.
//

#import "HWProfileHeaderVeiw.h"
#import "StarRatingControl.h"
#import "HWButtonForSegment.h"
#import "UIImageView+Extensions.h"
#import "NSDate+NVTimeAgo.h"

#import "HWUser.h"

#import "HWButtonForSegment.h"


@interface HWProfileHeaderVeiw ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *segmentView;


@property (weak, nonatomic) IBOutlet StarRatingControl *starRatingView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSeenLabel;
@property (weak, nonatomic) IBOutlet UILabel *responsTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (weak, nonatomic) IBOutlet UIButton *followUnfollowButton;

@property (strong, nonatomic) IBOutletCollection(HWButtonForSegment) NSArray *buttonSegmentCollection;
@property (weak, nonatomic) IBOutlet HWButtonForSegment *itemsButton;
@property (weak, nonatomic) IBOutlet HWButtonForSegment *followingButton;
@property (weak, nonatomic) IBOutlet HWButtonForSegment *followersButton;
@property (weak, nonatomic) IBOutlet HWButtonForSegment *wishlistButton;

 @property (nonatomic, weak) IBOutlet UIButton *feedbackBut;

@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, strong) HWUser *user;


@property (nonatomic, assign) BOOL isFollow;

@end


@implementation HWProfileHeaderVeiw

#pragma mark - update

- (void)updateWithUser:(HWUser *)user
{
    self.user = user;
    

    if ([user.id isEqual:[AppEngine shared].user.id])
    {
        self.followUnfollowButton.hidden = YES;
    }
    else
    {
        self.followUnfollowButton.hidden = NO;
    }
    [self.avatarView setImageWithUrl:[NSURL URLWithString: self.user.avatar]
                       withIndicator:self.indicator];
    
    self.isFollow = [user.following boolValue];

    self.userNameLabel.text = self.user.username;
    if(self.user.city)
    {
        self.locationLabel.text =  [NSString stringWithFormat:@"%@, United Kingdom  ", self.user.city];
    }
    self.starRatingView.rating = [self.user.rating integerValue];
    self.ratingLabel.text = [NSString stringWithFormat:@"%@ (%@ reviews)",self.user.rating,self.user.review];
    self.salesLabel.text = self.user.number_of_sales;
    NSString *aboutTitle = [NSString stringWithFormat:@"    ABOUT %@",self.user.username.uppercaseString];
    [self.aboutButton setTitle:aboutTitle forState:UIControlStateNormal];
    
    NSDate *lastActivityDate = [NSDate dateFromServerFormatString:self.user.last_activity];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a MMM dd, yyyy"];

    self.lastSeenLabel.text = [dateFormatter stringFromDate:lastActivityDate];
    
    NSInteger time = [self.user.response_time integerValue];
    NSUInteger d = time / (3600 *24);
    NSUInteger h = (time - d*(3600 *24)) / 3600;
    NSUInteger m = (time / 60) % 60;
    NSString *strTime;
    

    if(d || d>=3) {
        
        strTime = d>=3 ? @"72 hours+" : [NSString stringWithFormat:@"%lu day %lu hrs", (unsigned long)d, (unsigned long)h];
        
    } else if(h) {
        
        strTime =  [NSString stringWithFormat:@"%lu hrs %lu min", (unsigned long)h, (unsigned long)m];
    } else  {
        
        strTime =  [NSString stringWithFormat:@"%lu min", (unsigned long)m];
    }
    
    self.responsTimeLabel.text = strTime;

}

- (void)updateWithArrayItems:(NSArray *)items
               withFollowing:(NSArray *)following
               withFollowers:(NSArray *)followers
                withWishlist:(NSArray *)wishlist
{
    self.itemsButton.titleButton.text = @"ITEMS";
    self.itemsButton.count.text = [NSString stringWithFormat:@"%lu", (unsigned long)items.count];
    
    self.followersButton.titleButton.text = @"FOLLOWERS";
    self.followersButton.count.text = [NSString stringWithFormat:@"%lu", (unsigned long)followers.count];
    
    self.followingButton.titleButton.text = @"FOLLOWING";
    self.followingButton.count.text = [NSString stringWithFormat:@"%lu", (unsigned long)following.count];
    
    self.wishlistButton.titleButton.text = @"WISHLIST";
    self.wishlistButton.count.text = [NSString stringWithFormat:@"%lu", (unsigned long)wishlist.count];

}

- (void)setHideFollowButton:(BOOL)hideFollowButton
{
    self.followUnfollowButton.hidden = hideFollowButton;
    _hideFollowButton = hideFollowButton;
}

- (void)updateSelectedButtonIndex:(NSInteger) selectedButIndex
{
    switch (selectedButIndex) {
        case 0:
            [self itemsAction:self.itemsButton];
            break;
        case 1:
            
            [self followingAction:self.followingButton];
            break;
        case 2:
            
            [self followersAction:self.followersButton];
            break;
        case 3:
            
            [self wishlistAction:self.wishlistButton];
            break;
            
        default:
            break;
    }
}
+ (CGFloat)heightHeaderView
{
    return 335;
}

- (void) setIsFollow:(BOOL)isFollow
{
    if (isFollow)
    {
        [self.followUnfollowButton setTitle:@" UNFOLLOW " forState:UIControlStateNormal];
        self.followUnfollowButton.backgroundColor = [UIColor colorWithRed:97./255. green:97./255. blue:97./255. alpha:1];
    }
    else
    {
        [self.followUnfollowButton setTitle:@"  FOLLOW  " forState:UIControlStateNormal];
        self.followUnfollowButton.backgroundColor = [UIColor colorWithRed:55./255. green:185./255. blue:165./255. alpha:1];
    }
    _isFollow = isFollow;
}


#pragma mark - action

- (IBAction)itemsAction:(id)sender
{
    [self configurationSegmentButton:sender];
    if (self.delegate)
    {
        [self.delegate itemsAction:sender];
    }
}

- (IBAction)followingAction:(id)sender
{
    [self configurationSegmentButton:sender];
    if (self.delegate)
    {
        [self.delegate followingAction:sender];
    }
}

- (IBAction)followersAction:(id)sender
{
    [self configurationSegmentButton:sender];
    if (self.delegate)
    {
        [self.delegate followersAction:sender];
    }
}

- (IBAction)wishlistAction:(id)sender
{
    [self configurationSegmentButton:sender];
    if (self.delegate)
    {
        [self.delegate wishlistAction:sender];
    }
}

- (IBAction)followUnfollowAction:(id)sender
{
    
    if (self.delegate)
    {
        [self.delegate followUnfollowAction:sender withIsFollow:self.isFollow];
    }
    
    self.isFollow = !self.isFollow;
}

- (IBAction)aboutMeAction:(id)sender
{
    if (self.delegate)
    {
        [self.delegate aboutMeAction:sender];
    }
}


- (IBAction)feedbackAction:(id)sender
{
    if (self.delegate)
    {
        [self.delegate feedbackButton:sender];
    }
}

- (void) configurationSegmentButton:(HWButtonForSegment *)button
{
    for (HWButtonForSegment *button in self.buttonSegmentCollection)
    {
        button.selectedImage.hidden = YES;
    }
    
     button.selectedImage.hidden = NO;
}

@end
