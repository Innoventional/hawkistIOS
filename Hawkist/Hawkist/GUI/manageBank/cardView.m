//
//  cardView.m
//  Hawkist
//
//  Created by Anton on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "cardView.h"

@interface cardView()

@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UILabel *lastNumber;
@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UILabel *year;

- (IBAction)editAction:(id)sender;
- (IBAction)deleteAction:(id)sender;
@end

@implementation cardView

- (instancetype)initWithCard:(HWCard*)card
{
    if (self = [super init])
    {
        UIView* view = [[[NSBundle mainBundle]loadNibNamed:@"cardView" owner:self options:nil]firstObject];
        view.frame = self.bounds;
        [self addSubview:view];

        self.cardName.text = card.cardName;
        self.lastNumber.text = card.lastNumber;
        self.month.text = card.month;
        self.year.text = card.year;
    }
    return self;
}

- (IBAction)editAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(editCard:)])
        [self.delegate editCard:self];
}

- (IBAction)deleteAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(removeCard:)])
        [self.delegate removeCard:self];

}
@end
