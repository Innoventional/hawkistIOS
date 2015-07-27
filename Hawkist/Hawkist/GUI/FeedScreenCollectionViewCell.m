//
//  FeedScreenCollectionViewCell.m
//  FeedScreen
//
//  Created by Evgen Bootcov on 25.06.15.
//  Copyright (c) 2015 Evgen Bootcov. All rights reserved.
//

#import "FeedScreenCollectionViewCell.h"
#import "HWTag+Extensions.h"
#import "HWProfileViewController.h"


@interface FeedScreenCollectionViewCell ()

@property (nonatomic, strong) NSString *userId;

@end

@implementation FeedScreenCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
    }
    return self;
}

-(void)setItem:(HWItem *)item
{
    
    self.opinionLable.text = item.comments;
    self.starsLable.text = item.likes;
    
    self.userId = item.user_id;
    self.avatarImage.image = nil;
    self.avatarImage.image = [UIImage imageNamed:@"NoAvatar"];
    self.itemImage.image = nil;
    _item = item;
    
    self.userNameLable.text = self.item.user_username.uppercaseString;
    [self.avatarImage setImageWithURL: [NSURL URLWithString: self.item.user_avatar] placeholderImage:nil];
    
    
    //self.skidkaTextfield.text = self.item.discount;
    if (self.item.discount == nil || [self.item.discount isEqualToString: @"0"]) {
        self.skidkaTextfield.text = @"1%";
    } else {
        self.skidkaTextfield.text = [NSString stringWithFormat:@"%@%%",self.item.discount];
    }
    self.sellItemLabel.text = self.item.title;
    self.currentPriceLable.text = self.item.selling_price;
    self.oldPriceLable.text = self.item.retail_price;

    HWTag* itemPlatform = [HWTag getPlatformById:self.item.platform from:[AppEngine shared].tags];
    
    self.consoleNameLable.text =  itemPlatform.name;
    
    //self.platform.text = self.item.platform;
    if(self.item.photos.count >= 1)
    {
        [self.itemImage setImageWithURL: [NSURL URLWithString: [self.item.photos objectAtIndex:0]] placeholderImage:nil];
    }
    [self setNeedsLayout];
}

- (void)awakeFromNib {
    
         
    self.backgroundColor = [UIColor whiteColor];
    self.itemImage.layer.cornerRadius = 5.0f;
    self.itemImage.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    
    self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width /2;
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.borderWidth = 0;
    
   
    
    
}

#pragma mark - 
#pragma mark Action
 
- (IBAction)transitionToUserProfileAction:(UIButton *)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(willTransitionToUserProfileButton)])
    {
        if ([self.delegate willTransitionToUserProfileButton])
        {
            
            [self transitionToUserPtofile];
           
            
        }
    }
    
}


- (void) transitionToUserPtofile
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(transitionToProfileScreenWithUserId:)])
    {
        
        [self.delegate transitionToProfileScreenWithUserId:self.userId];
        
    }
    
}

@end
