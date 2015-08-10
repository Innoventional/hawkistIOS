//
//  HWOrderButton.m
//  Hawkist
//
//  Created by User on 10.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWOrderButton.h"
#import "Masonry/Masonry.h"

@implementation HWOrderButton


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


-(void) commonInit
{
    self.acceptImage = (
                        {
                            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
                            [self addSubview:iv];
                          
                            
                            iv;
                        }
                       );

    self.title = (
                  {
                      UILabel *lb = [UILabel new];
                      [self addSubview:lb];
                      lb.font = [UIFont fontWithName:@"OpenSans" size:11];
                      
                      lb;
                  }
                 );

}

-(void) setupConstraint
{
    
    [self.acceptImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
      
        make.height.valueOffset(@20);
        make.width.valueOffset(@20);
        
        
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).offset(3);
        
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self).offset(-5);
        make.centerX.equalTo(self.mas_centerX);
    }];

    
    
}



@end
