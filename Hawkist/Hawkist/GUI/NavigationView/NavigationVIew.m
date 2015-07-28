//
//  NavigationVIew.m
//  Hawkist
//
//  Created by Anton on 01.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "NavigationVIew.h"
@interface NavigationVIew()

@end



@implementation NavigationVIew

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView* subView = [[[NSBundle mainBundle]loadNibNamed:@"Navigation" owner:self options:nil]firstObject];
        
        subView.frame = self.bounds;
        
        [self addSubview:subView];
        
        UIEdgeInsets inset = self.leftButtonOutlet.imageEdgeInsets;
        
        inset.top+=2;
        
        self.leftButtonOutlet.imageEdgeInsets = inset;
    }
    return self;
}
- (IBAction)leftButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(leftButtonClick)])
        [_delegate leftButtonClick];
    
}
- (IBAction)rightButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(rightButtonClick)])
        [_delegate rightButtonClick];
}
@end
