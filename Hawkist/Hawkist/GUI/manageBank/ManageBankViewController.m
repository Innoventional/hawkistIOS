//
//  ManageBankViewController.m
//  Hawkist
//
//  Created by Anton on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "ManageBankViewController.h"
#import "UIView+Extensions.h"
#import "AddCardViewController.h"

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

- (void) viewDidLoad
{
    self.navigation.delegate = self;
    self.navigation.title.text = @"My Bank Cards";
     self.contentHeight.constant = self.view.height - 95;
}


- (void) reload
{
    
    
    for(UIView* subview in [self.contentView subviews]) {
        if ([subview isKindOfClass:[CardView class]])
            [subview removeFromSuperview];
    }
    
    [self showHud];
    
    [[NetworkManager shared]getAllBankCards:^(NSArray *cards) {
        
        self.cards = [NSArray arrayWithArray:cards];
        float cardWidth = self.view.width - 30;
        float cardHeight = cardWidth * 127 / 293;
        
        for (int i = 0; i<self.cards.count; i++) {
            CardView* card = [[CardView alloc]initWithFrame:CGRectMake(15, i*(cardHeight+20)+15, cardWidth, cardHeight)];
            
            
            [card setCard:(HWCard*)[self.cards objectAtIndex:i]];
            [self.contentView addSubview:card];
            
            card.delegate = self;
        }
        
        if (((cardHeight+20)*self.cards.count +85)< self.view.height-95)
        {
            self.contentHeight.constant = self.view.height - 95;

        }
        else
        {
            self.contentHeight.constant = ((cardHeight+20)*self.cards.count)+85;

        }
        
        [self hideHud];
        
    } failureBlock:^(NSError *error) {
        [self hideHud];
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        
    }];
    
    
  
}

- (void) viewDidAppear:(BOOL)animated
{
    [self reload];
}
- (IBAction) addNewCard:(id)sender {
    
    [self.navigationController pushViewController:[[AddCardViewController alloc]init] animated:NO];
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)removeCard:(NSString *)cardId
{
    [self showHud];
    [[NetworkManager shared]removeBankCard:cardId successBlock:^{
        [self hideHud];
        [self reload];
        
    } failureBlock:^(NSError *error) {

        [self hideHud];
         [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
}

- (void)editCard:(HWCard *)card
{
    AddCardViewController* vc = [[AddCardViewController alloc]initWithCard:card];

    
    
     [self.navigationController pushViewController:vc animated:NO];

}
@end
