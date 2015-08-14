//
//  HWPaymentBaseCell.h
//  Hawkist
//
//  Created by User on 13.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWPaymentBaseCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIImageView *activeImage;

@end
