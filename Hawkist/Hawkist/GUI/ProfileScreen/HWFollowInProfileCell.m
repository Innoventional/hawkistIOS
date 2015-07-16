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

@interface HWFollowInProfileCell () <StarRatingDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;


@property (weak, nonatomic) IBOutlet StarRatingControl *starView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;



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
}

#pragma mark Sta

- (BOOL) enabledTouch
{
    return NO;
}


@end
