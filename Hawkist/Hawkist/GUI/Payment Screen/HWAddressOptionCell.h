//
//  HWAddressOptionCell.h
//  Hawkist
//
//  Created by User on 02.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWPaymentBaseCell.h"
#import "HWAddress.h"

@interface HWAddressOptionCell : HWPaymentBaseCell
 
-(void) setCellWithAddress:(HWAddress*) address;

@end
