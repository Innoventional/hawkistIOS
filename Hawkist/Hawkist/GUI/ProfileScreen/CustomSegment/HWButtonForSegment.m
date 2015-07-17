//
//  HWButtonForSegment.m
//  Hawkist
//
//  Created by User on 15.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWButtonForSegment.h"
#import "Masonry/Masonry.h"



@implementation HWButtonForSegment


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
                      [label setFont:[UIFont systemFontOfSize:21]];
                      label.textColor = [UIColor colorWithRed:106./255. green:106./255. blue:106./255. alpha:1];
                      label.text = @"222";
                      
                      
                      label;
                  }
                 );
    
    self.titleButton = (
                  {
                      UILabel *label = [[UILabel alloc]init];
                      [self addSubview:label];
                      [label setFont:[UIFont systemFontOfSize:12]];
                      label.textColor = [UIColor colorWithRed:170./255. green:173./255. blue:173./255. alpha:1];
                      
                      label.text = @"FOLLOWING";
                      
                      label;
                  }
                  );
    
    
    self.selectedImage = (
                     {
                         UIImageView * imV = [[UIImageView alloc]init];
                         [self addSubview:imV];
                         imV.image = [UIImage imageNamed:@"Profile_select"];
                         imV.hidden = YES;
                         
                         imV;
                     }
                    );
}


- (void) setupConstraint
{
    
    [self.count mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_centerY).offset(3);
        
    }];
    
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self).offset(-10);
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
