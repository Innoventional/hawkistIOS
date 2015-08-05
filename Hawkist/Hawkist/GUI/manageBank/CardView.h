//
//  cardView.h
//  Hawkist
//
//  Created by Anton on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWCard.h"

@protocol CardViewDelegate <NSObject>

- (void)editCard:(HWCard*)card;
- (void)removeCard:(NSString*)cardId;

@end

@interface CardView : UIView


@property (nonatomic,strong)id <CardViewDelegate> delegate;

- (void) setCard:(HWCard*)card;
@end
