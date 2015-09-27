//
//  HWFollowInProfileColViewCell.h
//  Hawkist
//
//  Created by User on 26.09.15.
//  Copyright © 2015 TecSynt Solutions. All rights reserved.
//




#import <UIKit/UIKit.h>
@class HWFollowUser;

@protocol HWFollowInProfileColViewCellDelegate;


@interface HWFollowInProfileColViewCell : UICollectionViewCell

@property (nonatomic, weak) id <HWFollowInProfileColViewCellDelegate> delegate;

- (void) setCellWithFollowUser:(HWFollowUser*) user;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (nonatomic, assign) BOOL isFollow;

@end


@protocol HWFollowInProfileColViewCellDelegate <NSObject>

@optional
- (void) transitionToUserProfileWithUserId:(NSString*)userId;
- (void) followUnfollowButton:(UIButton*)button follow:(BOOL)isFollow forUser:(HWFollowUser *)useк;

- (BOOL) hideFollowUnfollowButtonForUserId:(NSString*)userId;

@end