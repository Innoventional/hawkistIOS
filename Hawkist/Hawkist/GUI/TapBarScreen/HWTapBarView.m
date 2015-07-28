//
//  HWTapBarView.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 7/9/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWTapBarView.h"
#import "UIColor+Extensions.h"

@interface HWTapBarView ()

@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) NSArray* arrayWithNormalIcons;
@property (nonatomic, strong) NSArray* arrayWithSelectedIcons;

@end

@implementation HWTapBarView

#pragma mark -
#pragma mark Lifecycle

- (instancetype) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if(self)
    {
        self.items = [NSMutableArray array];
        self.arrayWithNormalIcons = @[@"Feed_isearch", @"Feed_iitem", @"Feed_imes", @"Feed_iFQ", @"Feed_isettings"];
        self.arrayWithSelectedIcons = @[@"Feed_isearcha", @"Feed_iitema", @"Feed_imesa", @"Feed_iFQa", @"Feed_isettingsa"];
        [self createSubviews];
    }
    return self;
}

- (void) createSubviews
{
    self.backgroundColor = [UIColor color256RGBWithRed: 50 green: 54 blue: 62];
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview: self.contentView];
    
    for (NSInteger index = 1; index <= self.arrayWithNormalIcons.count; index++)
    {
        UIButton* button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor color256RGBWithRed: 50 green: 54 blue: 62];
        [button setImage: [UIImage imageNamed: [self.arrayWithNormalIcons objectAtIndex: index - 1]] forState: UIControlStateNormal];
        [button setImage: [UIImage imageNamed: [self.arrayWithSelectedIcons objectAtIndex: index - 1]] forState: UIControlStateSelected];
        [button addTarget: self action: @selector(itemSelected:) forControlEvents: UIControlEventTouchUpInside];
        button.tag = index;
        [self.items addObject: button];
        [self addSubview: button];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    for (NSInteger index = 0; index < self.items.count; index++) {
        CGFloat buttonWidth = self.width / self.items.count;
        UIButton* item = [self.items objectAtIndex: index];
        item.frame = CGRectMake(buttonWidth * index, 20.0f, buttonWidth, 50.0f);
    }
    self.contentView.frame = CGRectMake(0, 70.0f, self.width, self.height - 70.0f);
}
#pragma mark -
#pragma mark Public

- (void) addContentView: (UIView*) view
{
    [self.contentView removeFromSuperview];
    self.contentView = view;
    
    self.contentView.clipsToBounds = YES;
    [self addSubview: self.contentView];
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark Actions

- (void) itemSelected: (UIButton*) sender
{
    
    [self markSelected: sender.tag];
    if(self.delegate && [self.delegate respondsToSelector: @selector(itemAtIndexSelected:)])
    {
        [self.delegate itemAtIndexSelected: sender.tag];
    }
}

- (void) markSelected: (NSInteger) index
{
    for (UIButton* button in self.items) {
        if(button.tag == index)
        {
            button.backgroundColor = [UIColor color256RGBWithRed: 63 green: 184 blue: 165];
            [button setSelected: YES];
        }
        else
        {
            button.backgroundColor = [UIColor color256RGBWithRed: 50 green: 54 blue: 62];
            [button setSelected: NO];
        }
        
    }
}

@end
