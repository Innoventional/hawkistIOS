//
//  HWProfileHeaderVeiw.h
//  Hawkist
//
//  Created by User on 26.09.15.
//  Copyright © 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWUser;
@class HWButtonForSegment;
@protocol HWProfileHeaderViewDelegate;


@interface HWProfileHeaderVeiw : UICollectionReusableView

@property (nonatomic, weak) id<HWProfileHeaderViewDelegate>delegate;
@property (nonatomic, assign) BOOL hideFollowButton;

+ (CGFloat)heightHeaderView;

- (void)updateWithUser:(HWUser *)user;
- (void)updateWithArrayItems:(NSArray *)items
               withFollowing:(NSArray *)following
               withFollowers:(NSArray *)followers
                withWishlist:(NSArray *)wishlist;
- (void)updateSelectedButtonIndex:(NSInteger) selectedButIndex;


@end


@protocol HWProfileHeaderViewDelegate <NSObject>

- (void)itemsAction:(HWButtonForSegment *)sender;
- (void)followingAction:(HWButtonForSegment *)sender;
- (void)followersAction:(HWButtonForSegment *)sender;
- (void)wishlistAction:(HWButtonForSegment *)sender;
- (void)followUnfollowAction:(HWButtonForSegment *)sender withIsFollow:(BOOL)isFollow;
- (void)aboutMeAction:(HWButtonForSegment *)sender;
- (void)feedbackButton:(UIButton *)sender;


@end




