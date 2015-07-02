//
//  NavigationBar.h
//  Hawkist
//
//  Created by Anton on 30.06.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface NavigationBar : UIView

@property (copy, nonatomic) IBOutlet UIButton *LeftButtonOutLet;

- (IBAction)LeftButtonAction:(id)sender;

@property (copy, nonatomic) IBOutlet UILabel *Title;

@property (copy, nonatomic) IBOutlet UIButton *RightButtonOutlet;

- (IBAction)RightButtonAction:(id)sender;

@property (copy, nonatomic) IBOutlet UIImageView *ImageView;


@property (copy,nonatomic) IBInspectable UIColor *bgColor;
@end
