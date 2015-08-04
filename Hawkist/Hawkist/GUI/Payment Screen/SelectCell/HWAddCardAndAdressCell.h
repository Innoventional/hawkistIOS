//
//  HWAddCardAndAdressCell.h
//  Hawkist
//
//  Created by User on 04.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWAddDataModel.h"

@protocol HWAddCardAndAdressCellDelegat;

@interface HWAddCardAndAdressCell : UITableViewCell

@property (nonatomic, weak) id<HWAddCardAndAdressCellDelegat> delegate;
- (void) setCellWithData:(HWAddDataModel*)dataModel;

@end


@protocol HWAddCardAndAdressCellDelegat <NSObject>

-(void) pressAddButton:(UIButton*)sender;

@end