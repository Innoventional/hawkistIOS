//
//  HWFeadbackCell.m
//  Hawkist
//
//  Created by User on 18.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWFeadbackCell.h"
#import "HWFeedback.h"
#import "NSDate+NVTimeAgo.h"

@interface HWFeadbackCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (nonatomic, strong) NSString *userId;



@end

@implementation HWFeadbackCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setCellWithFeedback:(HWFeedback*) feedback {
    
    self.userId = feedback.user_id;
    NSString *str = [NSString stringWithFormat:@"%@ %@", feedback.username, feedback.text];
    NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    
    
    NSRange rangeName = [str rangeOfString:feedback.username];
    
    [atrStr beginEditing];
    
    UIFont *allFont= [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    UIColor *allColor = [UIColor colorWithRed:94./255. green:94./255. blue:94./255. alpha:1];
    NSDictionary *allAttrib = @{ NSForegroundColorAttributeName : allColor, NSFontAttributeName : allFont  };
 
     [atrStr addAttributes:allAttrib
                         range:rangeName];
    [atrStr endEditing];

    self.messageText.attributedText = atrStr;
    
    
    [self.avatar setImageWithURL:[NSURL URLWithString: feedback.avatar] placeholderImage:[UIImage imageNamed:@"noPhoto"]];
    NSDate *time = [NSDate dateFromServerFormatString:feedback.timeCreate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd hh':'mm a"];
    self.timeLabel.text =  [dateFormatter stringFromDate:time];
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


- (IBAction) transitionAction:(id) sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(transitionToProfileWithUserId:)]) {
        
        [self.delegate transitionToProfileWithUserId:self.userId];
    }
}

@end
