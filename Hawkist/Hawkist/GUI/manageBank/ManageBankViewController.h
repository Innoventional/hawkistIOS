//
//  ManageBankViewController.h
//  Hawkist
//
//  Created by Anton on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWBaseViewController.h"
#import "NavigationVIew.h"
#import "cardView.h"

@interface ManageBankViewController : HWBaseViewController <NavigationViewDelegate,cardViewDelegate>

@property (weak, nonatomic) IBOutlet NavigationVIew *navigation;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@end
