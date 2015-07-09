//
//  FeedScreenCollectionViewCell.m
//  FeedScreen
//
//  Created by Evgen Bootcov on 25.06.15.
//  Copyright (c) 2015 Evgen Bootcov. All rights reserved.
//

#import "FeedScreenCollectionViewCell.h"

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
    _item = item;
    
    self.userNameLable.text = self.item.user_username;
    [self.avatarImage setImageWithURL: [NSURL URLWithString: self.item.user_avatar] placeholderImage:nil];
    
    
    self.skidkaTextfield.text = self.item.discount;
    self.sellItemLabel.text = self.item.title;
    self.currentPriceLable.text = self.item.selling_price;
    self.oldPriceLable.text = self.item.retail_price;
//self.platform.text = self.item.platform;
    if(self.item.photos.count >= 1)
    {
        [self.itemImage setImageWithURL: [NSURL URLWithString: [self.item.photos objectAtIndex:0]] placeholderImage:nil];
    }
}

- (void)awakeFromNib {
    
     
    

    
    
    
    
    
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.itemImage.layer.cornerRadius = 5.0f;
    self.itemImage.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    
    self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.height /2;
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.borderWidth = 0;
    
   
    
   
   
    
    
    
}





@end
