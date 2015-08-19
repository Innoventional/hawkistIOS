//
//  HWTapBarViewController.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 7/9/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWTapBarViewController.h"
#import "HWTapBarView.h"
#import "FeedScreenViewController.h"
#import "WantToSellViewController.h"
#import "HWMyAccountViewController.h"

#import "ManageBankViewController.h"
#import "SettingsViewController.h"



#import "HWLeaveFeedbackViewController.h"
#import "HWFeedBackViewController.h"
#import "HWMyBalanceViewController.h"



@interface HWTapBarViewController () <HWTapBarViewDelegate>

@property (nonatomic, strong) HWTapBarView* contentView;
@property (nonatomic, assign) NSInteger currentSelectedItem;

// view controllers
@property (nonatomic, strong) FeedScreenViewController* feedVC;
@property (nonatomic, strong) WantToSellViewController* sellVC;
@property (nonatomic, strong) SettingsViewController* settingVC;


@property (nonatomic,strong) ManageBankViewController* bankVC;
@end

@implementation HWTapBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView = [[HWTapBarView alloc] initWithFrame: self.view.bounds];
    self.contentView.delegate = self;
    [self.view addSubview: self.contentView];
    [self.contentView markSelected: 1];
    
    self.feedVC = [[FeedScreenViewController alloc] init];
    [self addChildViewController: self.feedVC];
    self.sellVC = [[WantToSellViewController alloc] init];
    [self addChildViewController: self.sellVC];
    
    [self.contentView addContentView: self.feedVC.view];
   
    self.settingVC = [[SettingsViewController alloc]init];
    [self addChildViewController:self.settingVC];
    
    self.currentSelectedItem = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.contentView.frame = self.view.frame;
    [self.contentView setNeedsLayout];
}

- (void) viewDidAppear:(BOOL)animated
{
    self.isInternetConnectionAlertShowed = NO;
    
}


#pragma mark -
#pragma mark HWTapBarViewDelegate

- (void) itemAtIndexSelected:(NSInteger)index
{
    if(self.currentSelectedItem == index)
        return;
    self.currentSelectedItem = index;
    switch (index) {
        case 1:
        {
            [self.contentView addContentView: self.feedVC.view];
            break;
        }
        case 2:
        {
            [self.contentView addContentView: self.sellVC.view];
            break;
        }
        case 3:
        {
            HWFeedBackViewController * vc = [[HWMyBalanceViewController alloc] init];
             [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 4:
        {
            HWLeaveFeedbackViewController *vc = [[HWLeaveFeedbackViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
            break;
        }
            
        case 5:
            
            [self.contentView addContentView: self.settingVC.view];
            break;
            
        default:
            break;
    }
}

@end
