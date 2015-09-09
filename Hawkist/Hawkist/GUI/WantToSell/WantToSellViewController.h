//
//  WantToSellViewController.h
//  Hawkist
//
//  Created by Anton on 30.06.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWBaseViewController.h"
#import "MyItemsViewController.h"

@interface WantToSellViewController : HWBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)btnWantToSell:(id)sender;

@end
