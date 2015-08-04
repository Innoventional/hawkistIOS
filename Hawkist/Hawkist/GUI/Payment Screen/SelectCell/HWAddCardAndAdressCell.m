//
//  HWAddCardAndAdressCell.m
//  Hawkist
//
//  Created by User on 04.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWAddCardAndAdressCell.h"

@interface HWAddCardAndAdressCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation HWAddCardAndAdressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCellWithData:(HWAddDataModel*)dataModel
{
    self.titleLabel.text = dataModel.titleStr;
    self.descriptionLabel.text = dataModel.descriptionStr;
    [self.addButton setTitle:dataModel.titleForButtonStr forState:UIControlStateNormal];
}

@end
