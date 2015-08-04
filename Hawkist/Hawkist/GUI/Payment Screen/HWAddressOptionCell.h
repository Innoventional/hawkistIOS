//
//  HWAddressOptionCell.h
//  Hawkist
//
//  Created by User on 02.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWAddressOptionCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isSelected;

-(void) setCellWithAddress:(id) address;

@end
