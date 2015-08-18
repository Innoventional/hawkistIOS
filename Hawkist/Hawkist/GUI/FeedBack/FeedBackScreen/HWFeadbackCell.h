//
//  HWFeadbackCell.h
//  Hawkist
//
//  Created by User on 18.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWFeadbackCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *messageText;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


+ (CGFloat) heightWith:(NSString*)text;

@end
