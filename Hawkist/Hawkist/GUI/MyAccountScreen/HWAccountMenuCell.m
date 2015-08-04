//
//  HWAccountMenuCell.m
//  Hawkist
//
//  Created by User on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWAccountMenuCell.h"

@interface HWAccountMenuCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleCell;
@property (weak, nonatomic) IBOutlet UIImageView *imageCell;

@end

@implementation HWAccountMenuCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}


- (void) setCellWithMenuDataModel:(HWAccountMenuDataModel*)dataModel
{
    self.titleCell.text = dataModel.title;
    [self.imageCell setImage:dataModel.image];
}

@end
