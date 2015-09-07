//
//  HWFeedBackSegmentView.m
//  Hawkist
//
//  Created by User on 17.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWFeedBackSegmentView.h"
#import "UIColor+Extensions.h"

@interface HWFeedBackSegmentView ()

@property (strong, nonatomic) IBOutletCollection(HWFedbackSegmentButton) NSArray *buttonSegmentCollection;

@end

@implementation HWFeedBackSegmentView


- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];

    if (self) {
  
    }
   
    
    return self;
}

- (instancetype) awakeAfterUsingCoder:(NSCoder *)aDecoder {
    
    self = [ super awakeAfterUsingCoder:aDecoder];
  
    if (self) {
   
    }
    
    return self;
}


#pragma mark - set / get 


- (void) setPositiveButton:(HWFedbackSegmentButton *)positiveButton {
    
    _positiveButton = positiveButton;
    _positiveButton.titleButton.text = @"Positive";
}

- (void) setNeutralButton:(HWFedbackSegmentButton *)neutralButton {
    
    _neutralButton = neutralButton;
    _neutralButton.titleButton.text = @"Neutral";
}

- (void) setNegativeButton:(HWFedbackSegmentButton *)negativeButton {
    
    _negativeButton = negativeButton;
    _negativeButton.titleButton.text = @"Negative";
}




- (IBAction)pressPositiveButtonAction:(HWFedbackSegmentButton*)sender {
    
    [self selectedButton:sender];
    sender.selectedImage.backgroundColor = [UIColor colorWithRed:52./255. green:185./255. blue:165./255. alpha:1];
   
    if(self.delegate && [self.delegate respondsToSelector:@selector(pressPositiveButton:)]) {
        
        [self.delegate pressPositiveButton:sender];
    }
}

- (IBAction)pressNeutralButtonAction:(HWFedbackSegmentButton*)sender {
    
    [self selectedButton:sender];
    sender.selectedImage.backgroundColor = [UIColor color256RGBWithRed:233 green:215 blue:60];//[UIColor yellowColor];
  
    if(self.delegate && [self.delegate respondsToSelector:@selector(pressNeutralButton:)]) {
        
        [self.delegate pressNeutralButton:sender];
    }
}


- (IBAction)pressNegativeButtonAction:(HWFedbackSegmentButton*)sender{
    
    [self selectedButton:sender];
    sender.selectedImage.backgroundColor = [UIColor color256RGBWithRed:239 green:83 blue:80];//[UIColor redColor];
  
    if(self.delegate && [self.delegate respondsToSelector:@selector(pressNegativeButton:)]) {
        
        [self.delegate pressNegativeButton:sender];
    }
}


- (void) pressButtonWithStatus:(HWFeedbackType) status{
    
    
    switch (status) {
        case HWFeedbackPositive:
            
            [self selectedButton:self.positiveButton];
            self.positiveButton.selectedImage.backgroundColor = [UIColor colorWithRed:52./255. green:185./255. blue:165./255. alpha:1];
            
            break;
        case HWFeedbackNeutral:
            
            [self selectedButton:self.neutralButton];
            self.neutralButton.selectedImage.backgroundColor = [UIColor color256RGBWithRed:233 green:215 blue:60];
            
            break;
        case HWFeedbackNegative:
            
            [self selectedButton:self.negativeButton];
            self.negativeButton.selectedImage.backgroundColor = [UIColor color256RGBWithRed:239 green:83 blue:80];
            
            break;
            
        default:
            break;
    }
}

- (void) pressFirstButton {

    [self pressButtonWithStatus:HWFeedbackPositive];
    
//    [self selectedButton:self.positiveButton];
//     self.positiveButton.selectedImage.backgroundColor = [UIColor colorWithRed:52./255. green:185./255. blue:165./255. alpha:1];
}

- (void) selectedButton:(HWFedbackSegmentButton*) sender {
    
    for (HWFedbackSegmentButton *but in self.buttonSegmentCollection) {
        
         [self resetConfigButton:but
                   withColorBack:[UIColor colorWithRed:38./255. green:41./255. blue:48./255. alpha:1]
                   withColorText:[UIColor colorWithRed:141./255. green:143./255. blue:148./255. alpha:1]
         ];
    }
    
    sender.backgroundColor = [UIColor colorWithRed:244./255. green:242./255. blue:248./255. alpha:1];
    [sender.count setTextColor:[UIColor colorWithRed:99./255. green:99./255. blue:100./255. alpha:1]];
    [sender.titleButton setTextColor:[UIColor colorWithRed:99./255. green:99./255. blue:95./255. alpha:1]];
    
}


- (void) resetConfigButton:(HWFedbackSegmentButton*) but
       withColorBack:(UIColor*) backgraund
       withColorText:(UIColor*) textColor {
    
    
   
    but.backgroundColor = backgraund;
    [but.count setTextColor: textColor];
    [but.titleButton setTextColor: textColor];
    but.selectedImage.backgroundColor = [UIColor clearColor];
    but.selectedImage.image = nil;
    

}

 @end
