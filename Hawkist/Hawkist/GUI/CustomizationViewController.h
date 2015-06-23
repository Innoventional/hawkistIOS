//
//  CustomizationViewController.h
//  Customization Screen
//
//  Created by Evgen Bootcov on 18.06.15.
//  Copyright (c) 2015 Evgen Bootcov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWBaseViewController.h"

@interface CustomizationViewController : HWBaseViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewTop;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *viewScroll;


@property (strong, nonatomic) IBOutlet UIView *viewBottom;


@property (strong, nonatomic) NSArray *backImage;
- (IBAction)nextButton:(id)sender;

@end
