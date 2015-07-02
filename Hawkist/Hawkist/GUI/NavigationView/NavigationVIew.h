//
//  NavigationVIew.h
//  Hawkist
//
//  Created by Anton on 01.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

@protocol NavigationViewDelegate <NSObject>

-(void) leftButtonClick;
-(void) rightButtonClick;

@end

#import <UIKit/UIKit.h>



@interface NavigationVIew : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftButtonOutlet;
- (IBAction)leftButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *title;
- (IBAction)rightButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *rightButtonOutlet;

@property (weak,nonatomic) id <NavigationViewDelegate> delegate;
@end
