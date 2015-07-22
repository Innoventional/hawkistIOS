//
//  HWCommentCell.m
//  Hawkist
//
//  Created by User on 22.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWCommentCell.h"
#import "HWComment.h"
#import "NSDate+NVTimeAgo.h"

@interface HWCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *textCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *user_username;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSString *commentId;


@end

@implementation HWCommentCell

- (void)awakeFromNib {
    // Initialization code
}


- (void) setCellWithComment:(HWComment*)comment
{
    
    self.userId = comment.user_id;
    self.itemId = comment.listing_id;
    self.commentId = comment.id;
    self.user_username = comment.user_username;
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString: comment.user_avatar] placeholderImage:[UIImage imageNamed:@"noPhoto"]];
    self.textCommentLabel.text = [NSString stringWithFormat:@"%@ %@", comment.user_username, comment.text];
  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm"];
    self.time = [dateFormatter dateFromString:comment.created_at];
    
     NSDateFormatter *dateFormatterForComment = [[NSDateFormatter alloc] init];
     [dateFormatterForComment setDateFormat:@"MMMM dd hh':'mm a"];
    
    self.timeLabel.text =  [dateFormatterForComment stringFromDate:self.time];
    
    NSRange rangeName = [self.textCommentLabel.text rangeOfString:self.user_username];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:self.textCommentLabel.text];
    
    [string beginEditing];
    
    UIColor *color = [UIColor colorWithRed:94./255. green:94./255. blue:94./255. alpha:1];
    UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : color, NSFontAttributeName : font  };
    
    [string addAttributes:attrs
                    range:rangeName];
    
    [string endEditing];
    
    [self.textCommentLabel setAttributedText:string];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)tapOnAvatarAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(transitionToProfileWithUserId:)])
    {
        [self.delegate transitionToProfileWithUserId:self.userId];
    }
    
    
}

@end
