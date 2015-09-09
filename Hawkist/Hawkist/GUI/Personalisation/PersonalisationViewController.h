//
//  PersonalisationViewController.h
//  Hawkist
//
//  Created by Anton on 06.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationVIew.h"
#import "HWBaseViewController.h"


@interface PersonalisationViewController : HWBaseViewController <NavigationViewDelegate>
@property (weak, nonatomic) IBOutlet NavigationVIew *navigation;
- (instancetype)initWithTags:(NSMutableArray*)tags;
@end
