//
//  BuyThisItemViewController.h
//  Hawkist
//
//  Created by Anton on 17.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationVIew.h"
#import "HWBaseViewController.h"
#import "MoneyField.h"

@interface BuyThisItemViewController : HWBaseViewController <NavigationViewDelegate,MoneyFieldDelegate>
@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;
@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *discount;

- (IBAction)sendOffer:(id)sender;
@property (weak, nonatomic) IBOutlet MoneyField *moneyField;

- (instancetype) initWithItem: (HWItem*) item;
@end
