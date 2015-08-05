//
//  myItemCellView.m
//  Hawkist
//
//  Created by Anton on 14.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "MyItemCellView.h"
#import "HWTag+Extensions.h"
#import "NetworkManager.h"
#import "UIColor+Extensions.h"


@interface MyItemCellView()
 
@property (nonatomic,strong) UIVisualEffectView* visualEffectView;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *commentView;



@end

@implementation MyItemCellView



-(instancetype) awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    if (self)
    {
        self.mytrash = [[UIButton alloc]initWithFrame:CGRectMake(self.width-6, 12, 21 , 21)];
        self.mytrash.backgroundColor = [UIColor greenColor];
        [self.mytrash addTarget:self action:@selector(moveToTrash) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mytrash];
        
        
        self.commentButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 40, 40, 40)];
       // self.commentButton.backgroundColor = [UIColor redColor];
        [self.commentButton addTarget:self
                               action:@selector(pressCommentAction:)
                     forControlEvents:UIControlEventTouchUpInside];
        
         [self addSubview:self.commentButton];
        
        self.likeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 50, self.bounds.size.height - 40, 40, 40)];
        //self.likeButton.backgroundColor = [UIColor redColor];
        [self.likeButton addTarget:self
                               action:@selector(pressLikeAction:)
                     forControlEvents:UIControlEventTouchUpInside];
         [self addSubview:self.likeButton];


    }
    
    return self;
}



- (void) moveToTrash
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
    if(item.liked)
    {
        self.likeImageView.image = [UIImage imageNamed:@"starYellow"];
    } else {
        
        self.likeImageView.image = [UIImage imageNamed:@"starYellow"];
    }
    
    self.commentsCount.text = item.comments;
    self.likesCount.text = item.likes;
    
    
    self.itemImage.image = nil;
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
    
    
    
    
    if(self.item.photos.count >= 1)
    {
        [self.itemImage setImageWithURL: [NSURL URLWithString: [self.item.photos objectAtIndex:0]] placeholderImage:nil];
    }
    [self setNeedsLayout];
    
    self.mytrash.frame = CGRectMake(self.width-31, 12, 21 , 21);
    

    
    [self.mytrash setBackgroundImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    self.mytrash.layer.cornerRadius = 5;
    self.mytrash.layer.masksToBounds = YES;
   
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
 




- (void)awakeFromNib {
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.itemImage.layer.cornerRadius = 5.0f;
    self.itemImage.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    
  }

#pragma mark -
#pragma mark Action
 
-(void) pressCommentAction:(UIButton*)sender
{
    if( self.delegate && [self.delegate respondsToSelector:@selector(pressCommentButton: withItem:)])
    {
        [self.delegate pressCommentButton:sender withItem:self.item];
    }
    
}

- (void) pressLikeAction:(UIButton*)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pressLikeButton: withItem:)])
    {
        [self.delegate pressLikeButton:sender withItem:self.item];
        
    }
}


@end
