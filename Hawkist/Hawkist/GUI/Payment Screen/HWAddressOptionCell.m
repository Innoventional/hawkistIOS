//
//  HWAddressOptionCell.m
//  Hawkist
//
//  Created by User on 02.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWAddressOptionCell.h"

@interface HWAddressOptionCell ()
@property (weak, nonatomic) IBOutlet UILabel *address_line1;
@property (weak, nonatomic) IBOutlet UILabel *adress_line2;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCodeLable;
@property (weak, nonatomic) IBOutlet UIImageView *activeImage;

@end

@implementation HWAddressOptionCell

//- (instancetype) awakeAfterUsingCoder:(NSCoder *)aDecoder
//{
//    self = [super awakeAfterUsingCoder:aDecoder];
//    if (self)
//    {
//        self.layer.cornerRadius = 6;
//        self.layer.borderColor = [UIColor colorWithRed:55./255. green:185./255. blue:165./255. alpha:1].CGColor;
//        self.activeImage.image = [UIImage imageNamed:@"acdet_checkempty"];
//    }
//    return self;
//}


-(void) setCellWithAddress:(id) address
{
    
}

//- (void)setIsSelected:(BOOL)isSelected
//{
//    _isSelected = isSelected;
//    
//    if(isSelected)
//    {
//        
//        self.layer.borderWidth = 3;
//        self.activeImage.image = [UIImage imageNamed:@"acdet_check"];
//    }
//    else
//    {
//        self.activeImage.image = [UIImage imageNamed:@"acdet_checkempty"];
//        self.layer.borderWidth = 0;
//    }
//}


@end
