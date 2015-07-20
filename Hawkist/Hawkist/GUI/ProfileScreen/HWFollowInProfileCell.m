//
//  HWFollowInProfileCell.m
//  Hawkist
//
//  Created by User on 16.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWFollowInProfileCell.h"
#import "Masonry/Masonry.h"
#import "StarRatingControl.h"
#import "HWFollowUser.h"
#import "AFNetworking.h"

@interface HWFollowInProfileCell () <StarRatingDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (strong, nonatomic) NSString *userId;

@property (weak, nonatomic) IBOutlet StarRatingControl *starView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (nonatomic, assign) BOOL isFollow;

@end

@implementation HWFollowInProfileCell

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
    if ([sender.titleLabel.text isEqualToString:@"FOLLOW"])
    {
        [self.followButton setTitle:@"UNFOLLOW"  forState:UIControlStateNormal];
    } else {
        
         [self.followButton setTitle:@"FOLLOW"  forState:UIControlStateNormal];
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
    [self.avatarImageView setImageWithURL:[NSURL URLWithString: user.avatar] placeholderImage:[UIImage imageNamed:@"noPhoto"]];
    
     self.userNameLabel.text = user.username;
     self.ratingLabel.text = [NSString stringWithFormat:@"%@ (%@ reviews)",user.rating, user.review];
     self.starView.rating = [user.rating integerValue];
     self.userId = user.id;
    
    if ([user.follow isEqualToString:@"1"])
    {
        self.isFollow = YES;
        [self.followButton setTitle:@"FOLLOW"  forState:UIControlStateNormal];
        
    } else {
        
        self.isFollow = NO;
        [self.followButton setTitle:@"UNFOLLOW"  forState:UIControlStateNormal];
    }
    
    
}

@end
