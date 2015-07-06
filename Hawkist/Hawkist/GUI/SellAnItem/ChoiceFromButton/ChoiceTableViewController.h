//
//  ChoiceTableViewController.h
//  Hawkist
//
//  Created by Anton on 06.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationVIew.h"
#import "HWBaseViewController.h"

@protocol ChoiceTableViewDelegata <NSObject>

- (void) SelectedItemFrom:(id)sender WithName:(NSString*)name;

@end

@interface ChoiceTableViewController : HWBaseViewController <UITableViewDataSource,UITableViewDelegate,NavigationViewDelegate>

@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;

@property (nonatomic) NSMutableArray* items;

@property (nonatomic,weak) id <ChoiceTableViewDelegata> delegate;
@property (nonatomic,weak) id sender;

@end
