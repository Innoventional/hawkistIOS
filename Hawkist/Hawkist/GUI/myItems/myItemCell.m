//
//  myItemCellView.m
//  Hawkist
//
//  Created by Anton on 14.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "myItemCell.h"
#import "HWTag+Extensions.h"
#import "NetworkManager.h"
#import "UIColor+Extensions.h"
#import <pop/POP.h>
#import "UIImageView+Extensions.h"



@interface myItemCell()
 
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic,strong) UIVisualEffectView* visualEffectView;

@property (nonatomic, strong) IBOutlet  UIButton *commentButton;
@property (nonatomic, strong) IBOutlet  UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *commentView;
@property (nonatomic, assign) BOOL isLiked;




@property (nonatomic, assign)  NSInteger countLike;

@property (weak, nonatomic) IBOutlet UIImageView *skidkaBackground;

@end

@implementation myItemCell

-(instancetype) awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    if (self)
    {
         

    }
    
    return self;
}



- (IBAction) moveToTrash:(UIButton*)sender
{
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"Please confirm that you wish to delete this listing." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert show];
    

    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0)
    [[NetworkManager shared]removeItemById:self.item.id
     
                              successBlock:^() {
                                  if (self.delegate && [self.delegate respondsToSelector: @selector(updateParent)])
                                      [_delegate updateParent];
                                  
                              }
                              failureBlock:^(NSError *error) {
                                  if (self.delegate && [self.delegate respondsToSelector: @selector(showError:)])
                                      [_delegate showError:error];
                              }];
}





-(void)setItem:(HWItem *)item
{
    self.commentsCount.text = item.comments;
    _item = item;
    [self setupLikeStar];
    
    if ([self.item.discount intValue] <25 ) {
        self.discount.text = @"";
        self.skidkaBackground.hidden = YES;
    }
    else
    
    {
        self.discount.text = [NSString stringWithFormat:@"-%@%%",self.item.discount];
        self.skidkaBackground.hidden = NO;
    }
    
    HWTag* itemPlatform = [HWTag getPlatformById:self.item.platform from:[AppEngine shared].tags];
    self.platform.text =  itemPlatform.name;
    self.title.text = self.item.title;
    self.currentPrice.text = [NSString stringWithFormat:@"£%@", self.item.selling_price];
     
    NSString *oldPriceWithTuning = [NSString stringWithFormat:@"£%@", self.item.retail_price];
    self.oldPrice.text = [NSString stringWithFormat:@"(%@)", oldPriceWithTuning];
    NSRange oldPriceRange = [self.oldPrice.text rangeOfString:oldPriceWithTuning];
    
    NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc]initWithAttributedString:self.oldPrice.attributedText];
    
    [atrStr beginEditing];
    [atrStr addAttribute:NSStrikethroughStyleAttributeName
                   value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                   range:oldPriceRange];
    self.oldPrice.attributedText = atrStr;
    [atrStr endEditing];
    
    [self.itemImage setImage:nil];
    
    [self.itemImage setImageWithUrl:[NSURL URLWithString: self.item.photos.firstObject]
                      withIndicator:self.indicator];
 
    [self.visualEffectView removeFromSuperview];
                    self.userInteractionEnabled = YES;
    

    if ([self.item.status isEqualToString:@"2"])
    {
        [self setupSold];
    }
   
    
}


- (void) setupSold
{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.visualEffectView.frame = self.itemImage.bounds;
    self.visualEffectView.alpha = 0.7;
    
    [self addSubview:self.visualEffectView];
    UILabel* soldLabel = [[UILabel alloc]initWithFrame:CGRectMake(17,self.height/2 - 60, self.width,50)];
    
    soldLabel.text = @"SOLD";
    soldLabel.textColor = [UIColor color256RGBWithRed: 88  green: 184 blue: 164];
    
    soldLabel.font = [UIFont fontWithName:@"OpenSans" size:40];
    soldLabel.transform = CGAffineTransformMakeRotation(-M_PI/4);
    [self.visualEffectView addSubview:soldLabel];
    self.userInteractionEnabled = YES;
    
    self.mytrash.hidden = YES;
    
    

}
- (void) setupLikeStar
{
 
        self.isLiked = [self.item.liked integerValue];
        self.likesCount.text = self.item.likes;
        self.countLike = [self.item.likes integerValue];
        
        if(self.isLiked != 0)
        {
            self.likeImageView.image = [UIImage imageNamed:@"starYellow"];
        } else {
            
            self.likeImageView.image = [UIImage imageNamed:@"stargrey"];
        }
}



- (void)awakeFromNib {
 
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    
    
  }

#pragma mark -
#pragma mark Action


-(IBAction) pressCommentAction:(id)sender
{
    if( self.delegate && [self.delegate respondsToSelector:@selector(pressCommentButton: withItem:)])
    {
        [self.delegate pressCommentButton:sender withItem:self.item];
    }
    
}

- (IBAction) pressLikeAction:(id )sender
{
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(10, 10)];
    sprintAnimation.springBounciness = 20.f;
 
    
    if(self.isLiked)
    {
        
        self.likeImageView.image = [UIImage imageNamed:@"stargrey"];
        self.countLike --;
        self.isLiked = NO;
        
        self.item.liked = @"0";
        self.item.likes = [NSString stringWithFormat:@"%ld",(long)self.countLike];
        
    } else {
        
        self.likeImageView.image = [UIImage imageNamed:@"starYellow"];
        self.countLike ++;
        self.isLiked = YES;
        
        
        self.item.liked = @"1";
        self.item.likes = [NSString stringWithFormat:@"%ld",(long)self.countLike];
        
    }

    self.likesCount.text = [NSString stringWithFormat:@"%ld", (long)self.countLike];
    [self.likeImageView pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(pressLikeButton: withItem:)])
    {
        [self.delegate pressLikeButton:sender withItem:self.item];
        
    }
    
    
}


@end
