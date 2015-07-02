//
//  CustomButton.h
//  Hawkist
//
//  Created by Anton on 01.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIView
@property (weak, nonatomic) IBOutlet UILabel *Text;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UIImageView *img;
- (IBAction)tapAction:(id)sender;

@end
