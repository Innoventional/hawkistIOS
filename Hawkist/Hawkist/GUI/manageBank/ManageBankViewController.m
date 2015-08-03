//
//  ManageBankViewController.m
//  Hawkist
//
//  Created by Anton on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "ManageBankViewController.h"
#import "cardView.h"
#import "UIView+Extensions.h"

@interface ManageBankViewController ()
@property (nonatomic,strong)NSArray* cards;
@end

@implementation ManageBankViewController

- (instancetype)init
{
    self = [super initWithNibName: @"ManageBankView" bundle: [NSBundle mainBundle]];
    if(self)
    {
        
    }
    return self;
}

-(void)viewDidLoad
{
self.navigation.delegate = self;
    
    HWCard* card1 = [[HWCard alloc]init];
    HWCard* card2 = [[HWCard alloc]init];
    
    card1.cardName = @"my Great Card";
    
    card1.lastNumber = @"9873";
    
    card1.month = @"05";
    
    card1.year = @"10";
    
    card2.cardName = @"my second Card";
    
    card2.lastNumber = @"1111";
    
    card2.month = @"11";
    
    card2.year = @"04";
    
    self.cards = [NSArray arrayWithObjects:card1,card2,card1, nil];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    float cardWidth = self.view.width - 30;
    float cardHeight = cardWidth * 127 / 293;
    
    for (int i = 0; i<self.cards.count; i++) {
      
        cardView* card = [[cardView alloc]initWithFrame:CGRectMake(15, i*(cardHeight+20)+15, cardWidth, cardHeight)];
        
        [card setCard:(HWCard*)[self.cards objectAtIndex:i]];
       
       
        
        [self.contentView addSubview:card];
        
    }
    
    if (((cardHeight+20)*self.cards.count +85)< self.view.height-95)
    {
        self.contentHeight.constant = self.view.height - 95;

    }
    else
    {
        self.contentHeight.constant = ((cardHeight+20)*self.cards.count)+85;
    }

}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:NO];
}


@end
