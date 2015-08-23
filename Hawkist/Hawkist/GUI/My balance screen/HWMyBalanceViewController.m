//
//  HWMyBalanceViewController.m
//  Hawkist
//
//  Created by User on 19.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWMyBalanceViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface HWMyBalanceViewController ()

@property (nonatomic, weak) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;


@end

@implementation HWMyBalanceViewController


#pragma mark - UIViewController


- (instancetype)init
{
    self = [super initWithNibName: @"HWMyBalanceView" bundle: nil];
    if(self)
    {
       
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.z.constant = 2000;
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    CGSize s = self.contentView.bounds.size;
    
//    s.width = 375;
//    self.contentView.bounds = CGRectMake(0, 0, s.width, s.height);
//    [self.scrollView setContentSize:s];
//    //[self.scrollView layoutIfNeeded];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

@end
