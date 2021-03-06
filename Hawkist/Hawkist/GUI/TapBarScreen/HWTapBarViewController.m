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
#import "AccountDetailViewController.h"
#import "ManageBankViewController.h"
#import "SettingsViewController.h"
#import "SupportScreenViewController.h"
#import "NotificationScreenViewController.h"

#import "HolidayModeViewController.h"
#import "HWLeaveFeedbackViewController.h"
#import "HWFeedBackViewController.h"
#import "HWMyBalanceViewController.h"
#import "PingManager.h"


#import "HWZendeskViewController.h"
#import "HWZendesk.h"


@interface HWTapBarViewController () <HWTapBarViewDelegate>

@property (nonatomic, strong) HWTapBarView* contentView;
@property (nonatomic, assign) NSInteger currentSelectedItem;

// view controllers
@property (nonatomic, strong) FeedScreenViewController* feedVC;
@property (nonatomic, strong) WantToSellViewController* sellVC;
@property (nonatomic, strong) SettingsViewController* settingVC;
@property (nonatomic, strong) SupportScreenViewController* supportVC;
@property (nonatomic, strong) NotificationScreenViewController* notificationVC;
@property (nonatomic,strong) ManageBankViewController* bankVC;

@property (nonatomic, assign) BOOL isSold;

@end

@implementation HWTapBarViewController

- (instancetype) initWithSold
{
    self = [self init];
    if (self)
    {
        self.isSold = YES;
    }
    return self;
}

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
    
    self.supportVC = [[SupportScreenViewController alloc]init];
    [self addChildViewController:self.supportVC];
    
    self.notificationVC = [[NotificationScreenViewController alloc]init];
    [self addChildViewController:self.notificationVC];
    
    self.currentSelectedItem = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadge) name:@"updateNotification" object:nil];
    
    [HWZendesk shared].navigationController = self.navigationController;
    
    if (self.isSold)
    {
        [self setSold];
    }
    
    
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];

       }




- (void) updateBadge{
    
    [self.contentView updateBadge:[AppEngine shared].countNewNotifications];
  //  [self.contentView updateBadge:@"5"];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[PingManager shared] stopUpdating];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.contentView.frame = self.view.frame;
    [self.contentView setNeedsLayout];
    [[PingManager shared] startUpdatingNotification];

}

- (void) viewDidAppear:(BOOL)animated
{
    self.isInternetConnectionAlertShowed = NO;
    
}

- (void) setTab:(NSInteger)number
{
    [self itemAtIndexSelected:number];
    [((HWTapBarView*)self.contentView) selectButton:number];
}

- (void) setSold
{
    [AppEngine shared].isShowSold = YES;
    [self itemAtIndexSelected:2];
    [((HWTapBarView*)self.contentView) selectButton:2];
    
    
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
             [self.contentView addContentView: self.notificationVC.view];
                [self.contentView updateBadge:@"0"];
            break;
        }
        case 4:
        {
//            HWZendeskViewController *vc = [[HWZendeskViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
          
 
            [self.contentView addContentView: self.supportVC.view];
                
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
