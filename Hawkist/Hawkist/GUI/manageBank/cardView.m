//
//  cardView.m
//  Hawkist
//
//  Created by Anton on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "cardView.h"

@interface cardView()

@property (strong, nonatomic) IBOutlet UILabel *cardName;
@property (strong, nonatomic) IBOutlet UILabel *lastNumber;
@property (strong, nonatomic) IBOutlet UILabel *month;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) NSString *cardId;


- (IBAction)editAction:(id)sender;
- (IBAction)deleteAction:(id)sender;

@end

@implementation cardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIView* view = [[[NSBundle mainBundle]loadNibNamed:@"cardView" owner:self options:nil]firstObject];
      
        view.frame = self.bounds;
        
        view.clipsToBounds = NO;
        [self addSubview:view];

    }
    return self;
}



- (void) setCard:(HWCard*)card
{
    self.cardName.text = card.name;
    self.lastNumber.text = card.last4;
    self.month.text = card.exp_month;
    self.year.text = card.exp_year;
    self.cardId = card.id;
}

- (IBAction)editAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(editCard:)])
        [self.delegate editCard:self];
}

- (IBAction)deleteAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(removeCard:)])
        [self.delegate removeCard:self.cardId];

}
@end
