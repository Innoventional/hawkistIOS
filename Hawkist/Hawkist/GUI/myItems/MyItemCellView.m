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

//@property (nonatomic,strong)UIButton* mytrash;
@property (nonatomic,strong) UIVisualEffectView* visualEffectView;

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
    self.itemImage.image = nil;
    
    _item = item;
   
    if (self.item.discount == nil || [self.item.discount isEqualToString: @"0"]) {
        self.discount.text = @"1%";
    }
    else
    
    {
        self.discount.text = [NSString stringWithFormat:@"%@%%",self.item.discount];
    }
    
    
    HWTag* itemPlatform = [HWTag getPlatformById:self.item.platform from:[AppEngine shared].tags];
    
    self.platform.text =  itemPlatform.name;
    
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
   
    [self.visualEffectView removeFromSuperview];
                    self.userInteractionEnabled = YES;
    
    if ([self.item.id integerValue]%2 != 0)
        
    {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        self.visualEffectView.frame = self.bounds;
        
        self.visualEffectView.alpha = 0.7;
        
        [self addSubview:self.visualEffectView];
        
        
                UILabel* soldLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,self.height/2 - 50, self.width,50)];
        
                soldLabel.text = @"SOLD";
                soldLabel.textColor = [UIColor color256RGBWithRed: 88  green: 184 blue: 164];
        
                soldLabel.font = [UIFont fontWithName:@"OpenSans" size:60];
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

@end
