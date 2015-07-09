//
//  FeedScreenCollectionViewCell.h
//  FeedScreen
//
//  Created by Evgen Bootcov on 25.06.15.
//  Copyright (c) 2015 Evgen Bootcov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWItem.h"
#import "HWUser.h"

@interface FeedScreenCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) HWItem *item;

@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;

@property (strong, nonatomic) IBOutlet UILabel *userNameLable;

@property (strong, nonatomic) NSMutableArray *items;

@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *skidkaTextfield;

@property (strong, nonatomic) IBOutlet UILabel *sellItemLabel;

@property (strong, nonatomic) IBOutlet UILabel *starsLable;

@property (strong, nonatomic) IBOutlet UILabel *opinionLable;

@property (strong, nonatomic) IBOutlet UIImageView *starImage;

@property (strong, nonatomic) IBOutlet UIImageView *speechImage;

@property (strong, nonatomic) IBOutlet UILabel *consoleNameLable;

@property (strong, nonatomic) IBOutlet UILabel *oldPriceLable;
@property (strong, nonatomic) IBOutlet UILabel *currentPriceLable;







@end
