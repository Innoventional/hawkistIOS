//
//  HWPaymentOptionCell.h
//  Hawkist
//
//  Created by User on 02.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWCard.h"
#import "HWPaymentBaseCell.h"

@interface HWPaymentOptionCell : HWPaymentBaseCell

//@property (nonatomic, assign) BOOL isSelected;

- (void) setCellWithCard:(HWCard*)card;

@end
