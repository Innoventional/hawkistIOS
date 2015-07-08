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
}


- (void)awakeFromNib {
    
     self.userNameLable.text = self.item.user.username;
    [self.avatarImage setImageWithURL: [NSURL URLWithString: self.item.user.avatar] placeholderImage:nil];
    
    self.skidkaTextfield.text = self.item.discount;
    self.sellItemLabel.text = self.item.title;
    self.currentPriceLable.text = self.item.selling_price;
    //self.oldPriceLable.text = self.item.retail_price;
    
    //self.platform.text = self.item.platform;
    
    
    
    
    
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
