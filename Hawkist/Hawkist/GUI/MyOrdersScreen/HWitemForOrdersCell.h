//
//  HWitemForOrdersCell.h
//  Hawkist
//
//  Created by User on 06.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "myItemCell.h"
#import "HWItem.h"

@protocol HWitemForOrdersCellDelegate;

@interface HWitemForOrdersCell : myItemCell

@property (nonatomic, weak) id <HWitemForOrdersCellDelegate> orderCellDelegate;

@end


@protocol HWitemForOrdersCellDelegate <MyItemCellDelegate>

- (void) receivedAction:(UIButton*)sender withItem:(HWItem*)item;
- (void) hasIssueAction:(UIButton*)sender withItem:(HWItem*)item;

@end