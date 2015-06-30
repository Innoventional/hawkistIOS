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
@property (weak, nonatomic) IBOutlet UIButton *LeftButtonOutLet;
- (IBAction)LeftButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UIButton *RightButtonOutlet;
- (IBAction)RightButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@end
