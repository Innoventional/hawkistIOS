//
//  myItemCellView.m
//  Hawkist
//
//  Created by Anton on 14.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "MyItemCellView.h"

@implementation MyItemCellView

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
    self.itemImage.image = nil;
    
    _item = item;
   
    if (self.item.discount == nil || [self.item.discount isEqualToString: @"0"]) {
        self.discount.text = @"1%";
    }
    else
    
    {
        self.discount.text = [NSString stringWithFormat:@"%@%%",self.item.discount];
    }
    
    self.title.text = self.item.title;
    
    self.currentPrice.text = self.item.selling_price;
    
    self.oldPrice.text = self.item.retail_price;
    
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
    
}

@end
