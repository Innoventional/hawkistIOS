//
//  CustomizationViewController.h
//  Customization Screen
//
//  Created by Evgen Bootcov on 18.06.15.
//  Copyright (c) 2015 Evgen Bootcov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomizationViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewTop;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *viewScroll;


@property (strong, nonatomic) IBOutlet UIView *viewBottom;

@property (strong, nonatomic) IBOutlet UILabel *title1;
@property (strong, nonatomic) IBOutlet UILabel *textup;
@property (strong, nonatomic) IBOutlet UILabel *textdown;
@property (strong, nonatomic) NSArray *backImage;
- (IBAction)nextButton:(id)sender;

@property (strong, nonatomic) NSArray *name;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic , strong) UILabel *lable;

@end
