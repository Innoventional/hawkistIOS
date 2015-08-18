//
//  HWFedbackSegmentButton.m
//  Hawkist
//
//  Created by User on 18.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWFedbackSegmentButton.h"
#import "Masonry/Masonry.h"

@implementation HWFedbackSegmentButton


-(instancetype) awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    
    if(self)
    {
        
        [self commonInit];
        [self setupConstraint];
    }
    [self setTitle:@"" forState:UIControlStateNormal];
    
    
    return self;
}



- (void) commonInit
{
    
    
    self.count = (
                  {
                      UILabel *label = [[UILabel alloc]init];
                      [self addSubview:label];
                      [label setFont:[UIFont systemFontOfSize:22]];
                      label.textColor = [UIColor colorWithRed:106./255. green:106./255. blue:106./255. alpha:1];
                      label.text = @"0";
                      
                      
                      label;
                  }
                  );
    
    self.titleButton = (
                        {
                            UILabel *label = [[UILabel alloc]init];
                            [self addSubview:label];
                            [label setFont:[UIFont fontWithName:@"OpenSans" size:15.f]];
                            label.textColor = [UIColor colorWithRed:170./255. green:173./255. blue:173./255. alpha:1];
                            
                            label.text = @"list";
                            
                            label;
                        }
                        );
    
    
    self.selectedImage = (
                          {
                              UIImageView * imV = [[UIImageView alloc]init];
                              [self addSubview:imV];
                              
                              [imV bringSubviewToFront:self];
                              
                              imV;
                          }
                          );
}


- (void) setupConstraint
{
    
    [self.count mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_centerY).offset(2);
        
    }];
    
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self).offset(-12);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.selectedImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.valueOffset(@5);
        
    }];
    
    
}



@end
