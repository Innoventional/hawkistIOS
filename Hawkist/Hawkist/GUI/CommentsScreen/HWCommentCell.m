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
#import "TextViewWithDetectedWord.h"
#import "HWMention.h"


@interface HWCommentCell () <TextViewWithDetectedWordDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet TextViewWithDetectedWord *textView;


@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *user_username;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSArray *mentionsArray;

 
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTextView;
 

@end

@implementation HWCommentCell

- (void)awakeFromNib {
    // Initialization code
}


- (void) setCellWithComment:(HWComment*)comment
{
    self.textView.delegateForDetectedWord = self;
    
    self.offerId = comment.offer_id;
    self.mentionsArray = comment.mentions;
    self.userId = comment.user_id;
    self.itemId = comment.listing_id;
    self.commentId = comment.id;
    self.user_username = comment.user_username;
    self.time = [NSDate dateFromServerFormatString:comment.created_at];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd hh':'mm a"];
    self.timeLabel.text =  [dateFormatter stringFromDate:self.time];
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString: comment.user_avatar] placeholderImage:[UIImage imageNamed:@"noPhoto"]];
    
    [self setupColorTextWithComment:comment];
    
    
      [self.textView layoutIfNeeded];
    
    CGSize size = [_textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, FLT_MAX)];
    [_textView sizeToFit];
    NSLog( @"%f", self.textView.contentSize.height);
    
  
    NSLog( @"%f", self.textView.contentSize.height);
    
    self.textView.bounds = CGRectMake(0, 0, size.width, size.height);
 
}

- (void) setupColorTextWithComment:(HWComment*) comment
{
    
    self.textView.text = [NSString stringWithFormat:@"%@ %@", comment.user_username, comment.text];
   
    
    NSRange rangeName = [self.textView.text rangeOfString:self.user_username];
    NSMutableAttributedString *atrbString = [[NSMutableAttributedString alloc]initWithString:self.textView.text];
    NSRange rangeName1 = [self.textView.text rangeOfString:self.textView.text];
    
    [atrbString beginEditing];
    
    UIFont *allFont= [UIFont fontWithName:@"OpenSans" size:15];
    UIColor *allColor = [UIColor colorWithRed:167./255. green:167./255. blue:167./255. alpha:1];
    NSDictionary *allAttrib = @{ NSForegroundColorAttributeName : allColor, NSFontAttributeName : allFont  };
    [atrbString addAttributes:allAttrib
                        range:rangeName1];
    
    UIColor *color = [UIColor colorWithRed:94./255. green:94./255. blue:94./255. alpha:1];
    UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : color, NSFontAttributeName : font  };
    [atrbString addAttributes:attrs
                        range:rangeName];
    
    [atrbString endEditing];
    
    [self.textView setAttributedText:atrbString];
    
    NSRange range = [self.textView.text rangeOfString:@"£"];
    
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSArray *conteinsOfferPriceArray = [self.textView.text componentsSeparatedByCharactersInSet:charSet];
    
    for (NSString *str in conteinsOfferPriceArray)
    {
        if([str isEqualToString:@""]) continue;
        
        if([[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"£"])
        {
            range = [self.textView.text rangeOfString:str];
            break;
        }
    }
    
    if(range.length == 0)
    {
        
    } else {
   
        atrbString = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
        
        [atrbString beginEditing];
        [atrbString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithRed:57./255. green:178./255. blue:154./255. alpha:1]
                           range:range];
        [atrbString endEditing];
        
        self.textView.attributedText = atrbString;
        
    }
    
    
    for (NSString *str in conteinsOfferPriceArray)
    {
        if([str isEqualToString:@""]) continue;
        
        if([[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"@"])
        {
            range = [self.textView.text rangeOfString:str];
           
            [atrbString beginEditing];
            [atrbString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor colorWithRed:57./255. green:178./255. blue:154./255. alpha:1]
                               range:range];
            [atrbString endEditing];
            
        }
    }
    
 self.textView.attributedText = atrbString;
    
  
    

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

#pragma mark -
#pragma mark HWCommentCelxlDelegate

- (void) stringWithTapWord:(NSString*)text
{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(stringWithTapWord:)])
    {
        for(NSDictionary *dict in self.mentionsArray)
        {
            HWMention *mention = [[HWMention alloc] initWithDictionary:dict error:nil];
            
            NSString *userName = [NSString stringWithFormat:@"@%@",mention.username];
            if ([userName isEqualToString:text])
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(transitionToProfileWithUserId:)]) {
                    
                    [self.delegate transitionToProfileWithUserId:mention.id];
                    break;
                }
            }
        }
        
        NSLog(@"%@",text);
        [self.delegate stringWithTapWord:text];
    }
    
    
}


@end
