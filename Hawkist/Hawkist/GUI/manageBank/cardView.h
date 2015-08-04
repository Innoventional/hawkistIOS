//
//  cardView.h
//  Hawkist
//
//  Created by Anton on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWCard.h"

@protocol cardViewDelegate <NSObject>

- (void)editCard:(id)sender;
- (void)removeCard:(NSString*)cardId;

@end

@interface cardView : UIView


@property (nonatomic,strong)id <cardViewDelegate> delegate;

- (void) setCard:(HWCard*)card;
@end
