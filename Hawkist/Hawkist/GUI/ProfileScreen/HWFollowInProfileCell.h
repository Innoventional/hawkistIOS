//
//  HWFollowInProfileCell.h
//  Hawkist
//
//  Created by User on 16.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWFollowUser;

@protocol HWFollowInProfileCellDelegate;


@interface HWFollowInProfileCell : UITableViewCell

@property (nonatomic, weak) id <HWFollowInProfileCellDelegate> delegate;

- (void) setCellWithFollowUser:(HWFollowUser*) user;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (nonatomic, assign) BOOL isFollow;

@end


@protocol HWFollowInProfileCellDelegate <NSObject>

@optional
- (void) transitionToUserProfileWithUserId:(NSString*)userId;
- (void) followUnfollowButton:(UIButton*)button follow:(BOOL)isFollow forUserId:(NSString*)userId;

- (BOOL) hideFollowUnfollowButtonForUserId:(NSString*)userId;

@end