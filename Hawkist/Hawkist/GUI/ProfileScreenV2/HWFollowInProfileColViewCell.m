//
//  HWFollowInProfileColViewCell.m
//  Hawkist
//
//  Created by User on 26.09.15.
//  Copyright © 2015 TecSynt Solutions. All rights reserved.
//

#import "HWFollowInProfileColViewCell.h"
#import "Masonry/Masonry.h"
#import "StarRatingControl.h"
#import "HWFollowUser.h"
#import "AFNetworking.h"

@interface HWFollowInProfileColViewCell () <StarRatingDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (strong, nonatomic) NSString *userId;

@property (weak, nonatomic) IBOutlet StarRatingControl *starView;
@property (nonatomic, strong) HWFollowUser *user;


//@property (nonatomic, assign) BOOL isFollow;

@end


#define IS_FOLLOW @"1"



@implementation HWFollowInProfileColViewCell


- (void) setStarView:(StarRatingControl *)starView
{
    _starView = starView;
    _starView.delegate = self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    return self;
}

- (instancetype) awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    
    return self;
}


- (IBAction)followButtonAction:(UIButton *)sender {
    if (self.isFollow)
    {
        self.isFollow = NO;
        
    } else {
        
        self.isFollow = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(followUnfollowButton:follow: forUser:)])
    {
        [self.delegate followUnfollowButton:sender follow:self.isFollow forUser:self.user];
    }
}

#pragma mark StarDelegate

- (BOOL) enabledTouch
{
    return NO;
}

#pragma mark - get/set

- (void) setCellWithFollowUser:(HWFollowUser*) user
{
    
    
    
    if ([user.follow isEqualToString:IS_FOLLOW])
    {
        self.isFollow = YES;
        
        [UIView performWithoutAnimation:^{
            
            [self.followButton setTitle:@" UNFOLLOW "  forState:UIControlStateNormal];
            self.followButton.backgroundColor = [UIColor colorWithRed:97./255. green:97./255. blue:97./255. alpha:1];
            [self.followButton layoutIfNeeded];
        }];
        
    } else {
        
        self.isFollow = NO;
        
        [UIView performWithoutAnimation:^{
            
            [self.followButton setTitle:@"  FOLLOW  "  forState:UIControlStateNormal];
            self.followButton.backgroundColor = [UIColor colorWithRed:48./255. green:173./255. blue:148./255. alpha:1];
            [self.followButton layoutIfNeeded];
        }];
    }
    
    
    self.user = user;
    [self.avatarImageView setImageWithURL:[NSURL URLWithString: user.avatar] placeholderImage:[UIImage imageNamed:@"noPhoto"]];
    
    self.userNameLabel.text = user.username;
    self.ratingLabel.text = [NSString stringWithFormat:@"%@ (%@ reviews)",user.rating, user.review];
    self.starView.rating = [user.rating integerValue];
    self.userId = user.id;
    
    
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults]objectForKey:kUSER_ID];
    if([currentUserId isEqualToString:user.id])
    {
        self.followButton.alpha = 0.5;
    } else {
        
        self.followButton.alpha = 1;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(hideFollowUnfollowButtonForUserId:)])
    {
        self.followButton.enabled = (![self.delegate hideFollowUnfollowButtonForUserId:self.userId]);
    }
    
    
   
    
    
}



#pragma mark -
#pragma mark Action

- (IBAction)transitionToUserProfileAction:(UIButton *)sender
{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(transitionToUserProfileWithUserId:)])
    {
        [self.delegate transitionToUserProfileWithUserId:self.userId];
        
    }
    
}




@end
