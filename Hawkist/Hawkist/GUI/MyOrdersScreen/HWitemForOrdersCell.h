//
//  HWitemForOrdersCell.h
//  Hawkist
//
//  Created by User on 06.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "myItemCell.h"
#import "HWOrderItem.h"

@protocol HWitemForOrdersCellDelegate;

@interface HWitemForOrdersCell : myItemCell



@property (nonatomic, weak) id <HWitemForOrdersCellDelegate> orderCellDelegate;


- (void) setCellWithOrderItem:(HWOrderItem*) orderItems;

@end


@protocol HWitemForOrdersCellDelegate <MyItemCellDelegate>

- (void) receivedAction:(UIButton*)sender withItem:(HWOrderItem*)item;
- (void) hasIssueAction:(UIButton*)sender withItem:(HWOrderItem*)item;
- (void) feedbackAction:(UIButton*)sender witgUserID:(NSString*)userId withOrderId:(NSString*)orderId;

@end