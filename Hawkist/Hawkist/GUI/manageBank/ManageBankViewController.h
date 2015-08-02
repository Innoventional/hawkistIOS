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

@interface ManageBankViewController : HWBaseViewController <NavigationViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NavigationVIew *navigation;

@end
