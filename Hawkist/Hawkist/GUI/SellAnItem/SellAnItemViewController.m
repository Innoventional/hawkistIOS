//
//  SellAnItemViewController.m
//  Hawkist
//
//  Created by Anton on 01.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "SellAnItemViewController.h"

@interface SellAnItemViewController ()

@end

@implementation SellAnItemViewController 

- (instancetype) init
{
    if (self = [super init])
    {
        UIView* v = [[[NSBundle mainBundle]loadNibNamed:@"SellAnItem" owner:self options:nil]firstObject];
        
        v.frame = self.view.frame;
        
        [self.view addSubview:v];
        
        _nav.delegate = self;
        
        _category.Title.text = @"CATEGORY";
        _category.Text.text = @"Games";
       
        _condition.Title.text = @"CONDITION";
        _condition.Text.text = @"Very Good - Brand New";
        
        _color.Title.text = @"COLOR";
                _color.Text.text = @"Blue/White/Red";
        
    }
    return self;
}

- (void) leftButtonClick
{
    NSLog(@"LeftButton");
}


- (void) rightButtonClick
{
    NSLog(@"RightButton");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
