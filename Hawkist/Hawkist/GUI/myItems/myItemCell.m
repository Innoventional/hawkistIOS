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


@interface myItemCell()
 
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic,strong) UIVisualEffectView* visualEffectView;

@property (nonatomic, strong) IBOutlet  UIButton *commentButton;
@property (nonatomic, strong) IBOutlet  UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *commentView;
@property (nonatomic, assign) BOOL isLiked;


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
  
    if([item.liked integerValue] != 0)
    {
        self.likeImageView.image = [UIImage imageNamed:@"starYellow"];
    } else {
        
        self.likeImageView.image = [UIImage imageNamed:@"stargrey"];
    }
    
    self.isLiked = [item.liked integerValue];
    
    self.commentsCount.text = item.comments;
    self.likesCount.text = item.likes;
    
    self.commentsCount.text = item.comments;
    self.likesCount.text = item.likes;
    _item = item;
   
    if (self.item.discount == nil || [self.item.discount isEqualToString: @"0"]) {
        self.discount.text = @"-1%";
    }
    else
    
    {
        self.discount.text = [NSString stringWithFormat:@"-%@%%",self.item.discount];
    }
    
    
    HWTag* itemPlatform = [HWTag getPlatformById:self.item.platform from:[AppEngine shared].tags];
    self.platform.text =  itemPlatform.name;
    self.title.text = self.item.title;
    self.currentPrice.text = [NSString stringWithFormat:@"£ %@", self.item.selling_price];
     
    NSString *oldPriceWithTuning = [NSString stringWithFormat:@"£ %@", self.item.retail_price];
    self.oldPrice.text = [NSString stringWithFormat:@"(%@)", oldPriceWithTuning];
    NSRange oldPriceRange = [self.oldPrice.text rangeOfString:oldPriceWithTuning];
    
    NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc]initWithAttributedString:self.oldPrice.attributedText];
    
    [atrStr beginEditing];
    [atrStr addAttribute:NSStrikethroughStyleAttributeName
                   value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                   range:oldPriceRange];
    self.oldPrice.attributedText = atrStr;
    [atrStr endEditing];
    
    self.itemImage.image = nil;
    
   [self avatarInit];
    
    [self.visualEffectView removeFromSuperview];
                    self.userInteractionEnabled = YES;
    

    if (self.item.sold)
        
    {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.visualEffectView.frame = self.bounds;
        self.visualEffectView.alpha = 0.7;
        
        [self addSubview:self.visualEffectView];
        
        
                UILabel* soldLabel = [[UILabel alloc]initWithFrame:CGRectMake(17,self.height/2 - 60, self.width,50)];
        
                soldLabel.text = @"SOLD";
                soldLabel.textColor = [UIColor color256RGBWithRed: 88  green: 184 blue: 164];
        
                soldLabel.font = [UIFont fontWithName:@"OpenSans" size:40];
                soldLabel.transform = CGAffineTransformMakeRotation(-M_PI/4);
                [self.visualEffectView addSubview:soldLabel];
                self.userInteractionEnabled = NO;
        
        
    
    }
   
    
}


- (void) avatarInit
{
    
//    if(self.item.photos.count >= 1)
//    {
//        [self.itemImage setImageWithURL: [NSURL URLWithString: [self.item.photos objectAtIndex:0]] placeholderImage:nil];
//    }
    
    __weak __block myItemCell *my = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: self.item.photos.firstObject]];
    
    [self.itemImage setImageWithURLRequest:request
                           placeholderImage:nil
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        
                                            my.itemImage.image = image;
                                            [my.indicator stopAnimating];
                                      
                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        
                                        
                                    }];
    
}

 




- (void)awakeFromNib {
    
    
//    self.backgroundColor = [UIColor whiteColor];
//    self.itemImage.layer.cornerRadius = 5.0f;
//    self.itemImage.layer.masksToBounds = YES;
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


    NSInteger countLike = [self.likesCount.text intValue];
    
    if(self.isLiked)
    {
        
        self.likeImageView.image = [UIImage imageNamed:@"stargrey"];
        countLike --;
        self.isLiked = NO;
        
    } else {
        
        self.likeImageView.image = [UIImage imageNamed:@"starYellow"];
        countLike ++;
        self.isLiked = YES;
    }

    self.likesCount.text = [NSString stringWithFormat:@"%ld", (long)countLike];
    
    
    [self.likeImageView pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    
    
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(pressLikeButton: withItem:)])
    {
        [self.delegate pressLikeButton:sender withItem:self.item];
        
    }
    
    
    
    
}


@end
