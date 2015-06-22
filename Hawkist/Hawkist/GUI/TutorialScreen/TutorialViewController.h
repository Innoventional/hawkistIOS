//
//  TutorialViewController.h
//  Tutorial
//
//  Created by Evgen Bootcov on 11.06.15.
//  Copyright (c) 2015 Evgen Bootcov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *viewScroll;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *View2;

- (IBAction)getStart:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *tutor;
@property (strong, nonatomic) IBOutlet UILabel *textik;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *text;




@end
