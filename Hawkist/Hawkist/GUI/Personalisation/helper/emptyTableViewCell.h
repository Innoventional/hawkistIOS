//
//  emptyTableViewCell.h
//  Hawkist
//
//  Created by Anton on 09.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol emptyTableViewCell <NSObject>

- (void) setEnable:(NSString*)tagId;
- (void) setDisable:(NSString*)tagId;

@end

@interface emptyTableViewCell : UITableViewCell
@property (nonatomic,strong) id <emptyTableViewCell> delegate;
- (void) setup:(NSMutableArray*) tagCells;
@end
