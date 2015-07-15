//
//  myItemCellView.m
//  Hawkist
//
//  Created by Anton on 14.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "MyItemCellView.h"

@interface MyItemCellView()

@property (nonatomic,strong)UIButton* mytrash;

@end

@implementation MyItemCellView


- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.mytrash = [[UIButton alloc]initWithFrame:CGRectMake(self.width-6, 12, 21 , 21)];
        self.mytrash.backgroundColor = [UIColor greenColor];
        [self.mytrash addTarget:self action:@selector(moveToTrash) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.mytrash];
        
    }
    return self;
}

- (void) moveToTrash
{

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
    
    self.mytrash.frame = CGRectMake(self.width-31, 12, 21 , 21);
    

    
    [self.mytrash setBackgroundImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    self.mytrash.layer.cornerRadius = 5;
    self.mytrash.layer.masksToBounds = YES;

    
}

- (void)awakeFromNib {
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.itemImage.layer.cornerRadius = 5.0f;
    self.itemImage.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    
  }

@end
