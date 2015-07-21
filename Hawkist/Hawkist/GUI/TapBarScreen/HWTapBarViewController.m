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



#import "HWProfileViewController.h"


@interface HWTapBarViewController () <HWTapBarViewDelegate>

@property (nonatomic, strong) HWTapBarView* contentView;
@property (nonatomic, assign) NSInteger currentSelectedItem;

// view controllers
@property (nonatomic, strong) FeedScreenViewController* feedVC;
@property (nonatomic, strong) WantToSellViewController* sellVC;

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
            HWProfileViewController * sss = [[HWProfileViewController alloc] initWithUserID:@"79"];
            [self.navigationController pushViewController:sss animated:YES];
            
            break;
        }
        case 4:
        {
          
            
            break;
        }
        default:
            break;
    }
}

@end
