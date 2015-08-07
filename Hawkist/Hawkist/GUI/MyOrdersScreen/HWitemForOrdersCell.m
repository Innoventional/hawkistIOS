//
//  HWitemForOrdersCell.m
//  Hawkist
//
//  Created by User on 06.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWitemForOrdersCell.h"
#import "HWOrderItem.h"



@interface HWitemForOrdersCell ()

@property (weak, nonatomic) IBOutlet UIButton *receivedButton;
@property (weak, nonatomic) IBOutlet UIButton *hasIssueButton;

@property (nonatomic, strong) HWOrderItem *orderItem;



@end

@implementation HWitemForOrdersCell

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    
    return self;
}

- (void) setCellWith:(HWOrderItem*)orderItem
{
    
    self.orderItem = orderItem;
    self.title.text = orderItem.title;
    
    /*
     
     ptional>* id;
     @property (nonatomic, strong) NSString<Optional>* title;
     @property (nonatomic, strong) NSString<Optional>* image;
     @property (nonatomic, strong) NSString<Optional>* retail_price;
     @property (nonatomic, strong) NSString<Optional>* selling_price;
     
     @property (nonatomic, strong) NSString<Optional>* user_id;
     @property (nonatomic, strong) NSString<Optional>* status;
     
     
     
     UIButton* mytrash;
     
     
     @property (strong, nonatomic) IBOutlet UIImageView *itemImage;
     @property (strong, nonatomic) IBOutlet UILabel *discount;
     
     @property (strong, nonatomic) IBOutlet UILabel *title;
     
     @property (strong, nonatomic) IBOutlet UILabel *likesCount;
     
     @property (strong, nonatomic) IBOutlet UILabel *commentsCount;
     
     @property (strong, nonatomic) IBOutlet UILabel *platform;
     
     @property (strong, nonatomic) IBOutlet UILabel *oldPrice;
     @property (strong, nonatomic) IBOutlet UILabel *currentPrice;


     
     */
    
   
    
}

#pragma mark -
#pragma mark Actions

- (IBAction)receivedAction:(UIButton *)sender
{
    if (self.orderCellDelegate && [self.orderCellDelegate respondsToSelector:@selector(receivedAction:withItem:)])
    {
        [self.orderCellDelegate receivedAction:sender withItem:self.item];
    }
    
}


- (IBAction)hasIssueAction:(UIButton *)sender
{
    
    if (self.orderCellDelegate && [self.orderCellDelegate respondsToSelector:@selector(hasIssueAction:withItem:)])
    {
        [self.orderCellDelegate hasIssueAction:sender withItem:self.item];
    }
    
    
}


@end
