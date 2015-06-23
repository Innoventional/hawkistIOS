//
//  TutorialViewController.m
//  Tutorial
//
//  Created by Evgen Bootcov on 11.06.15.
//  Copyright (c) 2015 Evgen Bootcov. All rights reserved.
//

#import "TutorialViewController.h"


@interface TutorialViewController ()

@end

@implementation TutorialViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
   
    self.images = @[@"1page",@"2page",@"3page",@"4page",@"5page"];
    self.titles = @[@"The Marketplace", @"It's your Choice", @"All the Loot", @"Get the Fact",@"Buy with Confidencce"];
    self.text = @[@"Hawkist connects real people buying and selling video games or consoles.",@"Customise which items appear in your product feed by indicating preferences.",@"Detailed item descriptions and seller reviews. Follow, favourite and negotiate.",@"FAQs and support topics at your fingertips. Got a question? Message us.", @"Pay securly. Money only changes hands when both parties are happy"];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.View2.frame];
    [self.scrollView setDelegate:self];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    //[self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    self.scrollView.backgroundColor = [UIColor clearColor];
//    self.scrollView.frame =  CGRectMake(0,0 , self.view.frame.size.width , self.view.frame.size.height - 170);
//    CGSize scrollViewSize = self.scrollView.frame.size;
//    
//    CGSize slideSize = CGSizeMake(self.scrollView.frame.size.width - 100, self.scrollView.frame.size.height);
//    for (NSInteger i = 0; i < [self.images count]; i++)
//    {
//        CGRect slideRect = CGRectMake((self.scrollView.frame.size.width - slideSize.width)/2 + slideSize.width * i, 0, slideSize.width, scrollViewSize.height);
//        
//        UIView *slide = [[UIView alloc] initWithFrame:slideRect];
//        [slide setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, slideRect.size.width, self.scrollView.frame.size.height)];
//        imageView.backgroundColor = [UIColor clearColor];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [imageView setImage:[UIImage imageNamed:[self.images objectAtIndex:i]]];
//        
//        
//        [slide addSubview:imageView];
//        _tutor.textColor = [UIColor colorWithRed:(56/255.0) green:(69/255.0) blue:(79/255.0) alpha:1];
//        _tutor.text = [_titles objectAtIndex:0];
//        _textik.textColor = [UIColor colorWithRed:(70/255.0) green:(96/255.0) blue:(113/255.0) alpha:1];
//        _textik.text = [_text objectAtIndex:0];
//        
//        [self.scrollView addSubview:slide];
    
        
        
//    }
//   
//    UIPageControl *tempPageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollViewSize.height + 100, scrollViewSize.width, 20)];
//
//    tempPageControll.pageIndicatorTintColor = [UIColor colorWithRed:0.235f green: 0.720f blue:0.645f alpha:0.1f];
//    tempPageControll.currentPageIndicatorTintColor = [UIColor colorWithRed:(55/255.0) green:(185/255.0) blue:(165/255.0) alpha:1];
//    [self setPageControl:tempPageControll];
//    
//    [self.pageControl setNumberOfPages:[self.images count]];
//    [self.scrollView setContentSize:CGSizeMake(slideSize.width * [self.images count] + (self.scrollView.frame.size.width - slideSize.width), scrollViewSize.height)];
//    
//    
//    [self.View2 addSubview:self.scrollView];
//    
//    [self.View2 addSubview:self.pageControl];
}

- (void) viewDidAppear: (BOOL) animated
{

    [super viewDidAppear: animated];
    
    
    [self.scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    self.scrollView.frame =  self.viewScroll.bounds;
    
    CGSize scrollViewSize = self.scrollView.frame.size;
    
    CGSize slideSize = CGSizeMake(self.scrollView.frame.size.width - 100, self.scrollView.frame.size.height);
    for (NSInteger i = 0; i < [self.images count]; i++)
    {
        CGRect slideRect = CGRectMake((self.scrollView.frame.size.width - slideSize.width)/2 + slideSize.width * i, 0, slideSize.width, scrollViewSize.height);
        
        UIView *slide = [[UIView alloc] initWithFrame:slideRect];
        [slide setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, slideRect.size.width, self.scrollView.frame.size.height)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:[UIImage imageNamed:[self.images objectAtIndex:i]]];
        
        
        [slide addSubview:imageView];
        _tutor.textColor = [UIColor colorWithRed:(56/255.0) green:(69/255.0) blue:(79/255.0) alpha:1];
        _tutor.text = [_titles objectAtIndex:0];
        _textik.textColor = [UIColor colorWithRed:(70/255.0) green:(96/255.0) blue:(113/255.0) alpha:1];
        _textik.text = [_text objectAtIndex:0];
        
        [self.scrollView addSubview:slide];
    }
    
    
  self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.235f green: 0.720f blue:0.645f alpha:0.1f];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(55/255.0) green:(185/255.0) blue:(165/255.0) alpha:1];
    [self setPageControl:self.pageControl];
    
    [self.pageControl setNumberOfPages:[self.images count]];
    [self.scrollView setContentSize:CGSizeMake(slideSize.width * [self.images count] + (self.scrollView.frame.size.width - slideSize.width), scrollViewSize.height)];
    
    
    [self.View2 addSubview:self.scrollView];
    
    

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width - 100;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self.pageControl setCurrentPage:page];
    
    _tutor.text = [_titles objectAtIndex:page];
    _textik.text = [_text objectAtIndex:page];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat kMaxIndex = 4;
    CGFloat targetX = scrollView.contentOffset.x + velocity.x * 60.0;
    CGFloat targetIndex = round(targetX / (self.scrollView.frame.size.width - 100));
    if (targetIndex < 0)
        targetIndex = 0;
    if (targetIndex > kMaxIndex)
        targetIndex = kMaxIndex;
    targetContentOffset->x = targetIndex * (self.scrollView.frame.size.width - 100);
}


- (IBAction)getStart:(id)sender {
    
}
@end