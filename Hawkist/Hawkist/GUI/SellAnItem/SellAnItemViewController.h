//
//  SellAnItemViewController.h
//  Hawkist
//
//  Created by Anton on 01.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationVIew.h"
#import "CustomButton.h"

@interface SellAnItemViewController : UIViewController <NavigationViewDelegate>
@property (weak, nonatomic) IBOutlet NavigationVIew *nav;

@property (weak, nonatomic) IBOutlet CustomButton *platform;
@property (weak, nonatomic) IBOutlet CustomButton *category;
@property (weak, nonatomic) IBOutlet CustomButton *condition;
@property (weak, nonatomic) IBOutlet CustomButton *color;

@end
