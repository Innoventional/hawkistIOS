//
//  MoneyField.h
//  Hawkist
//
//  Created by Anton on 02.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MoneyFieldDelegate <NSObject>

- (void) moneyField:(id)sender ModifyTo:(NSString*)value;

@end

@interface MoneyField : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak,nonatomic) id<MoneyFieldDelegate> delegate;

@end