//
//  PushNotificationTableViewCell.h
//  Hawkist
//
//  Created by Anton on 02.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationSettingsModel.h"

@protocol PushNotificationTableViewCellDelegate <NSObject>

- (void) changed:(id)sender;

@end

@interface PushNotificationTableViewCell : UITableViewCell

@property (nonatomic, strong) id<PushNotificationTableViewCellDelegate> delegate;

- (void) setValue:(BOOL)value;
- (BOOL) getValue;

- (int) getType;

- (void) setCellWithMenuDataModel:(NotificationSettingsModel*)dataModel;

@end



