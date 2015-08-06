//
//  cardView.m
//  Hawkist
//
//  Created by Anton on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "CardView.h"

@interface CardView()

@property (strong, nonatomic) IBOutlet UILabel *cardName;
@property (strong, nonatomic) IBOutlet UILabel *lastNumber;
@property (strong, nonatomic) IBOutlet UILabel *month;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) NSString *cardId;
@property (strong, nonatomic) HWCard* currentCard;

- (IBAction)editAction:(id)sender;
- (IBAction)deleteAction:(id)sender;

@end

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIView* view = [[[NSBundle mainBundle]loadNibNamed:@"cardView" owner:self options:nil]firstObject];
      
        view.frame = self.bounds;
        
        view.clipsToBounds = NO;
        view.layer.cornerRadius = 5.0f;
        [self addSubview:view];

    }
    return self;
}



- (void) setCard:(HWCard*)card
{
    self.currentCard = card;
    self.cardName.text = card.name;
    self.lastNumber.text = card.last4;
    self.month.text = card.month;
    self.year.text = card.year;
    self.cardId = card.id;
}

- (IBAction)editAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(editCard:)])
        [self.delegate editCard:self.currentCard];
}

- (IBAction)deleteAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(removeCard:)])
        [self.delegate removeCard:self.currentCard.id];

}
@end
