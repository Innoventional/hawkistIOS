//
//  HWSingOutCell.h
//  Hawkist
//
//  Created by User on 01.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWSingOutCellDelegate;

@interface HWSingOutCell : UITableViewCell

@property (nonatomic, weak) id <HWSingOutCellDelegate> delegate;
@property (nonatomic, assign) BOOL checkNotifySeller;
@property (nonatomic, assign) BOOL checkLetMembers;

@end


@protocol HWSingOutCellDelegate <NSObject>

- (void) pressNotifySellerButton:(UIButton*)sender;
- (void) pressLetMemberButton:(UIButton*)sender;
- (void) pressSingOutButton:(UIButton*)sender;

@end