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
IB_DESIGNABLE
@property (weak, nonatomic) IBOutlet UIButton *LeftButtonOutLet;
- (IBAction)LeftButtonAction:(id)sender;
IB_DESIGNABLE
@property (weak, nonatomic) IBOutlet UILabel *Title;
IB_DESIGNABLE
@property (weak, nonatomic) IBOutlet UIButton *RightButtonOutlet;
- (IBAction)RightButtonAction:(id)sender;
IB_DESIGNABLE
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
IB_DESIGNABLE
@property (weak,nonatomic) NSString* setTitle;

IB_DESIGNABLE
@property (weak,nonatomic) NSString* setTitle2;
IB_DESIGNABLE
@property (weak,nonatomic) NSString* setTitle3;
IB_DESIGNABLE
@property (weak,nonatomic) NSString* setTitle4;

@end
