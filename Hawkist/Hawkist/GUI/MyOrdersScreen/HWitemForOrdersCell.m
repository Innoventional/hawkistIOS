//
//  HWitemForOrdersCell.m
//  Hawkist
//
//  Created by User on 06.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWitemForOrdersCell.h"
#import "HWOrderItem.h"
#import "HWOrderButton.h"
#import "HWLeaveFeedbackViewController.h"




@interface HWitemForOrdersCell ()

@property (weak, nonatomic) IBOutlet HWOrderButton *receivedButton;
@property (weak, nonatomic) IBOutlet HWOrderButton *hasIssueButton;
@property (nonatomic, weak) IBOutlet UIButton *feedbackButton;

@property (nonatomic, strong) HWOrderItem *orderItem;

@property (nonatomic, weak) IBOutlet UIImageView *statusImView;



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

- (instancetype) awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    if(self)
    {
        
    }
    return self;
    
}

- (void) setCellWithOrderItem:(HWOrderItem*) orderItems;
{
    if([orderItems.available_feedback integerValue]) {
        
        
        self.feedbackButton.hidden = NO;
    } else {
        
        self.feedbackButton.hidden = YES;
    }
    
    self.orderItem = orderItems;
    self.item = orderItems.item;
    
     self.receivedButton.acceptImage.image = [UIImage imageNamed:@"green"];
     self.receivedButton.title.text = @"Received";
    
    self.hasIssueButton.acceptImage.image = [UIImage imageNamed:@"red"];
    self.hasIssueButton.title.text = @"Has issue";

    
    
    if( orderItems.status != 0)
    {
        self.receivedButton.enabled = NO;
        self.hasIssueButton.enabled = NO;
        
//        if(self.feedbackButton.hidden){
//            
//            self.feedbackButton.hidden = NO;
//            self.feedbackButton.enabled = NO;
//            [self.feedbackButton setTitle:@"Feedback sent" forState:UIControlStateNormal];
//            [self.feedbackButton setImage:nil forState:UIControlStateNormal];
//        }
        
            }
    else
    {
        self.receivedButton.enabled = YES;
        self.hasIssueButton.enabled = YES;
    }
    
     self.hasIssueButton.backgroundColor = [UIColor whiteColor];
     self.receivedButton.backgroundColor = [UIColor whiteColor];
    
    switch (orderItems.status) {
        case 1:
            self.receivedButton.backgroundColor = [UIColor colorWithRed:1 green:200./255. blue:200./255 alpha:1];
            self.hasIssueButton.backgroundColor = [UIColor whiteColor];
            [self.statusImView setImage:[UIImage imageNamed:@"received"]];
            
           
            break;
            
        case 2:
            self.hasIssueButton.backgroundColor = [UIColor colorWithRed:1 green:200./255. blue:200./255 alpha:1];
            self.receivedButton.backgroundColor = [UIColor whiteColor];
            [self.statusImView setImage:[UIImage imageNamed:@"hasissue"]];
            
            
            
            break;
        default:
            [self.statusImView setImage:[UIImage imageNamed:@""]];
            [self setFeedBackHiden:YES];
            break;
    }
}


-(void)setFeedBackHiden:(BOOL)isHiden {
    
    
    NSString *str;
    UIImage *im;
    
    if(isHiden){
        im = [UIImage imageNamed:@"fff"];
        str = @"Leave Feedback";
    } else {
        im = nil;
        str = @"Feedback sent";
    }
                    self.feedbackButton.hidden = isHiden;
                    self.feedbackButton.enabled = isHiden;
                    [self.feedbackButton setTitle:str forState:UIControlStateNormal];
                    [self.feedbackButton setImage:im forState:UIControlStateNormal];
    
}

#pragma mark -
#pragma mark Actions

- (IBAction)receivedAction:(UIButton *)sender
{
    if (self.orderCellDelegate && [self.orderCellDelegate respondsToSelector:@selector(receivedAction:withItem:)])
    {
        [self.orderCellDelegate receivedAction:sender withItem:self.orderItem];
    }
    
}


- (IBAction)hasIssueAction:(UIButton *)sender
{
    
    if (self.orderCellDelegate && [self.orderCellDelegate respondsToSelector:@selector(hasIssueAction:withItem: )])
    {
        [self.orderCellDelegate hasIssueAction:sender withItem:self.orderItem];
    }
    
    
}

- (IBAction)feedbackAction:(id)sender {
 
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(feedbackAction:witgUserID:withOrderId:)]) {
        
        [self.orderCellDelegate feedbackAction:sender witgUserID:self.item.user_id withOrderId:self.orderItem.id];
    }
 

}

@end
