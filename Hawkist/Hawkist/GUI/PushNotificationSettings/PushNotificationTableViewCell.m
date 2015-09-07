//
//  PushNotificationTableViewCell.m
//  Hawkist
//
//  Created by Anton on 02.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "PushNotificationTableViewCell.h"

@interface PushNotificationTableViewCell() 
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, assign) int type;
@property (strong, nonatomic) IBOutlet UISwitch *status;
@end

@implementation PushNotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setValue:(BOOL)value;
{
    [self.status setEnabled:value];
}

- (BOOL) getValue
{
    return [self.status isOn];
}

- (int) getType
{
    return self.type;
}

- (void) setCellWithMenuDataModel:(NotificationSettingsModel*)dataModel
{
    [self.icon setImage:dataModel.image];
    self.title.text = dataModel.title;
    [self.status setOn:dataModel.enabled];
    self.type = dataModel.type;
}

- (IBAction)modifyStatus:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changed:)])
    {
        [self.delegate changed:self];
    }

}

@end
