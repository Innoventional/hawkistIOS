//
//  myItemCellView.h
//  Hawkist
//
//  Created by Anton on 14.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

@protocol MyItemCellDelegate <NSObject>

- (void) updateParent;

- (void) showError:(NSError*)error;

@end

#import <UIKit/UIKit.h>

@interface MyItemCellView : UICollectionViewCell

@property (nonatomic,strong) id <MyItemCellDelegate> delegate;

@property (nonatomic, strong) HWItem *item;

@property (strong, nonatomic) NSMutableArray *items;

@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *discount;

@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UILabel *likesCount;

@property (strong, nonatomic) IBOutlet UILabel *commentsCount;

@property (strong, nonatomic) IBOutlet UILabel *platform;

@property (strong, nonatomic) IBOutlet UILabel *oldPrice;
@property (strong, nonatomic) IBOutlet UILabel *currentPrice;

@end
