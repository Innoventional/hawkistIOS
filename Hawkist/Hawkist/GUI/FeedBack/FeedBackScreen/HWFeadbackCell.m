//
//  HWFeadbackCell.m
//  Hawkist
//
//  Created by User on 18.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWFeadbackCell.h"

@interface HWFeadbackCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;



@end

@implementation HWFeadbackCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





+ (CGFloat) heightWith:(NSString*)text
{
    UILabel *label = [[UILabel alloc] init];
     
    label.text  = text;
    
    label.font =  [UIFont fontWithName:@"OpenSans" size:15.f];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 74;
    
    CGSize size = [label sizeThatFits:CGSizeMake(width, FLT_MAX)];
    
    
    return size.height + 36;
    
    
}



@end
